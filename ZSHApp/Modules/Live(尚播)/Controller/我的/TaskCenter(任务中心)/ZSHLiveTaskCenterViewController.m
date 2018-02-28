//
//  ZSHLiveTaskCenterViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveTaskCenterViewController.h"
#import "ZSHLiveTaskCenterCell.h"
#import "ZSHLiveLogic.h"
static NSString *cellIdentifier = @"cellIdentifier";

@interface ZSHLiveTaskCenterViewController ()

@property (nonatomic, strong)ZSHLiveLogic  *liveLogic;
@property (nonatomic, strong)NSArray       *finishTitleArr;
@end

@implementation ZSHLiveTaskCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _liveLogic = [[ZSHLiveLogic alloc]init];
    [self requestData];
    [self initViewModel];
}

- (void)requestData{
    kWeakSelf(self);
    [_liveLogic requestTaskStatusWithDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id response) {
        RLog(@"任务中心数据==%@",response);
        NSDictionary *requestDic = response[@"pd"];
        weakself.finishTitleArr = @[[requestDic[@"TASK_PORT"]integerValue] == 0?@"未完成":@"去查看",  [requestDic[@"TASK_BROWSE"]integerValue] == 0?@"未完成":@"去查看", [requestDic[@"TASK_ATTENTION"]integerValue] == 0?@"未完成":@"去查看", [requestDic[@"TASK_GIFT"]integerValue] == 0?@"未完成":@"去查看", [requestDic[@"TASK_ALL"]integerValue] == 0?@"未完成":@"去查看" ];
        [weakself initViewModel];
    }];
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
    NSArray *contentArr = @[@"你的颜值不错哦，可获得10个黑卡币", @"浏览三个正在直播的主播，可获得20个黑卡币", @"关注五个主播，可获得30个黑卡币", @"为心仪的主播增加人气值，可获得50个黑卡币", @"额外获得100个黑卡币"];
    if (!_finishTitleArr) {
        _finishTitleArr = @[@"未完成",@"去查看",@"未完成",@"未完成",@"未完成"];
    }
    for (int i = 0; i<imageArr.count; i++) {
        
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(59);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //需要注册，无需判空
            
            ZSHLiveTaskCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"bgImageName":imageArr[i],@"TitleText":titleArr[i],@"ContentText":contentArr[i],@"FinishTitle":_finishTitleArr[i]};
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
