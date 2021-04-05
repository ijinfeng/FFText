//
//  FFTextAttributeDelegate.h
//  FFText-oc
//
//  Created by jinfeng on 2021/4/1.
//

#import <Foundation/Foundation.h>
#import "FFTextAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@class FFLabel;
@protocol FFTextAttributeDelegate <NSObject>

@optional
- (void)label:(FFLabel *)label didClickAttribute:(FFTextAttribute *)attribute;

@optional
- (void)label:(FFLabel *)label didLongPressAttribute:(FFTextAttribute *)attribute;

@end

NS_ASSUME_NONNULL_END
