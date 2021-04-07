//
//  FFViewController.m
//  FFText
//
//  Created by CranzCapatain on 04/04/2021.
//  Copyright (c) 2021 CranzCapatain. All rights reserved.
//

#import "FFViewController.h"
#import "FFRichTextViewController.h"
#import "FFImageTextViewController.h"
#import "FFTextHighlightViewController.h"
#import "FFExclusionViewController.h"
#import "FFAutoDetectViewController.h"
#import "FFAutoLayoutViewController.h"
#import "FFTruncationViewController.h"
#import "FFTextVerticalViewController.h"
#import "FFTextListViewController.h"

@interface FFViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation FFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.datas = @[@"富文本", @"图文排布", @"点击高亮", @"自动识别号码、URL", @"排空区域", @"AutoLayout", @"自定义截断", @"垂直布局", @"列表使用"];

    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


#pragma mark -- TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FFTextBaseViewController *vc = nil;
    switch (indexPath.row) {
        case 0:{
            vc=  [FFRichTextViewController new];
        }
            break;
        case 1: {
            vc = [FFImageTextViewController new];
        }
            break;
        case 2:
        {
            vc = [FFTextHighlightViewController new];
        }
            break;
        case 3:
        {
            vc = [FFAutoDetectViewController new];
        }
            break;
        case 4: {
            vc = [FFExclusionViewController new];
        }
            break;
        case 5:
        {
            vc = [FFAutoLayoutViewController new];
        }
            break;
        case 6:
        {
            vc = [FFTruncationViewController new];
        }
            break;
        case 7:
        {
            vc = [FFTextVerticalViewController new];
        }
            break;
        case 8:
        {
            vc = [FFTextListViewController new];
        }
            break;
        default:
            break;
    }
    vc.title = self.datas[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
