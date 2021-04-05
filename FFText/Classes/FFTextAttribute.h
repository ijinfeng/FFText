//
//  FFTextAttribute.h
//  FFText-oc
//
//  Created by jinfeng on 2021/3/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, FFVerticalTextAlignment) {
    FFVerticalTextAlignmentTop,
    FFVerticalTextAlignmentCenter,
    FFVerticalTextAlignmentBottom,
};

typedef NS_OPTIONS(NSInteger, FFTextDetectorTypes) {
    FFTextDetectorTypeNone = 0,
    FFTextDetectorTypeCustom = 1 << 1,
    FFTextDetectorTypePhoneNumber = 1 << 2,
    FFTextDetectorTypeEmail = 1 << 3,
    FFTextDetectorTypeLink = 1 << 4,
    FFTextDetectorTypeAll = FFTextDetectorTypeCustom| FFTextDetectorTypeLink| FFTextDetectorTypePhoneNumber| FFTextDetectorTypeEmail,
};

@class FFTextTouchAction;

@interface FFTextAttribute : NSObject

@property (nonatomic, assign) NSRange effectRange;
/// NSValue 是 CGRect
/// 因为会同时作用在多行，所以是个rect的数组
@property (nonatomic, strong) NSArray <NSValue *>*attributeRects;

@property (nonatomic, strong, nullable) NSAttributedString *effectString;

@property (nonatomic, strong, nullable) FFTextTouchAction *action;

@end

@interface FFTextLink : FFTextAttribute
@property (nonatomic, strong, nullable) UIColor *linkTextColor;
@property (nonatomic, nullable) UIColor *linkBackgroundColor;
@property (nonatomic) NSUnderlineStyle underlineStyle;
@property (nonatomic, strong, nullable) UIColor *underlineColor;
@end

/// 点击高亮
@interface FFTextHighlight : FFTextAttribute

@property (nonatomic, strong, nullable) UIFont *highlightFont;

@property (nonatomic, strong, nullable) UIColor *highlightTextColor;

@property (nonatomic, strong, nullable) UIColor *highlightBackgroundColor;

@property (nonatomic, strong, nullable) FFTextLink *link;

@end

/// 段落截断符
@interface FFTextTruncationToken : FFTextAttribute

@property (nonatomic, copy, nullable) NSAttributedString *truncationToken;

@end

typedef void(^_Nullable FFTextTouchActionCallback) (NSAttributedString *text, NSRange range);
/// 文本点击事件
@interface FFTextTouchAction : FFTextAttribute

@property (nonatomic, copy, nullable) FFTextTouchActionCallback touchAction;

@property (nonatomic, copy, nullable) FFTextTouchActionCallback longTouchAction;

@end


UIKIT_EXTERN NSString *const FFAttachmentToken;
UIKIT_EXTERN NSString *const FFTruncationToken;

/// Attachment like UIImageView、 UIView
/// 附件
UIKIT_EXTERN NSAttributedStringKey const FFAttachmentAttributeName;
/// 高亮背景色
UIKIT_EXTERN NSAttributedStringKey const FFHighlightBackgroundColorAttributeName;
/// 点击高亮
UIKIT_EXTERN NSAttributedStringKey const FFHighlightAttributeName;
/// 点击文本事件
UIKIT_EXTERN NSAttributedStringKey const FFTextTouchEventAttributeName;

NS_ASSUME_NONNULL_END
