//
//  NSAttributedString+FFText.m
//  FFText-oc
//
//  Created by jinfeng on 2021/3/19.
//

#import "NSAttributedString+FFText.h"

@implementation NSAttributedString (FFText)

- (NSRange)ff_wholeRange {
    return NSMakeRange(0, self.length);
}

- (NSDictionary *)ff_attributes {
    return [self attributesAtIndex:0 effectiveRange:NULL];
}

- (id)ff_attributeValueWithName:(NSString *)name {
    return [self ff_attributeValueWithName:name effectiveRange:NULL];
}

- (id)ff_attributeValueWithName:(NSString *)name effectiveRange:(nullable NSRangePointer)range {
    if (self.length == 0) {return nil;}
    return [self attribute:name atIndex:0 effectiveRange:range];
}

- (UIFont *)ff_font {
    return [self ff_attributeValueWithName:NSFontAttributeName];
}

- (UIColor *)ff_textColor {
    return [self ff_attributeValueWithName:NSForegroundColorAttributeName];
}

- (NSParagraphStyle *)ff_paragraph {
    return [self ff_attributeValueWithName:NSParagraphStyleAttributeName];
}

- (UIColor *)ff_backgroundColor {
    return [self ff_attributeValueWithName:NSBackgroundColorAttributeName];
}

- (NSLineBreakMode)ff_lineBreakMode {
    NSParagraphStyle *paragraph = [self ff_paragraph];
    return paragraph.lineBreakMode;
}

- (FFTextTouchAction *)ff_touchAction {
    return [self ff_attributeValueWithName:FFTextTouchEventAttributeName];
}

- (NSShadow *)ff_shadow {
    return [self ff_attributeValueWithName:NSShadowAttributeName];
}

- (FFTextAttachment *)ff_containAttachmentAtLocation:(NSUInteger)location {
    if (location > self.length) return nil;
    extern NSAttributedStringKey const FFAttachmentAttributeName;
    id attachment = [self attribute:FFAttachmentAttributeName atIndex:location longestEffectiveRange:NULL inRange:NSMakeRange(location, 1)];
    return attachment;
}

@end


@implementation NSMutableAttributedString (FFText)

- (void)ff_setAttribute:(NSString *)attributeName value:(id)value {
    [self ff_setAttribute:attributeName value:value range:self.ff_wholeRange];
}

- (void)ff_setAttribute:(NSString *)attributeName value:(id)value range:(NSRange)range {
    NSAssert(range.location + range.length <= self.length, @"Range exceeds the length of string.");
    if (range.length == 0) { return; }
    if (range.location + range.length > self.length) { return; }
    if (value == nil) {
        [self ff_removeAttribute:attributeName range:range];
    } else {
        [self addAttribute:attributeName value:value range:range];
    }
}

- (void)ff_removeAttribute:(NSString *)attributeName range:(NSRange)range {
    if (range.length == 0) return;
    if (range.location + range.length > self.length) return;
    if (!attributeName) return;
    [self removeAttribute:attributeName range:range];
}

- (void)ff_setFont:(UIFont *)font {
    [self ff_setFont:font range:self.ff_wholeRange];
}

- (void)ff_setFont:(UIFont *)font range:(NSRange)range {
    [self ff_setAttribute:NSFontAttributeName value:font range:range];
}

- (void)ff_setTextColor:(UIColor *)textColor {
    [self ff_setTextColor:textColor range:self.ff_wholeRange];
}

- (void)ff_setTextColor:(UIColor *)textColor range:(NSRange)range {
    [self ff_setAttribute:NSForegroundColorAttributeName value:textColor range:range];
}

- (void)ff_setParagraph:(NSParagraphStyle *)paragraph {
    [self ff_setParagraph:paragraph range:self.ff_wholeRange];
}

- (void)ff_setParagraph:(NSParagraphStyle *)paragraph range:(NSRange)range {
    [self ff_setAttribute:NSParagraphStyleAttributeName value:paragraph range:range];
}

- (void)ff_setTextAlignment:(NSTextAlignment)textAlignment {
    [self ff_setTextAlignment:textAlignment range:self.ff_wholeRange];
}

