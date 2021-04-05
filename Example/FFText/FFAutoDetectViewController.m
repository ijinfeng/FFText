//
//  FFAutoDetectViewController.m
//  FFText-oc
//
//  Created by jinfeng on 2021/4/2.
//

#import "FFAutoDetectViewController.h"

@interface FFAutoDetectViewController ()<FFTextAttributeDelegate>
@property (nonatomic, strong) FFLabel *detectLabel;
@end

@implementation FFAutoDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"，" withString:@"13816759902"];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"。" withString:@"851406283@qq.com"];
    self.text = [self.text stringByAppendingString:@"干扰文字干扰文字http://www.baidu.com干扰文字干扰文字"];
    self.textLabel.text = self.text;
    self.textLabel.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.textLabel.delegate = self;
    self.textLabel.detectorTypes = FFTextDetectorTypeAll;
    
    
    self.detectLabel = [FFLabel new];
    self.detectLabel.detectorTypes = FFTextDetectorTypeNone;
    self.detectLabel.text = @"点击划线部分";
    self.detectLabel.textColor = [UIColor redColor];
    self.detectLabel.font = [UIFont systemFontOfSize:15];
    self.detectLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.detectLabel];
    [self.detectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(50);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];
}

#pragma mark -- FFTextAttributeDelegate

- (void)label:(FFLabel *)label didClickAttribute:(FFTextAttribute *)attribute {
    self.detectLabel.text = [NSString stringWithFormat:@"点击了【%@】",attribute.effectString.string];
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
