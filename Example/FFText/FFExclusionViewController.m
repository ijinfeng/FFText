//
//  FFExclusionViewController.m
//  FFText-oc
//
//  Created by jinfeng on 2021/4/2.
//

#import "FFExclusionViewController.h"

@interface FFExclusionViewController ()

@end

@implementation FFExclusionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBezierPath *exclusionPath1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100, 40, 80, 80) cornerRadius:40];
    UIBezierPath *exclusionPath2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100, 180, 80, 80) cornerRadius:40];
    self.textLabel.exclusionPaths = @[exclusionPath1, exclusionPath2];
    self.textLabel.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
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
