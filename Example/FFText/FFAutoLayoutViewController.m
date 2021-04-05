//
//  FFAutoLayoutViewController.m
//  FFText-oc
//
//  Created by JinFeng on 2021/4/3.
//

#import "FFAutoLayoutViewController.h"

@interface FFAutoLayoutViewController ()
@property (nonatomic, assign) CGFloat top;

@property (nonatomic, strong) FFLabel *label1;
@property (nonatomic, strong) FFLabel *label2;
@property (nonatomic, strong) FFLabel *label3;
@end

@implementation FFAutoLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textLabel removeFromSuperview];
    
    self.top = 100;

    self.label1 = [FFLabel new];
    self.label1.text = @"一段段文字";
    self.label1.layer.borderColor = [UIColor redColor].CGColor;
    self.label1.layer.borderWidth = 1;
    [self.view addSubview:self.label1];
    
    self.label2 = [FFLabel new];
    self.label2.text = @"一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字一段长文字123";
    self.label2.lineBreakMode = NSLineBreakByTruncatingTail;
    self.label2.numberOfLines = 2;
    self.label2.layer.borderColor = [UIColor redColor].CGColor;
    self.label2.layer.borderWidth = 1;
    [self.view addSubview:self.label2];

    self.label3 = [FFLabel new];
    self.label3.text = @"zxcvbnmasfghjklqwrtyuiop1234567890[];./']p[,./';p[1234567900ajskfsahfkahdfiwqhefkhsdhf12313241242134213412753471254712547hdsafjsgjsagjgajg;[;.;.'.;.'./;.'...'.'.;.';.;";
    self.label3.numberOfLines = 0;
    self.label3.layer.borderColor = [UIColor redColor].CGColor;
    self.label3.layer.borderWidth = 1;
    self.label3.contentInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [self.view addSubview:self.label3];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(self.top);
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label1);
        make.left.equalTo(self.label1.mas_right).offset(10);
        make.right.mas_equalTo(-12);
    }];
    
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label2.mas_bottom).offset(10);
        make.left.right.inset(12);
    }];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改约束" style:UIBarButtonItemStyleDone target:self action:@selector(actionForUpdateConstraint)];
}

- (void)actionForUpdateConstraint {
    self.top += 10;
    
    [self.label1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.top);
    }];
}

@end
