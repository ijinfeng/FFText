//
//  FFTextDetector.m
//  FFText-oc
//
//  Created by jinfeng on 2021/4/1.
//

#import "FFTextDetector.h"
#import "NSAttributedString+FFText.h"

@implementation FFTextDetector

- (NSAttributedString *)detectFromText:(NSAttributedString *)text {
    if (_detectorTypes == FFTextDetectorTypeNone) {
        return text;
    }
    NSMutableAttributedString *_text = text.mutableCopy;
    if (_detectorTypes & FFTextDetectorTypeLink) {
        NSString *regular = @"(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]";
        [self matchText:_text regular:regular];
    }
    if (_detectorTypes & FFTextDetectorTypePhoneNumber) {
        NSString *regular = @"(1[34578]\\d{9})";
        [self matchText:_text regular:regular];
    }
    if (_detectorTypes & FFTextDetectorTypeEmail) {
        NSString *regular = @"[A-Za-z\\d]+([-_.][A-Za-z\\d]+)*@([A-Za-z\\d]+[-.])*([A-Za-z\\d]+[.])+[A-Za-z\\d]{2,5}";
        [self matchText:_text regular:regular];
    }
    if (_detectorTypes & FFTextDetectorTypeCustom) {
        for (NSString *customRegular in self.detectorRegulars) {
            [self matchText:_text regular:customRegular];
        }
    }
    return _text;
}

- (void)matchText:(NSMutableAttributedString *)text regular:(NSString *)regular {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regular
        options:NSRegularExpressionCaseInsensitive
        error:nil];
    NSArray *matchs = [regex matchesInString:text.string options:0 range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *result in matchs) {
        NSRange range = result.range;
        FFTextHighlight *highlight = [FFTextHighlight new];
        highlight.effectRange = range;
        [text ff_setTextHighlightAction:highlight];
    }
}

@end
