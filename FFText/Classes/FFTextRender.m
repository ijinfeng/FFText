//
//  FFTextRender.m
//  FFText-oc
//
//  Created by jinfeng on 2021/3/19.
//

#import "FFTextRender.h"
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import "FFLine.h"
#import "NSAttributedString+FFText.h"

@implementation FFTextRender {
    CGContextRef _context;
    CTFrameRef _frameRef;
    CTFramesetterRef _framesetterRef;
    NSUInteger _lineCount;
    NSMutableArray *_lines;
    FFLine *_truncationLine; // 带有截断符的行
    NSArray *_attachments;
    NSArray *_highlights;
    NSArray *_touchEvents;
    NSMutableAttributedString *_renderText; // 真正要绘制的富文本
    CGFloat _fixBaselineY; // 根据垂直排版方式，修正每行的基线
}

- (void)dealloc {
    if (_frameRef) {
        CFRelease(_frameRef);
    }
    if (_framesetterRef) {
        CFRelease(_framesetterRef);
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _layout = [FFTextLayoutDescription new];
        _lineCount = 0;
        _lines = [NSMutableArray array];
    }
    return self;
}

- (void)renderWithContext:(CGContextRef)context targetView:(nonnull UIView *)targetView {
    _context = context;
    [self translateCTM];
    _renderText = _layout.attributeText.mutableCopy;
    
    if (_frameRef) CFRelease(_frameRef);
    if (_framesetterRef) CFRelease(_framesetterRef);
    
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_renderText);
    // 文字绘制区
    CGMutablePathRef pathRef = [_layout createRenderPathIgnoreExclusionPaths:NO];
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, _renderText.length), pathRef, NULL);
    _frameRef = frameRef;
    _framesetterRef = framesetterRef;
    CFRelease(pathRef);
    // 取出所有的行
    [self handleAllLines];
    // 自定义内容绘制
    [self _renderAttributeContentWithTargetView:targetView];
    // 绘制富文本
    [self _render];
}

- (void)translateCTM {
    CGContextSetTextMatrix(_context, CGAffineTransformIdentity);
    CGContextTranslateCTM(_context, 0, _layout.size.height);
    CGContextScaleCTM(_context, 1.0, -1.0);
}

- (void)renderSaveBlock:(void(^) (void))save {
    CGContextSaveGState(_context);
    if (save) {
        save();
    }
    CGContextRestoreGState(_context);
}

