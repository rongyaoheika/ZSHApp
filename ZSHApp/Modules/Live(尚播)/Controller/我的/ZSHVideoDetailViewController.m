//
//  ZSHVideoDetailViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHVideoDetailViewController.h"
#import "ZSHVideoDetailCell.h"


static NSString *cellIdentifier = @"VideoDetailCellIdentifier";

@interface ZSHVideoDetailViewController ()

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) ZSHBottomBlurPopView   *bottomBlurPopView;

@end

@implementation ZSHVideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
}

- (void)createUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHVideoDetailCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView reloadData];
    
    [self.tableView setTableHeaderView:[self createTableviewHeaderView]];
    [self.view addSubview:[self createFooterView]];    
}

- (UIView *)createTableviewHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(344.5))];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_detail_4"]];
    image.frame = CGRectMake(0, 0, kRealValue(375), kRealValue(250));
    [view addSubview:image];
    
    UILabel *playtimeLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"17.3w播放",@"font":kPingFangRegular(11)}];
    playtimeLabel.frame = CGRectMake(15, 260, 52, 11);
    [view addSubview:playtimeLabel];
    
    UILabel *playdateLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"4小时前",@"font":kPingFangRegular(11)}];
    playdateLabel.frame = CGRectMake(319.5, 260, 41, 11);
    [view addSubview:playdateLabel];
    
    
    UIButton *nameBtn = [ZSHBaseUIControl  createBtnWithParamDic:@{@"title":@"姜小白：......",@"font":kPingFangMedium(14),@"normalImage":@"video_detail_1"} target:self action:nil];
    nameBtn.frame = CGRectMake(15, 280.5, 105, 20);
    [view addSubview:nameBtn];
    
    UIButton *likeBtn = [ZSHBaseUIControl  createBtnWithParamDic:@{@"title":@"400喜欢",@"font":kPingFangRegular(11),@"normalImage":@"video_detail_2"} target:self action:nil];
    likeBtn.frame = CGRectMake(15, 300.5, 70, 20);
    [view addSubview:likeBtn];
    
    UIButton *discussBtn = [ZSHBaseUIControl  createBtnWithParamDic:@{@"title":@"89评论",@"font":kPingFangRegular(11),@"normalImage":@"video_detail_3"} target:self action:nil];
    discussBtn.frame = CGRectMake(15, 320.5, 60, 20);
    [view addSubview:discussBtn];
    
    return view;
}

- (UIView *)createFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - kRealValue(49) , KScreenWidth, KBottomNavH)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"0C0C0C"];
    
    UIImage *chatImage = [UIImage imageNamed:@"live_room_chat"];
    UIButton *chatBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [footerView addSubview:chatBtn];
    [chatBtn setBackgroundImage:chatImage forState:UIControlStateNormal];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView).offset(KLeftMargin);
        make.centerY.mas_equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(32), kRealValue(32)));
    }];
    
    NSArray *imageArr = @[@"live_room_gift",@"live_room_love",@"live_room_share"];
    for (int i = 0; i<imageArr.count; i++) {
        UIImage *btnImage = [UIImage imageNamed:imageArr[i]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        btn.tag = 11179+i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn];
        [btn setImage:btnImage forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(footerView).offset(-(15 + i*(btnImage.size.width + kRealValue(10))));
            make.centerY.mas_equalTo(footerView);
            make.width.mas_equalTo(btnImage.size.width);
            make.height.mas_equalTo(btnImage.size.height);
        }];
    }
    return footerView;
}


- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    self.dataArr = @[
                     @{@"imageName":@"list_user_1",@"nickname":@"爱跳舞的小丑",@"content":@"6666",@"date":@"6分钟前"},
                     @{@"imageName":@"list_user_2",@"nickname":@"假面骑士",@"content":@"回复 爱跳舞的小丑：是么",@"date":@"9分钟前"},
                     @{@"imageName":@"list_user_3",@"nickname":@"Miss_王",@"content":@"漂亮",@"date":@"10分钟前"},
                     @{@"imageName":@"list_user_4",@"nickname":@"忘记时间的钟",@"content":@"666",@"date":@"16分钟前"},
                     ];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(59);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //需要注册，无需判空
            ZSHVideoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"imageName":self.dataArr[i][@"imageName"],@"nickname":self.dataArr[i][@"nickname"],@"content":self.dataArr[i][@"content"],@"date":self.dataArr[i][@"date"]};
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
        
    }
    return sectionModel;
}

- (ZSHBottomBlurPopView *)createBottomBlurPopViewWith:(ZSHFromVCToBottomBlurPopView)fromClassType{
    NSDictionary *nextParamDic = @{KFromClassType:@(fromClassType)};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    bottomBlurPopView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [bottomBlurPopView setBlurEnabled:NO];
    return bottomBlurPopView;
}

- (void)btnAction:(UIButton *)btn {
    if ((btn.tag -11179) == 2) {
        [self.view addSubview:[self createBottomBlurPopViewWith:ZSHFromShareVCToToBottomBlurPopView]];
    }
}


@end
