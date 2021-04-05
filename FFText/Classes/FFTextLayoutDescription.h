//
//  FFTextLayoutDescription.h
//  FFText-oc
//
//  Created by jinfeng on 2021/3/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FFTextAttribute.h"

NS_ASSUME_NONNULL_BEGIN
/// 文本布局描述
@interface FFTextLayoutDescription : NSObject

@property (nonatomic) CGSize size;

@property (nonatomic) NSInteger numberOfLines;

@property (nonatomic) UIEdgeInsets insets;

@property (nonatomic) NSLineBreakMode lineBreadkMode;

@property (nonatomic, copy, nullable) NSAttributedString *attributeText;

@property (nonatomic, copy, nullable) NSAttributedString *truncationToken;

@property (nonatomic) FFVerticalTextAlignment verticalTextAlignment;

@property (nonatomic ,strong, nullable) NSArray<UIBezierPath *> * exclusionPaths;

- (CGMutablePathRef)createRenderPathIgnoreExclusionPaths:(BOOL)ignore;

@end

NS_ASSUME_NONNULL_END