- (void)handleAllLines {
    CFArrayRef linesRef = CTFrameGetLines(_frameRef);
    _lineCount = CFArrayGetCount(linesRef);
    // baseline的原点
    CGPoint origins[_lineCount];
    CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, _lineCount), origins);
    
    [_lines removeAllObjects];
    [_highlights enumerateObjectsUsingBlock:^(FFTextHighlight * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.attributeRects = @[];
    }];
    [_touchEvents enumerateObjectsUsingBlock:^(FFTextTouchAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.attributeRects = @[];
    }];
    [_attachments enumerateObjectsUsingBlock:^(FFTextAttachment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.attachmentType == FFTextAttachmentCustomView) {
            [obj.content removeFromSuperview];
        }
    }];
    _attachments = nil;
    _highlights = nil;
    _touchEvents = nil;
    _truncationLine = nil;
    _fixBaselineY = 0;
    
    NSMutableDictionary *highlightDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *touchEventDic = [NSMutableDictionary dictionary];
    NSMutableArray *attachments = [NSMutableArray array];
    
    NSInteger count = _lineCount;
    if (_layout.numberOfLines < _lineCount && _layout.numberOfLines > 0) {
        count = _layout.numberOfLines;
    }
    
    NSAttributedString * truncationTokenText = nil;
    if (_layout.truncationToken) {
        truncationTokenText = _layout.truncationToken;
    } else if (_layout.lineBreadkMode == NSLineBreakByTruncatingHead ||
               _layout.lineBreadkMode == NSLineBreakByTruncatingMiddle ||
               _layout.lineBreadkMode == NSLineBreakByTruncatingTail) {
        truncationTokenText = [[NSAttributedString alloc] initWithString:@"…" attributes:[_renderText ff_attributes]];
    }
    
    NSUInteger textLength = _renderText.length;
    
    for (int i = 0; i < count; i++) {
        CTLineRef lineRef = CFArrayGetValueAtIndex(linesRef, i);
        FFLine *line = [FFLine line:lineRef inRenderFrame:_frameRef originPoint:origins[i] atRow:i];
        NSUInteger currentTextLength = line.range.location + line.range.length;
        BOOL needShowTruncation = currentTextLength < textLength;
        // 最后一行，没到总字数，并且有自定义的截断符
        // 截断在使用自动布局的模糊边距时会有问题，这里要注意，比如lessthen... grearthan
        // 如果使用约束，那么直接设置固定约束，equalTo
        // TODO:jinfeng fix 约束布局时的截断判断问题，主要是因为约束布局导致的size不准导致文本长度不对引起的
        if (i == count - 1 && needShowTruncation && truncationTokenText) {
            NSMutableAttributedString *drawLineString = [[NSMutableAttributedString alloc] initWithAttributedString:[_renderText attributedSubstringFromRange:line.range]];
            CTLineTruncationType type = kCTLineTruncationEnd;
            NSRange tokenRange = {};
            if (_layout.lineBreadkMode == NSLineBreakByTruncatingHead) {
                type = kCTLineTruncationStart;
                [drawLineString insertAttributedString:truncationTokenText atIndex:0];
                tokenRange = NSMakeRange(line.range.location, truncationTokenText.length);
            } else if (_layout.lineBreadkMode == NSLineBreakByTruncatingMiddle) {
                type = kCTLineTruncationMiddle;
                NSUInteger targetIndex = drawLineString.length / 2;
                if (drawLineString.size.width > _layout.size.width) {
                    targetIndex = (NSUInteger)(_layout.size.width / drawLineString.size.width * 0.5 * drawLineString.length);
                }
                [drawLineString insertAttributedString:truncationTokenText atIndex:targetIndex];
                tokenRange = NSMakeRange(line.range.location + targetIndex, truncationTokenText.length);
            } else {
                type = kCTLineTruncationEnd;
                [drawLineString appendAttributedString:truncationTokenText];
                tokenRange = NSMakeRange(line.range.location + line.range.length, truncationTokenText.length);
            }
            FFTextTouchAction *action = [truncationTokenText ff_touchAction];
            if (action) {
                action.effectRange = tokenRange;
                action.effectString = truncationTokenText;
            }
            CTLineRef drawLineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)drawLineString);
            CTLineRef tokenLineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationTokenText);
            CTLineRef truncationLineRef = CTLineCreateTruncatedLine(drawLineRef, _layout.size.width - _layout.insets.right - _layout.insets.left, type, tokenLineRef);
            CFRelease(drawLineRef);
            CFRelease(tokenLineRef);
            if (truncationLineRef) {
                _truncationLine = [FFLine line:truncationLineRef inRenderFrame:_frameRef originPoint:origins[i] atRow:i];
            }
        }
        [_lines addObject:line];
        
        // 取出所有附件
        if (line.attachments.count > 0) {
            for (int j = 0; j < line.attachments.count; j++) {
                FFTextAttachment *attachment = line.attachments[j];
                [attachments addObject:attachment];
            }
        }
        
        // 取出所有高亮事件
        if (line.highlights.count > 0) {
            // 多行公用一个事件，需要去重
            for (int j = 0; j < line.highlights.count; j++) {
                FFTextHighlight *highlight = line.highlights[j];
                highlight.effectString = [_renderText attributedSubstringFromRange:highlight.effectRange];
                NSString *key = NSStringFromRange(highlight.effectRange);
                if (key.length > 0) {
                    [highlightDic setObject:highlight forKey:key];
                }
            }
        }
        
        // 取出所有点击事件
        if (line.touchEvents.count > 0) {
            for (int j = 0; j < line.touchEvents.count; j++) {
                FFTextTouchAction *touchEvent = line.touchEvents[j];
                if (!touchEvent.effectString) {
                    touchEvent.effectString = [_renderText attributedSubstringFromRange:touchEvent.effectRange];
                }
                NSString *key = NSStringFromRange(touchEvent.effectRange);
                if (key.length > 0) {
                    [touchEventDic setObject:touchEvent forKey:key];
                }
            }
        }
        
        // 截断行的事件
        if (_truncationLine.touchEvents.count > 0) {
            for (int j = 0; j < _truncationLine.touchEvents.count; j++) {
                FFTextTouchAction *touchEvent = _truncationLine.touchEvents[j];
                if (!touchEvent.effectString) {
                    touchEvent.effectString = [_renderText attributedSubstringFromRange:touchEvent.effectRange];
                }
                NSString *key = NSStringFromRange(touchEvent.effectRange);
                if (key.length > 0) {
                    [touchEventDic setObject:touchEvent forKey:key];
                }
            }
        }
    }
    _attachments = attachments.copy;
    _highlights = highlightDic.allValues;
    _touchEvents = touchEventDic.allValues;
    
    // 获取最后一行的最大y
    FFLine *line = _lines.lastObject;
    if (_layout.verticalTextAlignment == FFVerticalTextAlignmentBottom) {
        if (_truncationLine) {
            _fixBaselineY = _truncationLine.originPoint.y - _truncationLine.descent;
        } else {
            _fixBaselineY = line.originPoint.y - line.descent;
        }
    } else if (_layout.verticalTextAlignment == FFVerticalTextAlignmentCenter) {
        if (_truncationLine) {
            _fixBaselineY = _truncationLine.originPoint.y - _truncationLine.descent;
        } else {
            _fixBaselineY = line.originPoint.y - line.descent;
        }
        _fixBaselineY = (_layout.size.height - (_layout.size.height - _fixBaselineY)) / 2;
    } else {
        _fixBaselineY = 0;
    }
}

