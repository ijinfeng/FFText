//
//  FFLabel.m
//  FFText-oc
//
//  Created by jinfeng on 2021/3/16.
//

#import "FFLabel.h"
#import "FFTextRender.h"
#import "NSAttributedString+FFText.h"
#import "FFTextAttachment.h"
#import "FFWeakProxy.h"
#import "FFTextDetector.h"

static float const kMinimumLongPressDuration = 0.5;

@implementation FFLabel {
    NSMutableAttributedString *_renderText;
    FFTextRender *_render;
    CGPoint _touchLastPoint; // 点击的上一次点位
    FFTextHighlight *_currentHighlightAction;
    NSTimer *_longGestureTimer;
    BOOL _startRender; // 控制是否渲染
    FFTextDetector *_detector;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initializeLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _initializeLabel];
    }
    return self;
}

- (void)_initializeLabel {
    self.backgroundColor = [UIColor clearColor];
    _startRender = YES;
    _renderText = [self defaultAttributeText:nil];
    NSShadow *_shadow = [_renderText ff_shadow];
    _shadowColor = _shadow.shadowColor;
    _shadowOffset = _shadow.shadowOffset;
    _shadowBlurRadius =_shadow.shadowBlurRadius;
    _render = [FFTextRender new];
    _numberOfLines = 1;
    _textColor = [self defaultTextColor];
    _font = [self defaultFont];
    _textAlignment = NSTextAlignmentLeft;
    _verticalTextAlignment = FFVerticalTextAlignmentCenter;
    _lineBreakMode = NSLineBreakByWordWrapping;
    _gestureMoveTracking = NO;
    _detectorTypes = FFTextDetectorTypeNone;
    _detector = [FFTextDetector new];
    _detector.detectorTypes = _detectorTypes;
}

- (UIColor *)defaultTextColor {
    return [UIColor blackColor];
}

- (UIFont *)defaultFont {
    return [UIFont systemFontOfSize:17];
}

- (NSMutableAttributedString *)defaultAttributeText:(NSString *_Nullable)text {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text == nil ? @"" : text];
    [string ff_setLineBreakMode:_lineBreakMode];
    return string;
}

#pragma mark -- Render

- (void)setNeedsRender {
    [self preparRenderText];
    [self setNeedsDisplay];
}

- (void)preparRenderText {
    _render.layout.numberOfLines = _numberOfLines;
    _render.layout.insets = _contentInsets;
    _render.layout.truncationToken = _truncationToken.truncationToken;
    _render.layout.lineBreadkMode = _lineBreakMode;
    _render.layout.verticalTextAlignment = _verticalTextAlignment;
    NSMutableAttributedString *renderText = [_detector detectFromText:_renderText].mutableCopy;
    if (_currentHighlightAction) {
        if (_currentHighlightAction.highlightTextColor) {
            [renderText ff_setTextColor:_currentHighlightAction.highlightTextColor range:_currentHighlightAction.effectRange];
        }
        if (_currentHighlightAction.highlightBackgroundColor) {
            [renderText ff_setbackgroundColor:_currentHighlightAction.highlightBackgroundColor range:_currentHighlightAction.effectRange];
        }
        if (_currentHighlightAction.highlightFont) {
            [renderText ff_setFont:_currentHighlightAction.highlightFont range:_currentHighlightAction.effectRange];
        }
    }
    _render.layout.attributeText = renderText;
    _render.layout.exclusionPaths = _exclusionPaths;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize size = rect.size;
    _render.layout.size = size;
    if (_startRender) {
        [_render renderWithContext:context targetView:self];
    } else {
        [self invalidateIntrinsicContentSize];
    }
}

- (void)focusSetNeedsDisplay {
    _startRender = YES;
    [self invalidateIntrinsicContentSize];
    [self setNeedsRender];
}

#pragma mark -- Layout

- (CGSize)sizeThatFits:(CGSize)size {
    _render.layout.size = size;
    return [_render textRenderSuggestSizeFits:size];
}

