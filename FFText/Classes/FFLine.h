//
//  FFLine.h
//  FFText-oc
//
//  Created by jinfeng on 2021/3/22.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "FFTextAttachment.h"
#import "FFTextAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFLine : NSObject

+ (instancetype)line:(CTLineRef)lineRef inRenderFrame:(CTFrameRef)frameRef originPoint:(CGPoint)point atRow:(NSUInteger)row;
/// baseline origin point
@property (nonatomic, readonly) CGPoint originPoint;

@property (nonatomic, copy, readonly) NSArray <FFTextAttachment *>*attachments;

@property (nonatomic, readonly) CGRect frame;

@property (nonatomic, copy, readonly) NSArray <FFTextHighlight *>*highlights;

@property (nonatomic, readonly) CGFloat ascent;

@property (nonatomic, readonly) CGFloat descent;

@property (nonatomic, readonly) CGFloat leading;

@property (nonatomic, readonly) CGFloat lineHeight;

@property (nonatomic, readonly) CGFloat width;

@property (nonatomic, readonly) NSRange range;

@property (nonatomic, readonly) CTLineRef lineRef;

@property (nonatomic, copy, readonly) NSArray <FFTextTouchAction *>*touchEvents;

@end

NS_ASSUME_NONNULL_END
