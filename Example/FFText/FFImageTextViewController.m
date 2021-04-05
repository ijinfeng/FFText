//
//  FFImageTextViewController.m
//  FFText-oc
//
//  Created by jinfeng on 2021/4/2.
//

#import "FFImageTextViewController.h"

@interface FFImageTextViewController ()

@end

@implementation FFImageTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"mababa"];
    [self.textLabel insertImage:image size:CGSizeMake(66, 48) atLocation:100];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor greenColor];
    label.text = @"看马爸爸表演";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor redColor];
    [self.textLabel insertCustomView:label size:CGSizeMake(100, 30) insets:UIEdgeInsetsMake(0, 5, 0, 5) atLocation:200 verticalTextAlignment:FFVerticalTextAlignmentCenter];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"点我放大马爸爸" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionForClickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.textLabel insertCustomView:button size:CGSizeMake(120, 30) insets:UIEdgeInsetsMake(0, 0, 0, 0) atLocation:300 verticalTextAlignment:FFVerticalTextAlignmentCenter];
    
    self.textLabel.contentInsets = UIEdgeInsetsMake(10, 20, 30, 40);
}

- (void)actionForClickButton {
    if ([self.textLabel.attributeText ff_containAttachmentAtLocation:100]) {
        [self.textLabel removeAttachmentAtLocation:100];
        UIImage *image = [UIImage imageNamed:@"mababa"];
        [self.textLabel insertImage:image size:CGSizeMake(66 * 3, 48 * 3) atLocation:100];
    }
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
