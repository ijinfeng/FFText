//
//  FFTextRender.h
//  FFText-oc
//
//  Created by jinfeng on 2021/3/19.
//

#import <Foundation/Foundation.h>
#import "FFTextLayoutDescription.h"
#import <UIKit/UIKit.h>
#import "FFTextAttribute.h"

NS_ASSUME_NONNULL_BEGIN
/// 负责绘制工作
@interface FFTextRender : NSObject

@property (nonatomic, strong, readonly) FFTextLayoutDescription *layout;

@property (nonatomic, readonly) CGSize suggestSize;

- (void)renderWithContext:(CGContextRef)context targetView:(UIView *)targetView;

/// 点击处是否包含有高亮
/// @param point 触摸点
- (FFTextHighlight *_Nullable)containersHighlightActionIn:(CGPoint)point;

/// 判断是否包含点击事件
/// @param point 触摸点
- (FFTextTouchAction *_Nullable)contrainersEventTouchIn:(CGPoint)point;

- (CGSize)textRenderSuggestSizeFits:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