- (void)_renderAttributeContentWithTargetView:(UIView *)targetView {
    // 附件渲染
    for (int j = 0; j < _attachments.count; j++) {
        FFTextAttachment *attachment = _attachments[j];
        if (!attachment.content) {
            continue;
        }
        if (attachment.attachmentType == FFTextAttachmentImage) {
            CGRect drawRect = CGRectMake(attachment.drawOrigin.x + _layout.insets.left, attachment.drawOrigin.y - _fixBaselineY + _layout.insets.bottom, attachment.size.width, attachment.size.height);
            UIImage *drawImage = attachment.content;
            CGContextDrawImage(_context, drawRect, drawImage.CGImage);
        } else {
            CGRect drawRect = CGRectMake(attachment.drawOrigin.x + attachment.insets.left + _layout.insets.left, _layout.size.height - attachment.size.height - attachment.drawOrigin.y + _fixBaselineY + attachment.insets.top - _layout.insets.bottom, attachment.size.width, attachment.size.height);
            UIView *customView = attachment.content;
            if (!customView) {
                continue;
            }
            customView.frame = drawRect;
            [targetView addSubview:customView];
        }
    }
}

- (void)_render {
    for (int i = 0; i < _lines.count; i++) {
        FFLine *line = _lines[i];
        if (i == _lines.count - 1 && _truncationLine) {
            line = _truncationLine;
        }
        CGContextSetTextPosition(_context, line.originPoint.x + _layout.insets.left, line.originPoint.y - _fixBaselineY + _layout.insets.bottom);
        CTLineDraw(line.lineRef, _context);
    }
}

- (FFTextHighlight *)containersHighlightActionIn:(CGPoint)point {
    for (int i = 0; i < _highlights.count; i++) {
        FFTextHighlight *highlight = _highlights[i];
        for (int j = 0; j < highlight.attributeRects.count; j++) {
            CGRect attributeRect = [highlight.attributeRects[j] CGRectValue]; // 获取到的rect的原点在左下角
            CGRect transfer = CGRectMake(attributeRect.origin.x + _layout.insets.left, _layout.size.height - attributeRect.origin.y - attributeRect.size.height + _fixBaselineY - _layout.insets.bottom, attributeRect.size.width, attributeRect.size.height);
            if (CGRectContainsPoint(transfer, point)) {
                return highlight;
            }
        }
    }
    return nil;
}

- (FFTextTouchAction *)contrainersEventTouchIn:(CGPoint)point {
    for (int i = 0; i < _touchEvents.count; i++) {
        FFTextTouchAction *action = _touchEvents[i];
        for (int j = 0; j < action.attributeRects.count; j++) {
            CGRect attributeRect = [action.attributeRects[j] CGRectValue]; // 获取到的rect的原点在左下角
            CGRect transfer = CGRectMake(attributeRect.origin.x + _layout.insets.left, _layout.size.height - attributeRect.origin.y - attributeRect.size.height + _fixBaselineY - _layout.insets.bottom, attributeRect.size.width, attributeRect.size.height);
            if (CGRectContainsPoint(transfer, point)) {
                return action;
            }
        }
    }
    return nil;
}

- (CGSize)textRenderSuggestSizeFits:(CGSize)size {
    _renderText = _layout.attributeText.mutableCopy;
    
    if (_frameRef) CFRelease(_frameRef);
    if (_framesetterRef) CFRelease(_framesetterRef);
    
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_renderText);
    // 文字绘制区
    CGMutablePathRef pathRef = [_layout createRenderPathIgnoreExclusionPaths:NO];
    if (size.width == CGFLOAT_MAX || size.height == CGFLOAT_MAX) {
        CFRelease(pathRef);
        pathRef = [_layout createRenderPathIgnoreExclusionPaths:YES];
    }
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, _renderText.length), pathRef, NULL);
    _frameRef = frameRef;
    _framesetterRef = framesetterRef;
    CFRelease(pathRef);
    // 取出所有的行
    [self handleAllLines];
    
    CFRange range = {};
    FFLine *line = _lines.lastObject;
    range = CFRangeMake(0, line.range.location + line.range.length);
    CGSize constraints = size;
    constraints = CGSizeMake(size.width - _layout.insets.left - _layout.insets.right, size.height - _layout.insets.top - _layout.insets.bottom);
    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetterRef, range, NULL, constraints, NULL);
    suggestSize = CGSizeMake(suggestSize.width, suggestSize.height + _layout.insets.top + _layout.insets.bottom);
    self->_suggestSize = suggestSize;
    return suggestSize;
}

@end
