//
//  FFLine.m
//  FFText-oc
//
//  Created by jinfeng on 2021/3/22.
//

#import "FFLine.h"
#import "FFTextAttachment.h"

@implementation FFLine {
    NSUInteger _row;
    NSMutableArray *_attachments;
    NSMutableDictionary *_highlightDics;
    NSMutableDictionary *_touchEventDics;
}

- (void)dealloc {
    if (_lineRef) {
        CFRelease(_lineRef);
    }
}

+ (instancetype)line:(CTLineRef)lineRef inRenderFrame:(nonnull CTFrameRef)frameRef originPoint:(CGPoint)point  atRow:(NSUInteger)row {
    if (!lineRef) return nil;
    CFRetain(lineRef);
    FFLine *line = [FFLine new];
    line->_lineRef = lineRef;
    line->_row = row;
    line->_originPoint = point;
    line->_attachments = [NSMutableArray array];
    line->_highlightDics = [NSMutableDictionary dictionary];
    line->_touchEventDics = [NSMutableDictionary dictionary];
    
    CGFloat ascent; // 上行高
    CGFloat descent; // 下行高
    CGFloat leading; // 行间距
    CGFloat width = CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
    
    // 字高
    CGFloat glyphHeight = ascent + ABS(descent);
    CGFloat lineHeight = glyphHeight + leading;
    
    line->_ascent = ascent;
    line->_descent = descent;
    line->_leading = leading;
    line->_lineHeight = lineHeight;
    line->_width = width;
    
    CGRect bounds = CTLineGetBoundsWithOptions(lineRef, 0);
    line->_frame = CGRectMake(point.x, point.y - ABS(descent) + leading, bounds.size.width, bounds.size.height);
    
    CFRange range = CTLineGetStringRange(lineRef);
    line->_range = NSMakeRange(range.location, range.length);
    
    CFArrayRef runs = CTLineGetGlyphRuns(lineRef);
    NSUInteger runCount = CFArrayGetCount(runs);
    for (int i = 0; i < runCount; i++) {
        CTRunRef runRef = CFArrayGetValueAtIndex(runs, i);
        NSDictionary *attributes = (id)CTRunGetAttributes(runRef);
        if (!attributes) {
            continue;
        }
        // 附件
        CTRunDelegateRef delegateRef = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
        if (delegateRef) {
            id attachment = (id)CTRunDelegateGetRefCon(delegateRef);
            if ([attachment isKindOfClass:[FFTextAttachment class]]) {
                FFTextAttachment *_attachment = (id)attachment;
                CGFloat offset_x = CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL);
                _attachment.drawOrigin = CGPointMake(offset_x + line.originPoint.x, line.originPoint.y - _attachment.descent); // 原点在左下角
                [line->_attachments addObject:_attachment];
            }
        }
        // FFAttribute Highlight
        extern NSAttributedStringKey const FFHighlightActionAttributeName;
        FFTextHighlight *highlight = [attributes valueForKey:FFHighlightAttributeName];
        if (highlight) {
            NSString *key = NSStringFromRange(highlight.effectRange);
            if (key.length > 0 && !line->_highlightDics[key]) {
                [line->_highlightDics setObject:highlight forKey:key];
                // 当取到第一个run时，就向后获取所有相关的run，计算attribute的宽度
                CGRect attributeRect = [line getAttributeRectWithFirstRunRef:runRef currentIndex:i runs:runs runsCount:runCount attributeName:FFHighlightAttributeName];
                NSMutableArray *attributeRects = highlight.attributeRects.mutableCopy;
                if (attributeRects == nil) {
                    attributeRects = [NSMutableArray array];
                }
                [attributeRects addObject:[NSValue valueWithCGRect:attributeRect]];
                highlight.attributeRects = attributeRects.copy;
                // Highlight touch events
                if (highlight.action) {
                    if (key.length > 0) {
                        [line->_touchEventDics setObject:highlight.action forKey:key];
                    }
                    NSMutableArray *attributeRects = highlight.action.attributeRects.mutableCopy;
                    if (attributeRects == nil) {
                        attributeRects = [NSMutableArray array];
                    }
                    [attributeRects addObject:[NSValue valueWithCGRect:attributeRect]];
                    highlight.action.attributeRects = attributeRects.copy;
                }
            }
        }
        // FFAttribute Event
        FFTextTouchAction *action = [attributes valueForKey:FFTextTouchEventAttributeName];
        if (action) {
            NSString *key = NSStringFromRange(action.effectRange);
            if (key.length > 0 && !line->_touchEventDics[key]) {
                [line->_touchEventDics setObject:action forKey:key];
                CGRect attributeRect = [line getAttributeRectWithFirstRunRef:runRef currentIndex:i runs:runs runsCount:runCount attributeName:FFTextTouchEventAttributeName];
                NSMutableArray *attributeRects = action.attributeRects.mutableCopy;
                if (attributeRects == nil) {
                    attributeRects = [NSMutableArray array];
                }
                [attributeRects addObject:[NSValue valueWithCGRect:attributeRect]];
                action.attributeRects = attributeRects.copy;
            }
        }
    }
    
    return line;
}

- (CGRect)getAttributeRectWithFirstRunRef:(CTRunRef)runRef currentIndex:(int)index runs:(CFArrayRef)runs runsCount:(NSUInteger)runCount attributeName:(NSString *)attributeName {
    CGFloat effectWidth = [self getRunWidthWithCurrentRunRef:runRef attributeName:attributeName];
    CGFloat offset_x = CTLineGetOffsetForStringIndex(self.lineRef, CTRunGetStringRange(runRef).location, NULL);
    // 继续取出下一个来
    for (int i = index + 1; i < runCount; i++) {
        CTRunRef nextRunRef = CFArrayGetValueAtIndex(runs, i);
        CGFloat width = [self getRunWidthWithCurrentRunRef:nextRunRef attributeName:attributeName];
        if (width <= 0) {
            break;
        }
        effectWidth += width;
    }
    CGRect attributeRect = CGRectMake(offset_x + self.frame.origin.x, self.frame.origin.y, effectWidth, self.lineHeight);
    return attributeRect;
}

- (CGFloat)getRunWidthWithCurrentRunRef:(CTRunRef)runRef attributeName:(NSString *)attributeName {
    if (!runRef) return 0;
    NSDictionary *attributes = (id)CTRunGetAttributes(runRef);
    if (!attributes) return 0;
    id attribute = [attributes valueForKey:attributeName];
    if (!attribute) return 0;
    CGFloat effectWidth = CTRunGetTypographicBounds(runRef, CFRangeMake(0, 0), NULL, NULL, NULL);
    return effectWidth;
}

- (NSArray<FFTextHighlight *> *)highlights {
    return _highlightDics.allValues;
}

- (NSArray<FFTextTouchAction *> *)touchEvents {
    return _touchEventDics.allValues;
}

@end
