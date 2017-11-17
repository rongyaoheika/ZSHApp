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
    
    
    UIButton *nameBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"姜小白：......",@"font":kPingFangMedium(14)}];
    nameBtn.frame = CGRectMake(15, 280.5, 105, 20);
    [nameBtn setImage:[UIImage imageNamed:@"video_detail_1"] forState:UIControlStateNormal];
    [view addSubview:nameBtn];
//    
//    UIButton *nameBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"姜小白：......",@"font":kPingFangMedium(14)}];
//    nameBtn.frame = CGRectMake(15, 280.5, 105, 20);
//    [nameBtn setImage:[UIImage imageNamed:@"video_detail_1"] forState:UIControlStateNormal];
//    [view addSubview:nameBtn];
    
    return view;
}


- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *imageArr = @[@"tailor_detail_2",@"tailor_detail_3"];
    
    NSArray *titleArr = @[@"您只要腾出时间享受生活", @"拥有专属于您的私人买手+形象顾问"];
    NSArray *contentArr = @[@"把款式、尺码、价位......交给专业理型师和大数据，您就可以轻松享用最合适您的服饰和世界级的品味。", @"荣耀黑卡理型师是服装设计专业出身的学院派，同时也是身经百战的实践派，具有多年男装设计和造型搭配经验，为众多比赛与节目提供搭配咨询建议。基于多年行业时尚经验和对您的了解，为您量身打造穿衣搭配方案，让您轻松享用好品味。"];
    
    for (int i = 0; i<imageArr.count; i++) {
        
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(331);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //需要注册，无需判空
            ZSHVideoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"bgImageName":imageArr[i],@"TitleText":titleArr[i],@"ContentText":contentArr[i]};
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
        
    }
    return sectionModel;
}


@end
