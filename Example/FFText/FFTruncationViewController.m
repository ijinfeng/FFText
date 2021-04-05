//
//  FFTruncationViewController.m
//  FFText-oc
//
//  Created by JinFeng on 2021/4/3.
//

#import "FFTruncationViewController.h"

@interface FFTruncationViewController ()

@end

@implementation FFTruncationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FFTextTruncationToken *token = [FFTextTruncationToken new];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"点我展开10行"];
    [att ff_setFont:self.textLabel.font];
    [att ff_setTextColor:[UIColor brownColor]];
    token.truncationToken = att;
    
    __weak typeof(self) weakSelf = self;
    token.action.touchAction = ^(NSAttributedString * _Nonnull text, NSRange range) {
        __strong typeof(weakSelf) self = weakSelf;
        
        FFTextTruncationToken *token = [FFTextTruncationToken new];
        
        __weak typeof(self) weakSelf = self;
        token.action.touchAction = ^(NSAttributedString * _Nonnull text, NSRange range) {
            __strong typeof(weakSelf) self = weakSelf;
            
            
            FFTextTruncationToken *token = [FFTextTruncationToken new];
            __weak typeof(self) weakSelf = self;
            token.action.touchAction = ^(NSAttributedString * _Nonnull text, NSRange range) {
                __strong typeof(weakSelf) self = weakSelf;
                self.textLabel.numberOfLines = 0;
                self.textLabel.truncationToken = nil;
            };
            
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"点我展开全部"];
            [att ff_setFont:self.textLabel.font];
            [att ff_setTextColor:[UIColor greenColor]];
            token.truncationToken = att;
            
            self.textLabel.lineBreakMode = NSLineBreakByTruncatingHead;
            self.textLabel.truncationToken = token;
            self.textLabel.numberOfLines = 15;
        };
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"点我展开15行"];
        [att ff_setFont:self.textLabel.font];
        [att ff_setTextColor:[UIColor redColor]];
        token.truncationToken = att;
        
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.textLabel.truncationToken = token;
        self.textLabel.numberOfLines = 10;
    };
    
    self.textLabel.numberOfLines = 5;
    self.textLabel.truncationToken = token;
    self.textLabel.contentInsets = UIEdgeInsetsMake(5, 8, 5, 8);
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