- (CGSize)intrinsicContentSize {
    CGSize contentSize = self.bounds.size;
    if (contentSize.width <= 0) {
        contentSize.width = CGFLOAT_MAX;
        _startRender = NO;
    }
    if (contentSize.height <= 0) {
        contentSize.height = CGFLOAT_MAX;
        _startRender = NO;
    } else if (contentSize.height == _render.suggestSize.height) {
        contentSize.height = CGFLOAT_MAX;
        _startRender = YES;
    } else {
        _startRender = YES;
    }
    // 第一次计算的宽度是准确的
    _render.layout.size = contentSize;
    CGSize suggestSize = [_render textRenderSuggestSizeFits:contentSize];
    if (_startRender) {
        [self setNeedsRender];
    }
    return suggestSize;
}

#pragma mark -- Set

- (void)setText:(NSString *)text {
    if (text == _text || [text isEqualToString:_text]) {
        return;
    }
    _text = text;
    _renderText = [self defaultAttributeText:_text];
    [_renderText ff_setFont:_font ? _font : [self defaultFont]];
    [_renderText ff_setTextColor:_textColor ? _textColor : [self defaultTextColor]];
    [_renderText ff_setTextAlignment:_textAlignment];
    [_renderText ff_setLineBreakMode:_lineBreakMode];
    _truncationToken = nil;
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)setAttributeText:(NSAttributedString *)attributeText {
    if ([_renderText isEqualToAttributedString:attributeText]) {
        return;
    }
    _text = attributeText.string;
    _renderText = attributeText.mutableCopy;
    _font = attributeText.ff_font;
    _textColor = attributeText.ff_textColor;
    _lineBreakMode = attributeText.ff_lineBreakMode;
    _truncationToken = nil;
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)setTextColor:(UIColor *)textColor {
    if (!textColor) {
        textColor = [self defaultTextColor];
    }
    if (textColor == _textColor || [textColor isEqual:_textColor]) {
        return;
    }
    _textColor = textColor;
    [_renderText ff_setTextColor:_textColor];
    [self setNeedsRender];
}

- (void)setFont:(UIFont *)font {
    if (!font) {
        font = [self defaultFont];
    }
    if (_font == font || [font isEqual:_font]) {
        return;
    }
    _font = font;
    [_renderText ff_setFont:_font];
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if (_textAlignment == textAlignment) return;
    _textAlignment = textAlignment;
    [_renderText ff_setTextAlignment:_textAlignment];
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)setVerticalTextAlignment:(FFVerticalTextAlignment)verticalTextAlignment {
    if (_verticalTextAlignment == verticalTextAlignment) return;
    _verticalTextAlignment = verticalTextAlignment;
    [self setNeedsRender];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    if (_numberOfLines == numberOfLines || numberOfLines < 0) {
        return;
    }
    _numberOfLines = numberOfLines;
    NSLineBreakMode _lbk = _lineBreakMode;
    if (_lbk == NSLineBreakByTruncatingHead ||
        _lbk == NSLineBreakByTruncatingMiddle ||
        _lbk == NSLineBreakByTruncatingTail) {
        _lbk = NSLineBreakByWordWrapping;
    }
    [_renderText ff_setLineBreakMode:_lbk];
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(contentInsets, _contentInsets)) {
        return;
    }
    _contentInsets = contentInsets;
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    if (_lineBreakMode == lineBreakMode) {
        return;
    }
    _lineBreakMode = lineBreakMode;
    NSLineBreakMode _lbk = _lineBreakMode;
    if (_lbk == NSLineBreakByTruncatingHead ||
        _lbk == NSLineBreakByTruncatingMiddle ||
        _lbk == NSLineBreakByTruncatingTail) {
        _lbk = NSLineBreakByWordWrapping;
    }
    [_renderText ff_setLineBreakMode:_lbk];
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)setTruncationToken:(FFTextTruncationToken *)truncationToken {
    if (truncationToken) {
        if ([_truncationToken.truncationToken isEqualToAttributedString:truncationToken.truncationToken]) {
            return;
        }
        if (_lineBreakMode != NSLineBreakByTruncatingHead &&
            _lineBreakMode != NSLineBreakByTruncatingMiddle &&
            _lineBreakMode != NSLineBreakByTruncatingTail) {
            _lineBreakMode = NSLineBreakByTruncatingTail;
        }
        truncationToken.effectRange = NSMakeRange(0, truncationToken.truncationToken.length);
        NSMutableAttributedString *_tokenText = [truncationToken.truncationToken mutableCopy];
        [_tokenText ff_setTextTouchEvent:truncationToken.action];
        truncationToken.truncationToken = _tokenText;
        [_renderText ff_setLineBreakMode:NSLineBreakByWordWrapping];
    } else if (_truncationToken == truncationToken) return;
    _truncationToken = truncationToken;
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    if (CGSizeEqualToSize(_shadowOffset, shadowOffset)) return;
    _shadowOffset = shadowOffset;
    NSShadow *shadow = [_renderText ff_shadow];
    if (!shadow) {
        shadow = [[NSShadow alloc] init];
    }
    shadow.shadowOffset = _shadowOffset;
    [_renderText ff_setShadow:shadow];
    [self setNeedsRender];
}

