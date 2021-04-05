//
//  NSAttributedString+FFText.h
//  FFText-oc
//
//  Created by jinfeng on 2021/3/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FFTextAttachment.h"
#import "FFTextAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (FFText)

- (NSRange)ff_wholeRange;

- (NSDictionary *)ff_attributes;

- (UIFont *)ff_font;

- (UIColor *)ff_textColor;

- (NSParagraphStyle *)ff_paragraph;

- (UIColor *)ff_backgroundColor;

- (NSLineBreakMode)ff_lineBreakMode;

- (FFTextTouchAction *_Nullable)ff_touchAction;

- (NSShadow *_Nullable)ff_shadow;

- (FFTextAttachment *_Nullable)ff_containAttachmentAtLocation:(NSUInteger)location;

@end

@interface NSMutableAttributedString (FFText)

- (void)ff_setFont:(UIFont *)font;
- (void)ff_setFont:(UIFont *)font range:(NSRange)range;

- (void)ff_setTextColor:(UIColor *)textColor;
- (void)ff_setTextColor:(UIColor *)textColor range:(NSRange)range;

- (void)ff_setParagraph:(NSParagraphStyle *)paragraph;
- (void)ff_setParagraph:(NSParagraphStyle *)paragraph range:(NSRange)range;

- (void)ff_setCustomParagraph:(void(^)(NSMutableParagraphStyle *paragraph))setting;
- (void)ff_setCustomParagraph:(void(^)(NSMutableParagraphStyle *paragraph))setting range:(NSRange)range;

- (void)ff_setTextAlignment:(NSTextAlignment)textAlignment;
- (void)ff_setTextAlignment:(NSTextAlignment)textAlignment range:(NSRange)range;

- (void)ff_setbackgroundColor:(UIColor *)backgroundColor;
- (void)ff_setbackgroundColor:(UIColor *)backgroundColor range:(NSRange)range;

- (void)ff_setLineSpacing:(CGFloat)lineSpacing;
- (void)ff_setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range;

- (void)ff_setParagraphSpacing:(CGFloat)paragraphSpacing;
- (void)ff_setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range;

- (void)ff_setAlignment:(NSTextAlignment)alignment;
- (void)ff_setAlignment:(NSTextAlignment)alignment range:(NSRange)range;

- (void)ff_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent;
- (void)ff_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range;

- (void)ff_setHeadIndent:(CGFloat)headIndent;
- (void)ff_setHeadIndent:(CGFloat)headIndent range:(NSRange)range;

- (void)ff_setTailIndent:(CGFloat)tailIndent;
- (void)ff_setTailIndent:(CGFloat)tailIndent range:(NSRange)range;

- (void)ff_setLineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)ff_setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range;

- (void)ff_setKern:(CGFloat)kern;
- (void)ff_setKern:(CGFloat)kern range:(NSRange)range;

- (void)ff_setUnderlineStyle:(NSUnderlineStyle)underlineStyle;
- (void)ff_setUnderlineStyle:(NSUnderlineStyle)underlineStyle range:(NSRange)range;

- (void)ff_setUnderlineColor:(UIColor *)underlineColor;
- (void)ff_setUnderlineColor:(UIColor *)underlineColor range:(NSRange)range;

- (void)ff_setShadow:(NSShadow *)shadow;
- (void)ff_setShadow:(NSShadow *)shadow range:(NSRange)range;

/// 设置斜体
- (void)ff_setObliqueness;
- (void)ff_setObliqueness:(CGFloat)obliqueness;
- (void)ff_setObliqueness:(CGFloat)obliqueness range:(NSRange)range;

- (void)ff_setTextAttachment:(FFTextAttachment *)attachment atLocation:(NSUInteger)location;
- (void)ff_removeTextAttachmentAtLocation:(NSUInteger)location;

/// 文本添加点击事件
/// @param action 点击事件
- (void)ff_setTextTouchEvent:(FFTextTouchAction *)action;
- (void)ff_removeTextTouchEventWithRange:(NSRange)range;

- (void)ff_setTextHighlightAction:(FFTextHighlight *)highlight;
- (void)ff_removeTextHighlightActionWithRange:(NSRange)range;

- (void)ff_setTextLink:(FFTextLink *)link;
- (void)ff_removeTextLinkWithRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
