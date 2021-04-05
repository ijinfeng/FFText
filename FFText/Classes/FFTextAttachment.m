//
//  FFTextAttachment.m
//  FFText-oc
//
//  Created by jinfeng on 2021/3/22.
//

#import "FFTextAttachment.h"
#import "NSAttributedString+FFText.h"

@implementation FFTextAttachment {
    FFTextAttachmentType _attachmentType;
    CGFloat _ascent;
    CGFloat _descent;
    CGFloat _width;
}

static CGFloat FFAscentCallBacks(void * ref) {
    FFTextAttachment *a = (__bridge FFTextAttachment *)ref;
    return a.ascent;
}

static CGFloat FFDescentCallBacks(void * ref) {
    FFTextAttachment *a = (__bridge FFTextAttachment *)ref;
    return a.descent;
}

static CGFloat FFWidthCallBacks(void * ref) {
    FFTextAttachment *a = (__bridge FFTextAttachment *)ref;
    return a.width;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _verticalTextAlignment = FFVerticalTextAlignmentBottom;
        _attachmentType = FFTextAttachmentCustomView;
        _insets = UIEdgeInsetsZero;
    }
    return self;
}

- (NSAttributedString *)createTextAttachmentString {
    [self updateRunDelegateCallbacks];
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.getAscent = FFAscentCallBacks;
    callbacks.getDescent = FFDescentCallBacks;
    callbacks.getWidth = FFWidthCallBacks;
    CTRunDelegateRef delegateRef = CTRunDelegateCreate(&callbacks, (__bridge void *)(self));
    
    extern NSString *const FFAttachmentToken;
    NSMutableAttributedString *attachmentString = [[NSMutableAttributedString alloc] initWithString:FFAttachmentToken];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attachmentString, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegateRef);
    CFRelease(delegateRef);
    return attachmentString;
}

- (CGFloat)ascent {
    return _ascent;
}

- (CGFloat)descent {
    return _descent;
}

- (CGFloat)width {
    return _width;
}

- (void)updateRunDelegateCallbacks {
    _width = self.size.width + self.insets.left + self.insets.right;
    CGFloat height = self.size.height;
    if (self.verticalTextAlignment == FFVerticalTextAlignmentTop) {
        _ascent = self.font.ascender;
        _descent = height - self.font.ascender;
    } else if (self.verticalTextAlignment == FFVerticalTextAlignmentCenter) {
        CGFloat fontHeight = self.font.ascender - self.font.descender;
        CGFloat yOffset = self.font.ascender - fontHeight * 0.5;
        _ascent = height * 0.5 + yOffset;
        _descent = height - _ascent;
    } else {
        _ascent = height;
        _descent = 0;
    }
}

- (void)setContent:(id)content {
    _content = content;
    if ([content isKindOfClass:[UIImage class]]) {
        _attachmentType = FFTextAttachmentImage;
    } else {
        _attachmentType = FFTextAttachmentCustomView;
    }
}

- (FFTextAttachmentType)attachmentType {
    return _attachmentType;
}

@end
