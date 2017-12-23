//
//  ZSHLiveTaskCenterViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveTaskCenterViewController.h"
#import "ZSHLiveTaskCenterCell.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface ZSHLiveTaskCenterViewController ()

@end

@implementation ZSHLiveTaskCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
}

- (void)createUI{
    self.title = @"任务中心";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHLiveTaskCenterCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView reloadData];

    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *imageArr = @[@"task_Image_1",@"task_Image_2",@"task_Image_3",@"task_Image_4",@"task_Image_5"];

    NSArray *titleArr = @[@"设置头像", @"浏览主播", @"关注主播", @"送礼物给主播", @"完成全部任务"];
    NSArray *contentArr = @[@"你的颜值不错哦，可获得10个黑咖币", @"浏览三个正在直播的主播，可获得20个黑咖币", @"关注五个主播，可获得30个黑咖币", @"为心仪的主播增加人气值，可获得50个黑咖币", @"额外获得100个黑咖币"];
    
    for (int i = 0; i<imageArr.count; i++) {
        
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(59);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //需要注册，无需判空
            
            ZSHLiveTaskCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"bgImageName":imageArr[i],@"TitleText":titleArr[i],@"ContentText":contentArr[i]};
            if (indexPath.row != 1) {
                cell.finishBtn.selected = true;
            }
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
        
    }
    return sectionModel;
}

@end
