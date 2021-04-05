//
//  FFLabel.h
//  FFText-oc
//
//  Created by jinfeng on 2021/3/16.
//

#import <UIKit/UIKit.h>
#import "FFTextAttribute.h"
#import "FFTextAttributeDelegate.h"
#import "FFTextAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFLabel : UIView

@property (nonatomic, copy, nullable) NSString *text;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, copy, nullable) NSAttributedString *attributeText;

/// 限定行数，默认1行。为0时不做限制
@property (nonatomic) NSInteger numberOfLines;

/// 文字内间距
@property (nonatomic) UIEdgeInsets contentInsets;

@property (nonatomic) NSTextAlignment textAlignment;

/// 文本垂直布局
@property (nonatomic) FFVerticalTextAlignment verticalTextAlignment;

@property (nonatomic) NSLineBreakMode lineBreakMode;

/// 自定义截断符
@property (nonatomic, strong, nullable) FFTextTruncationToken *truncationToken;

/// 阴影
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) CGFloat shadowBlurRadius;
@property (nonatomic, strong, nullable) UIColor *shadowColor;

/// 手势移动追踪，默认为NO
/// 在触发高亮时，如果gestureMoveTracking==YES，在移动手势中会改变高亮状态
@property (nonatomic) BOOL gestureMoveTracking;

/// 特殊字符串识别，默认detectorTypes==FFTextDetectorTypeNone
@property (nonatomic) FFTextDetectorTypes detectorTypes;

/// 当detectorTypes存在FFTextDetectorTypeCustom时，会获取自定义的正则来匹配
@property (nonatomic, copy, nullable) NSArray <NSString *>*detectorRegulars;

/// 绘制排除的区域
@property (nonatomic ,copy, nullable) NSArray<UIBezierPath *> * exclusionPaths;

/// 强制进行一次渲染
- (void)focusSetNeedsDisplay;

/// 点击富文本的代理，如点击事件，高亮事件
@property (nonatomic, weak, nullable) id<FFTextAttributeDelegate> delegate;

@end

@interface FFLabel (RichText)

- (void)addHighlightAction:(FFTextHighlight *)action;
- (void)removeHighlightActionWithRange:(NSRange)range;

- (void)addLink:(FFTextLink *)link;
- (void)removeLinkWithRange:(NSRange)range;

- (void)appendImage:(UIImage *)image size:(CGSize)size;
- (void)insertImage:(UIImage *)image size:(CGSize)size atLocation:(NSUInteger)location;
- (void)insertImage:(UIImage *)image size:(CGSize)size insets:(UIEdgeInsets)insets atLocation:(NSUInteger)location verticalTextAlignment:(FFVerticalTextAlignment)verticalTextAlignment;

- (void)appendCustomView:(UIView *)customView size:(CGSize)size;
- (void)insertCustomView:(UIView *)customView size:(CGSize)size atLocation:(NSUInteger)location;
- (void)insertCustomView:(UIView *)customView size:(CGSize)size insets:(UIEdgeInsets)insets atLocation:(NSUInteger)location verticalTextAlignment:(FFVerticalTextAlignment)verticalTextAlignment;

- (void)insertAttachment:(FFTextAttachment *)attachment atLocation:(NSUInteger)location;
- (void)removeAttachmentAtLocation:(NSUInteger)location;

@end

NS_ASSUME_NONNULL_END
