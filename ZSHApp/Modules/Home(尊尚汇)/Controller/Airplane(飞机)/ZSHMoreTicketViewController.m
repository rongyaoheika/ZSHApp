//
//  ZSHMoreTicketViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMoreTicketViewController.h"
#import "ZSHTicketPlaceCell.h"
#import "ZSHNoticeViewCell.h"
#import "ZSHPlaneTicketListCell.h"
#import "ZSHAirTicketDetailViewController.h"
@interface ZSHMoreTicketViewController ()

@property (nonatomic, strong) ZSHTicketPlaceCell   *ticketView;

@end

static NSString *ZSHKTVCalendarCellID = @"ZSHNoticeViewCell";
static NSString *ZSHPlaneTicketListCellID = @"ZSHPlaneTicketListCell";
@implementation ZSHMoreTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
    
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(1, 0, 0, 0 ));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:ZSHKTVCalendarCellID];
    [self.tableView registerClass:[ZSHPlaneTicketListCell class] forCellReuseIdentifier:ZSHPlaneTicketListCellID];
    
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

//机票日历
- (ZSHBaseTableViewSectionModel*)storTicketCalendarSection{
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(60);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHNoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHKTVCalendarCellID forIndexPath:indexPath];
        NSDictionary *nextParamDic = @{@"fromClassType":@(FromKTVCalendarVCToNoticeView)};
        [cell updateCellWithParamDic:nextParamDic];
        return cell;
    };
    
    return sectionModel;
}

//机票列表
- (ZSHBaseTableViewSectionModel*)storTicketListSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<6; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(85);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHPlaneTicketListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHPlaneTicketListCellID forIndexPath:indexPath];
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHAirTicketDetailViewController *airTicketDetailVC = [[ZSHAirTicketDetailViewController alloc]init];
            [weakself.navigationController pushViewController:airTicketDetailVC animated:NO];
        };
    }
    
    
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
