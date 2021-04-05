//
//  FFTextDetector.h
//  FFText-oc
//
//  Created by jinfeng on 2021/4/1.
//

#import <Foundation/Foundation.h>
#import "FFTextAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFTextDetector : NSObject

@property (nonatomic) FFTextDetectorTypes detectorTypes;

@property (nonatomic, copy, nullable) NSArray <NSString *>*detectorRegulars;

/// 检测文本中符合要求的特殊字符串
/// @param text 给定富文本
- (NSAttributedString *)detectFromText:(NSAttributedString *)text;

@end

NS_ASSUME_NONNULL_END
