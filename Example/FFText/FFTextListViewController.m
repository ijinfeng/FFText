//
//  FFTextListViewController.m
//  FFText_Example
//
//  Created by jinfeng on 2021/4/6.
//  Copyright © 2021 CranzCapatain. All rights reserved.
//

#import "FFTextListViewController.h"
#import <Masonry.h>

@interface FFListModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) BOOL unfold;

@end

@implementation FFListModel



@end





@interface FFListCell : UITableViewCell

@property (nonatomic, strong) FFLabel *nameLabel;
@property (nonatomic, strong) FFLabel *contentLabel;

@property (nonatomic, strong) FFListModel *model;

@property (nonatomic, copy) void(^didClickMore)(void);

@end

@implementation FFListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [FFLabel new];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.nameLabel];
        
        self.contentLabel = [FFLabel new];
        self.contentLabel.userInteractionEnabled = YES;
        self.contentLabel.layer.borderColor = [UIColor redColor].CGColor;
        self.contentLabel.layer.borderWidth = 1;
        self.contentLabel.textColor = [UIColor lightGrayColor];
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.contentLabel.numberOfLines = 2;
        self.contentLabel.suggestConstraintWidth = [UIScreen mainScreen].bounds.size.width - 24;
        [self.contentView addSubview:self.contentLabel];
       
        FFTextTruncationToken *token = [FFTextTruncationToken new];
        token.truncationToken = [[NSAttributedString alloc] initWithString:@"更多" attributes:@{NSFontAttributeName : self.contentLabel.font, NSForegroundColorAttributeName: [UIColor redColor]}];
        __weak typeof(self) weakSelf = self;
        token.action.touchAction = ^(NSAttributedString * _Nonnull text, NSRange range) {
            weakSelf.model.unfold = YES;
            weakSelf.contentLabel.numberOfLines = 0;
            weakSelf.contentLabel.truncationToken = nil;
            if (weakSelf.didClickMore) {
                weakSelf.didClickMore();
            }
        };
        self.contentLabel.truncationToken = token;
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(20);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
            make.left.equalTo(@12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-20);
        }];
    }
    return self;
}

- (void)setModel:(FFListModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.content;
    self.contentLabel.numberOfLines = model.unfold ? 0 : 2;
}

@end



@interface FFTextListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation FFTextListViewController

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.textLabel removeFromSuperview];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"list" ofType:@"json"];
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
    
    for (int i = 0; i < jsonArr.count; i++) {
        NSDictionary *dic  =jsonArr[i];
        FFListModel *model = [FFListModel new];
        model.name = dic[@"name"];
        model.content = dic[@"content"];
        [self.datas addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark -- <#summary#>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[FFListCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    __weak typeof(self) weakSelf = self;
    cell.didClickMore = ^{
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
