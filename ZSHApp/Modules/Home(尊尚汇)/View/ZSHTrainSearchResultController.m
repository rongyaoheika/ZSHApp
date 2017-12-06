//
//  ZSHTrainSearchResultController.m
//  ZSHApp
//
//  Created by apple on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTrainSearchResultController.h"
#import "ZSHNoticeViewCell.h"
#import "ZSHTrainTicketListCell.h"
#import "ZSHTicketPlaceCell.h"
#import "ZSHTrainTicketDetailViewController.h"
#import "ZSHTrainLogic.h"


static NSString *ZSHKTVCalendarCellID = @"ZSHKTVCalendarCellID";
static NSString *ZSHTrainTicketListCellID = @"ZSHTrainTicketListCellID";

@interface ZSHTrainSearchResultController ()

@property (nonatomic, strong) ZSHTicketPlaceCell    *ticketView;
@property (nonatomic, strong) ZSHTrainLogic         *trainLogic;

@end

@implementation ZSHTrainSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _trainLogic = [[ZSHTrainLogic alloc] init];
    [self initViewModel];
//    [self requestData];
}

- (void)createUI{
    
    [self createTicketNaviUI];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0 ));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:ZSHKTVCalendarCellID];
    [self.tableView registerClass:[ZSHTrainTicketListCell class] forCellReuseIdentifier:ZSHTrainTicketListCellID];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
    lineView.backgroundColor = KZSHColor1D1D1D;
    [self.view addSubview:lineView];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storTicketCalendarSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storTicketListSection]];
}

//火车票日历
- (ZSHBaseTableViewSectionModel*)storTicketCalendarSection{
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(60);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHNoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHKTVCalendarCellID forIndexPath:indexPath];
        NSDictionary *nextParamDic = @{KFromClassType:@(FromKTVCalendarVCToNoticeView)};
        [cell updateCellWithParamDic:nextParamDic];
        return cell;
    };
    
    return sectionModel;
}

//火车票列表
- (ZSHBaseTableViewSectionModel*)storTicketListSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<6; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(85);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHTrainTicketListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHTrainTicketListCellID forIndexPath:indexPath];
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHTrainTicketDetailViewController *trainDetailVC = [[ZSHTrainTicketDetailViewController alloc]init];
            [weakself.navigationController pushViewController:trainDetailVC animated:false];
        };
    }
    
    
    return sectionModel;
}


- (void)createTicketNaviUI{
    self.ticketView = [[ZSHTicketPlaceCell alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44) paramDic:nil];
    self.ticketView.center = CGPointMake(self.navigationController.navigationBar.center.x, self.navigationController.navigationBar.center.y);
    [self.navigationItem setTitleView:self.ticketView];
}

- (void)requestData {
    // kWeakSelf(self);//参数：from 始发站/to 终点站/date 出发日期/tt 是否为高铁动车（不打勾不需要传递，打勾需要传递’D’）
    // @{@"from":@"",@"to":@"",@"date":@"",@"tt":@""}
    [_trainLogic requestTrainSelectWithDic:[self.paramDic[@"trainModel"] mj_keyValues] success:^(id response) {
        
    }];
}

@end