- (void)ff_setTextAlignment:(NSTextAlignment)textAlignment range:(NSRange)range {
    [self ff_setCustomParagraph:^(NSMutableParagraphStyle * _Nonnull paragraph) {
        paragraph.alignment = textAlignment;
    } range:range];
}

- (void)ff_setbackgroundColor:(UIColor *)backgroundColor {
    [self ff_setbackgroundColor:backgroundColor range:self.ff_wholeRange];
}

- (void)ff_setbackgroundColor:(UIColor *)backgroundColor range:(NSRange)range {
    [self ff_setAttribute:NSBackgroundColorAttributeName value:backgroundColor range:range];
}

- (void)ff_setCustomParagraph:(void (^)(NSMutableParagraphStyle * _Nonnull))setting {
    [self ff_setCustomParagraph:setting range:self.ff_wholeRange];
}

- (void)ff_setCustomParagraph:(void (^)(NSMutableParagraphStyle * _Nonnull))setting range:(NSRange)range {
    if (!setting) {
        return;
    }
    NSMutableParagraphStyle *parapraph = [[self ff_attributeValueWithName:NSParagraphStyleAttributeName] mutableCopy];
    if (!parapraph) {
        parapraph = [NSMutableParagraphStyle new];
    }
    setting(parapraph);
    [self ff_setParagraph:parapraph.copy range:range];
}

- (void)ff_setLineSpacing:(CGFloat)lineSpacing {
    [self ff_setLineSpacing:lineSpacing range:self.ff_wholeRange];
}

- (void)ff_setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range {
    [self ff_setCustomParagraph:^(NSMutableParagraphStyle * _Nonnull paragraph) {
        paragraph.lineSpacing = lineSpacing;
    } range:range];
}

- (void)ff_setParagraphSpacing:(CGFloat)paragraphSpacing {
    [self ff_setParagraphSpacing:paragraphSpacing range:self.ff_wholeRange];
}

- (void)ff_setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range {
    [self ff_setCustomParagraph:^(NSMutableParagraphStyle * _Nonnull paragraph) {
        paragraph.paragraphSpacing = paragraphSpacing;
    } range:range];
}

- (void)ff_setAlignment:(NSTextAlignment)alignment {
    [self ff_setAlignment:alignment range:self.ff_wholeRange];
}

- (void)ff_setAlignment:(NSTextAlignment)alignment range:(NSRange)range {
    [self ff_setCustomParagraph:^(NSMutableParagraphStyle * _Nonnull paragraph) {
            paragraph.alignment = alignment;
    } range:range];
}

- (void)ff_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    [self ff_setFirstLineHeadIndent:firstLineHeadIndent range:self.ff_wholeRange];
}

- (void)ff_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range {
    [self ff_setCustomParagraph:^(NSMutableParagraphStyle * _Nonnull paragraph) {
            paragraph.firstLineHeadIndent = firstLineHeadIndent;
    } range:range];
}

- (void)ff_setHeadIndent:(CGFloat)headIndent {
    [self ff_setHeadIndent:headIndent range:self.ff_wholeRange];
}

- (void)ff_setHeadIndent:(CGFloat)headIndent range:(NSRange)range {
    [self ff_setCustomParagraph:^(NSMutableParagraphStyle * _Nonnull paragraph) {
            paragraph.headIndent = headIndent;
    } range:range];
}

- (void)ff_setTailIndent:(CGFloat)tailIndent {
    [self ff_setTailIndent:tailIndent range:self.ff_wholeRange];
}

- (void)ff_setTailIndent:(CGFloat)tailIndent range:(NSRange)range {
    [self ff_setCustomParagraph:^(NSMutableParagraphStyle * _Nonnull paragraph) {
            paragraph.tailIndent = tailIndent;
    } range:range];
}

- (void)ff_setKern:(CGFloat)kern {
    [self ff_setKern:kern range:self.ff_wholeRange];
}

- (void)ff_setKern:(CGFloat)kern range:(NSRange)range {
    [self ff_setAttribute:NSKernAttributeName value:@(kern) range:range];
}

- (void)ff_setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    [self ff_setLineBreakMode:lineBreakMode range:self.ff_wholeRange];
}

