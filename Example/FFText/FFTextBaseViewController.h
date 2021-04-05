//
//  FFTextBaseViewController.h
//  FFText-oc
//
//  Created by jinfeng on 2021/4/2.
//

#import <UIKit/UIKit.h>
#import "FFText.h"
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFTextBaseViewController : UIViewController
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) FFLabel *textLabel;
@end

NS_ASSUME_NONNULL_END