- (void)setShadowBlurRadius:(CGFloat)shadowBlurRadius {
    if (_shadowBlurRadius == shadowBlurRadius) return;
    _shadowBlurRadius = shadowBlurRadius;
    NSShadow *shadow = [_renderText ff_shadow];
    if (!shadow) {
        shadow = [[NSShadow alloc] init];
    }
    shadow.shadowBlurRadius = _shadowBlurRadius;
    [_renderText ff_setShadow:shadow];
    [self setNeedsRender];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    if ([_shadowColor isEqual:shadowColor] || _shadowColor == shadowColor) return;
    _shadowColor = shadowColor;
    NSShadow *shadow = [_renderText ff_shadow];
    if (!shadow) {
        shadow = [[NSShadow alloc] init];
    }
    shadow.shadowColor = _shadowColor;
    [_renderText ff_setShadow:shadow];
    [self setNeedsRender];
}

- (void)setExclusionPaths:(NSArray<UIBezierPath *> *)exclusionPaths {
    if ([_exclusionPaths isEqualToArray:exclusionPaths] || _exclusionPaths == exclusionPaths) {
        return;
    }
    _exclusionPaths = exclusionPaths;
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)setDetectorTypes:(FFTextDetectorTypes)detectorTypes {
    if (_detectorTypes == detectorTypes) return;
    _detectorTypes = detectorTypes;
    _detector.detectorTypes = _detectorTypes;
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)setDetectorRegulars:(NSArray<NSString *> *)detectorRegulars {
    if ([_detectorRegulars isEqualToArray:detectorRegulars] || _detectorRegulars == detectorRegulars) return;
    _detectorRegulars = detectorRegulars;
    _detector.detectorRegulars = detectorRegulars;
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

#pragma mark -- Get

- (NSAttributedString *)attributeText {
    return _renderText.copy;
}

#pragma mark -- RG

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    _touchLastPoint = [touch locationInView:touch.view];
    
    // truncation
    FFTextTouchAction *action = [_render contrainersEventTouchIn:_touchLastPoint];
    if (action) {
        if (action.touchAction) {
            action.touchAction(action.effectString, action.effectRange);
        }
        if (action.longTouchAction ||
            (self.delegate && [self.delegate respondsToSelector:@selector(label:didLongPressAttribute:)])) {
            [self addTimerWithAction:action];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(label:didClickAttribute:)]) {
            [self.delegate label:self didClickAttribute:action];
        }
    }
    
    // highlight
    FFTextHighlight *highlight = [_render containersHighlightActionIn:_touchLastPoint];
    if (highlight) {
        _currentHighlightAction = highlight;
        [self setNeedsRender];
        [self invalidateIntrinsicContentSize];
        if (self.delegate && [self.delegate respondsToSelector:@selector(label:didClickAttribute:)]) {
            [self.delegate label:self didClickAttribute:highlight];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeHighlightAction];
    [self removeTimer];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint movePoint = [touch locationInView:touch.view];
    if (CGPointEqualToPoint(_touchLastPoint, movePoint)) {
        return;
    }
    _touchLastPoint = movePoint;
    
    if (_gestureMoveTracking) {
        FFTextHighlight *action = [_render containersHighlightActionIn:movePoint];
        if (action != _currentHighlightAction) {
            _currentHighlightAction = action;
            [self setNeedsRender];
            [self invalidateIntrinsicContentSize];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeHighlightAction];
    [self removeTimer];
}

- (void)removeHighlightAction {
    if (_currentHighlightAction) {
        _currentHighlightAction = nil;
        [self setNeedsRender];
        [self invalidateIntrinsicContentSize];
    }
}

#pragma mark -- Timer

- (void)addTimerWithAction:(FFTextTouchAction *)action {
    [self removeTimer];
    _longGestureTimer = [NSTimer scheduledTimerWithTimeInterval:kMinimumLongPressDuration target:[FFWeakProxy weakProxyWithTarget:self] selector:@selector(timerForLongGestureAwake:) userInfo:action repeats:NO];
}

- (void)removeTimer {
    [_longGestureTimer invalidate];
    _longGestureTimer = nil;
}

- (void)timerForLongGestureAwake:(NSTimer *)timer {
    id userInfo = [timer userInfo];
    if ([userInfo isKindOfClass:[FFTextTouchAction class]]) {
        FFTextTouchAction *action = userInfo;
        if (action.longTouchAction) {
            action.longTouchAction(action.effectString, action.effectRange);
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(label:didLongPressAttribute:)]) {
            [self.delegate label:self didLongPressAttribute:action];
        }
    }
}