- (void)ff_setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range {
    [self ff_setCustomParagraph:^(NSMutableParagraphStyle * _Nonnull paragraph) {
        paragraph.lineBreakMode = lineBreakMode;
    } range:range];
}

- (void)ff_setUnderlineStyle:(NSUnderlineStyle)underlineStyle {
    [self ff_setUnderlineStyle:underlineStyle range:self.ff_wholeRange];
}

- (void)ff_setUnderlineStyle:(NSUnderlineStyle)underlineStyle range:(NSRange)range {
    [self ff_setAttribute:NSUnderlineStyleAttributeName value:@(underlineStyle) range:range];
}

- (void)ff_setUnderlineColor:(UIColor *)underlineColor {
    [self ff_setUnderlineColor:underlineColor range:self.ff_wholeRange];
}

- (void)ff_setUnderlineColor:(UIColor *)underlineColor range:(NSRange)range {
    [self ff_setAttribute:NSUnderlineColorAttributeName value:underlineColor range:range];
}

- (void)ff_setShadow:(NSShadow *)shadow {
    [self ff_setShadow:shadow range:self.ff_wholeRange];
}

- (void)ff_setShadow:(NSShadow *)shadow range:(NSRange)range {
    [self ff_setAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)ff_setObliqueness {
    [self ff_setObliqueness:0.5];
}

- (void)ff_setObliqueness:(CGFloat)obliqueness {
    [self ff_setObliqueness:obliqueness range:self.ff_wholeRange];
}

- (void)ff_setObliqueness:(CGFloat)obliqueness range:(NSRange)range {
    [self ff_setAttribute:NSObliquenessAttributeName value:@(obliqueness) range:range];
}

- (void)ff_setTextAttachment:(FFTextAttachment *)attachment atLocation:(NSUInteger)location {
    if (!attachment) return;
    if (location > self.length) return;
    extern NSAttributedStringKey const FFAttachmentAttributeName;
    [self insertAttributedString:attachment.createTextAttachmentString atIndex:location];
    [self ff_setAttribute:FFAttachmentAttributeName value:attachment range:NSMakeRange(location, 1)];
}

- (void)ff_removeTextAttachmentAtLocation:(NSUInteger)location {
    [self ff_removeAttribute:FFAttachmentAttributeName range:NSMakeRange(location, 1)];
    [self deleteCharactersInRange:NSMakeRange(location, 1)];
}

- (void)ff_setTextHighlightAction:(FFTextHighlight *)highlight {
    if (!highlight) return;
    if (highlight.effectRange.length == 0) return;
    extern NSAttributedStringKey const FFHighlightAttributeName;
    [self ff_setAttribute:FFHighlightAttributeName value:highlight range:highlight.effectRange];
    [self ff_setTextLink:highlight.link];
    [self ff_setTextTouchEvent:highlight.action];
}

- (void)ff_removeTextHighlightActionWithRange:(NSRange)range {
    [self ff_removeAttribute:FFHighlightAttributeName range:range];
}

- (void)ff_setTextTouchEvent:(FFTextTouchAction *)action {
    if  (!action || (action.touchAction == nil && action.longTouchAction == nil)) return;
    if (action.effectRange.length == 0) return;
    [self ff_setAttribute:FFTextTouchEventAttributeName value:action range:action.effectRange];
}

- (void)ff_removeTextTouchEventWithRange:(NSRange)range {
    [self ff_removeAttribute:FFTextTouchEventAttributeName range:range];
}

- (void)ff_setTextLink:(FFTextLink *)link {
    if (!link) return;
    if (link.effectRange.length == 0) return;
    if (link.linkTextColor) [self ff_setAttribute:NSForegroundColorAttributeName value:link.linkTextColor range:link.effectRange];
    if (link.linkBackgroundColor) [self ff_setAttribute:NSBackgroundColorAttributeName value:link.linkBackgroundColor range:link.effectRange];
    [self ff_setUnderlineStyle:link.underlineStyle range:link.effectRange];
    if (link.underlineColor) [self ff_setUnderlineColor:link.underlineColor range:link.effectRange];
    [self ff_setTextTouchEvent:link.action];
}

- (void)ff_removeTextLinkWithRange:(NSRange)range {
    [self ff_removeTextTouchEventWithRange:range];
}

@end
