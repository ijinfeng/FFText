//
//  FFRunDelegate.h
//  FFText-oc
//
//  Created by jinfeng on 2021/3/22.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFRunDelegate : NSObject

@property (nonatomic, assign) CGFloat ascent;

@property (nonatomic, assign) CGFloat descent;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, copy, nullable) NSDictionary *userInfo;

@end

NS_ASSUME_NONNULL_END
