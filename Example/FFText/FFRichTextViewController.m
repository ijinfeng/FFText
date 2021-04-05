//
//  FFRichTextViewController.m
//  FFText-oc
//
//  Created by jinfeng on 2021/4/2.
//

#import "FFRichTextViewController.h"

@interface FFRichTextViewController ()

@end

@implementation FFRichTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.text];
    [att ff_setFont:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 13)];
    [att ff_setTextColor:[UIColor redColor] range:NSMakeRange(0, 13)];
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [UIColor yellowColor];
    shadow.shadowBlurRadius = 1;
    shadow.shadowOffset = CGSizeMake(2, 2);
    [att ff_setShadow:shadow range:NSMakeRange(20, 10)];
    [att ff_setKern:10 range:NSMakeRange(30, 10)];
    [att ff_setCustomParagraph:^(NSMutableParagraphStyle * _Nonnull paragraph) {
        paragraph.lineSpacing = 10;
    } range:NSMakeRange(50, 20)];
    [att ff_setFont:[UIFont systemFontOfSize:17] range:NSMakeRange(80, 100)];
    [att ff_setbackgroundColor:[UIColor greenColor] range:NSMakeRange(120, 10)];
    [att ff_setUnderlineStyle:NSUnderlineStyleDouble range:NSMakeRange(130, 15)];
    [att ff_setUnderlineColor:[UIColor brownColor] range:NSMakeRange(130, 15)];
    [att ff_setTextColor:[UIColor lightGrayColor] range:NSMakeRange(150, 80)];
    [att ff_setUnderlineStyle:NSUnderlineStyleSingle range:NSMakeRange(200, 30)];
    [att ff_setFirstLineHeadIndent:30 range:NSMakeRange(250, 10)];
    [att ff_setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightBold] range:NSMakeRange(300, 20)];
    [att ff_setTextColor:[UIColor yellowColor] range:NSMakeRange(300, 10)];
    [att setAttributes:@{NSStrokeWidthAttributeName: @3, NSStrokeColorAttributeName: [UIColor brownColor]} range:NSMakeRange(350, 80)];
    
    self.textLabel.attributeText = att;
    
    self.textLabel.contentInsets = UIEdgeInsetsMake(20, 20, 0, 20);
    
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
