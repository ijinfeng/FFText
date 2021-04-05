//
//  FFTextVerticalViewController.m
//  FFText-oc
//
//  Created by JinFeng on 2021/4/3.
//

#import "FFTextVerticalViewController.h"

@interface FFTextVerticalViewController ()
@property (nonatomic, strong) FFLabel *label1;
@property (nonatomic, strong) FFLabel *label2;
@property (nonatomic, strong) FFLabel *label3;
@property (nonatomic, strong) FFLabel *label4;
@property (nonatomic, strong) FFLabel *label5;
@property (nonatomic, strong) FFLabel *label6;
@property (nonatomic, strong) FFLabel *label7;
@property (nonatomic, strong) FFLabel *label8;
@property (nonatomic, strong) FFLabel *label9;
@end

@implementation FFTextVerticalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textLabel removeFromSuperview];
    
    self.label1 = [FFLabel new];
    self.label1.text = @"垂直向上";
    self.label1.layer.borderColor = [UIColor redColor].CGColor;
    self.label1.layer.borderWidth = 1;
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.verticalTextAlignment = FFVerticalTextAlignmentTop;
    self.label1.frame = CGRectMake(20, 100, 100, 50);
    [self.view addSubview:self.label1];
    
    self.label2 = [FFLabel new];
    self.label2.text = @"垂直居中";
    self.label2.layer.borderColor = [UIColor redColor].CGColor;
    self.label2.layer.borderWidth = 1;
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.verticalTextAlignment = FFVerticalTextAlignmentCenter;
    self.label2.frame = CGRectMake(20, 200, 100, 50);
    [self.view addSubview:self.label2];

    self.label3 = [FFLabel new];
    self.label3.text = @"垂直向下";
    self.label3.layer.borderColor = [UIColor redColor].CGColor;
    self.label3.layer.borderWidth = 1;
    self.label3.textAlignment = NSTextAlignmentCenter;
    self.label3.verticalTextAlignment = FFVerticalTextAlignmentBottom;
    self.label3.frame = CGRectMake(20, 300, 100, 50);
    [self.view addSubview:self.label3];
    
    self.label4 = [FFLabel new];
    self.label4.text = @"右上";
    self.label4.layer.borderColor = [UIColor redColor].CGColor;
    self.label4.layer.borderWidth = 1;
    self.label4.textAlignment = NSTextAlignmentRight;
    self.label4.verticalTextAlignment = FFVerticalTextAlignmentTop;
    self.label4.frame = CGRectMake(140, 100, 100, 50);
    [self.view addSubview:self.label4];
    
    self.label5 = [FFLabel new];
    self.label5.text = @"中右";
    self.label5.layer.borderColor = [UIColor redColor].CGColor;
    self.label5.layer.borderWidth = 1;
    self.label5.textAlignment = NSTextAlignmentRight;
    self.label5.verticalTextAlignment = FFVerticalTextAlignmentCenter;
    self.label5.frame = CGRectMake(140, 200, 100, 50);
    [self.view addSubview:self.label5];
    
    self.label6 = [FFLabel new];
    self.label6.text = @"中下";
    self.label6.layer.borderColor = [UIColor redColor].CGColor;
    self.label6.layer.borderWidth = 1;
    self.label6.textAlignment = NSTextAlignmentRight;
    self.label6.verticalTextAlignment = FFVerticalTextAlignmentBottom;
    self.label6.frame = CGRectMake(140, 300, 100, 50);
    [self.view addSubview:self.label6];
    
    self.label7 = [FFLabel new];
    self.label7.text = @"左上";
    self.label7.layer.borderColor = [UIColor redColor].CGColor;
    self.label7.layer.borderWidth = 1;
    self.label7.textAlignment = NSTextAlignmentLeft;
    self.label7.verticalTextAlignment = FFVerticalTextAlignmentTop;
    self.label7.frame = CGRectMake(260, 100, 100, 50);
    [self.view addSubview:self.label7];
    
    self.label8 = [FFLabel new];
    self.label8.text = @"中右";
    self.label8.layer.borderColor = [UIColor redColor].CGColor;
    self.label8.layer.borderWidth = 1;
    self.label8.textAlignment = NSTextAlignmentLeft;
    self.label8.verticalTextAlignment = FFVerticalTextAlignmentCenter;
    self.label8.frame = CGRectMake(260, 200, 100, 50);
    [self.view addSubview:self.label8];
    
    self.label9 = [FFLabel new];
    self.label9.text = @"中下";
    self.label9.layer.borderColor = [UIColor redColor].CGColor;
    self.label9.layer.borderWidth = 1;
    self.label9.textAlignment = NSTextAlignmentLeft;
    self.label9.verticalTextAlignment = FFVerticalTextAlignmentBottom;
    self.label9.frame = CGRectMake(260, 300, 100, 50);
    [self.view addSubview:self.label9];
}


@end
