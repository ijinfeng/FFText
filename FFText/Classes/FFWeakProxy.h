//
//  FFWeakProxy.h
//  FFText-oc
//
//  Created by jinfeng on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;

+ (instancetype)weakProxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
