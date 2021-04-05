//
//  FFTextHighlightViewController.m
//  FFText-oc
//
//  Created by jinfeng on 2021/4/2.
//

#import "FFTextHighlightViewController.h"

@interface FFTextHighlightViewController ()
@property (nonatomic, strong) FFLabel *showLabel;
@end

@implementation FFTextHighlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.textLabel.contentInsets = UIEdgeInsetsMake(10, 20, 30, 40);
    
    __weak typeof(self) weakSelf = self;
    
    FFTextHighlight *h1 = [FFTextHighlight new];
    h1.effectRange = NSMakeRange(8, 48);
    h1.highlightBackgroundColor = [UIColor redColor];
    h1.highlightTextColor = [UIColor whiteColor];
    h1.action.longTouchAction = ^(NSAttributedString * _Nonnull text, NSRange range) {
        weakSelf.showLabel.text = [NSString stringWithFormat:@"长按了【%@】",text.string];
    };
    [self.textLabel addHighlightAction:h1];
    
    
    FFTextHighlight *h2 = [FFTextHighlight new];
    h2.link.linkTextColor = [UIColor greenColor];
    h2.effectRange = NSMakeRange(150, 180);
    h2.highlightFont = [UIFont systemFontOfSize:20];
    h2.action.touchAction = ^(NSAttributedString * _Nonnull text, NSRange range) {
        weakSelf.showLabel.text = [NSString stringWithFormat:@"点击了【%@】",text.string];
    };
    [self.textLabel addHighlightAction:h2];
    
    self.showLabel = [FFLabel new];
    self.showLabel.numberOfLines = 0;
    self.showLabel.text = @"点击划线部分";
    self.showLabel.textColor = [UIColor redColor];
    self.showLabel.font = [UIFont systemFontOfSize:15];
    self.showLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.showLabel];
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(50);
        make.left.right.equalTo(self.view);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
