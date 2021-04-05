//
//  FFTextAttribute.m
//  FFText-oc
//
//  Created by jinfeng on 2021/3/22.
//

#import "FFTextAttribute.h"
#import "NSAttributedString+FFText.h"

@implementation FFTextAttribute

- (FFTextTouchAction *)action {
    if (!_action) {
        _action = [FFTextTouchAction new];
    }
    _action.effectRange = self.effectRange;
    return _action;
}

- (void)setEffectRange:(NSRange)effectRange {
    _effectRange = effectRange;
    if (_action) {
        _action.effectRange = effectRange;
    }
}

@end

@implementation FFTextLink

- (instancetype)init {
    self = [super init];
    if (self) {
        _underlineStyle = NSUnderlineStyleSingle;
    }
    return self;
}

@end

@implementation FFTextHighlight

- (instancetype)init {
    self = [super init];
    if (self) {
        _link = [FFTextLink new];
        _highlightBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    }
    return self;
}

- (void)setEffectRange:(NSRange)effectRange {
    [super setEffectRange:effectRange];
    self.link.effectRange = effectRange;
}

@end

@implementation FFTextTruncationToken

@end

@implementation FFTextTouchAction

@end

NSString *const FFAttachmentToken = @"\uFFFC";
NSString *const FFTruncationToken = @"\u2026";

NSAttributedStringKey const FFAttachmentAttributeName = @"FFAttachment";
NSAttributedStringKey const FFHighlightBackgroundColorAttributeName = @"FFHighlightBackgroundColor";
NSAttributedStringKey const FFHighlightAttributeName = @"FFHighlight";
NSAttributedStringKey const FFTextTouchEventAttributeName = @"FFTextTouchEvent";
