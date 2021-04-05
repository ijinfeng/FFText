//
//  FFTextBaseViewController.m
//  FFText-oc
//
//  Created by jinfeng on 2021/4/2.
//

#import "FFTextBaseViewController.h"

@interface FFTextBaseViewController ()

@end

@implementation FFTextBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textLabel = [FFLabel new];
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.layer.borderWidth = 1;
    self.textLabel.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
    [self.view addSubview:self.textLabel];
    
    self.text = @"马云在参加央视的《开讲啦》节目时说：“我从1999年创业阿里巴巴到现在，没有拿过一个月工资，工资都发到了老婆那里……我从来没碰钱，我对钱没兴趣。”\n2016年6月，马云在第二十届圣彼得堡国际经济论坛上发言称：“我有生以来最大的错误就是创建阿里巴巴。我没料到这会改变我的一生，我本来只是想成立一家小公司，然而它却变成了这么大的企业。如果有来生，不会再做这样的生意。\n这句话流传之广，影响了无数人，以至于大家都忘记它出自马云之口。如今，马老师将回归教育事业。对于“天天都在做老师，也天天梦想着再去做老师”的马云，网友寄语：梦想还是要有的，万一实现了呢。\n2017年11月，在第四届世界浙商大会上，马云说，钱和好产品不能带来快乐，为人们的生活带来变化才能让自己快乐。马云还说：“一个月挣一两百万的人那是相当高兴的，但是一个月挣一二十亿的人其实是很难受的，因为这个钱已经不是你的了，你没法花了，拿回来以后你又得去做事情。”\n2012年，在一场演讲上，马云说：我创业永远挑自己最开心的事情做，挑最容易的事情做，挑大家都喜欢干的事情干。最重要的事情，最难做的事情，留给别人。";
    
    self.textLabel.text = self.text;
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(UIApplication.sharedApplication.windows.firstObject.safeAreaInsets.top + 44 + 20);
        } else {
            make.top.mas_equalTo(64);
        }
        make.left.right.inset(20);
    }];
}

@end