@end


@implementation FFLabel (RichText)

- (void)addHighlightAction:(FFTextHighlight *)action {
    if (!action) { return; }
    [_renderText ff_setTextHighlightAction:action];
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)removeHighlightActionWithRange:(NSRange)range {
    [_renderText ff_removeTextHighlightActionWithRange:range];
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)addLink:(FFTextLink *)link {
    [_renderText ff_setTextLink:link];
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)removeLinkWithRange:(NSRange)range {
    [_renderText ff_removeTextLinkWithRange:range];
    [self setNeedsRender];
}

- (void)appendImage:(UIImage *)image size:(CGSize)size {
    [self insertImage:image size:size atLocation:_renderText.length];
}

- (void)insertImage:(UIImage *)image size:(CGSize)size atLocation:(NSUInteger)location {
    [self insertImage:image size:size insets:UIEdgeInsetsZero atLocation:location verticalTextAlignment:FFVerticalTextAlignmentBottom];
}

- (void)insertImage:(UIImage *)image size:(CGSize)size insets:(UIEdgeInsets)insets atLocation:(NSUInteger)location verticalTextAlignment:(FFVerticalTextAlignment)verticalTextAlignment {
    if (!image) { return; }
    CGSize _size = size;
    if (_size.width == 0 || _size.height == 0) {
        _size = image.size;
    }
    [self insertTextAttachment:image size:_size insets:insets atLocation:location verticalTextAlignment:verticalTextAlignment];
}

- (void)appendCustomView:(UIView *)customView size:(CGSize)size {
    [self insertCustomView:customView size:size atLocation:_renderText.length];
}

- (void)insertCustomView:(UIView *)customView size:(CGSize)size atLocation:(NSUInteger)location {
    [self insertCustomView:customView size:size insets:UIEdgeInsetsZero atLocation:location verticalTextAlignment:FFVerticalTextAlignmentBottom];
}

- (void)insertCustomView:(UIView *)customView size:(CGSize)size insets:(UIEdgeInsets)insets atLocation:(NSUInteger)location verticalTextAlignment:(FFVerticalTextAlignment)verticalTextAlignment {
    if (!customView) return;
    CGSize _size = size;
    if (_size.width == 0 || _size.height == 0) {
        _size = customView.frame.size;
    }
    if (_size.width == 0 || _size.height == 0) {
        return;
    }
    [self insertTextAttachment:customView size:_size insets:insets atLocation:location verticalTextAlignment:verticalTextAlignment];
}

- (void)insertTextAttachment:(id)textAttachment size:(CGSize)size insets:(UIEdgeInsets)insets atLocation:(NSUInteger)location verticalTextAlignment:(FFVerticalTextAlignment)verticalTextAlignment {
    if (!textAttachment) return;
    if (size.width == 0 || size.height == 0) {
        return;
    }
    if (location > _renderText.length) {
        location = _renderText.length;
    }
    FFTextAttachment *attachment = [FFTextAttachment new];
    attachment.font = _font ? _font : [self defaultFont];
    attachment.verticalTextAlignment = verticalTextAlignment;
    attachment.content = textAttachment;
    attachment.size = size;
    attachment.insets = insets;
    attachment.insertLocation = location;
    [self insertAttachment:attachment atLocation:location];
}

- (void)insertAttachment:(id)attachment atLocation:(NSUInteger)location {
    [_renderText ff_setTextAttachment:attachment atLocation:location];
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

- (void)removeAttachmentAtLocation:(NSUInteger)location {
    [_renderText ff_removeTextAttachmentAtLocation:location];
    [self setNeedsRender];
    [self invalidateIntrinsicContentSize];
}

@end


