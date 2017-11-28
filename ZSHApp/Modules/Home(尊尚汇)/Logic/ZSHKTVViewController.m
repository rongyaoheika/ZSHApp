//
//  ZSHKTVViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHKTVViewController.h"
#import "ZSHKTVDetailViewController.h"
#import "ZSHKTVLogic.h"
#import "ZSHHotelCell.h"

@interface ZSHKTVViewController ()

@property (nonatomic, strong) ZSHKTVLogic  *KTVLogic;
@property (nonatomic, strong) NSArray      *KTVListArr;

@end

static NSString *ZSHHotelCellID = @"ZSHHotelCell";
@implementation ZSHKTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUI];
    [self loadData];
}

- (void)loadData{
    
    [self requestKTVListData];
    [self initViewModel];
}

- (void)requestKTVListData{
    kWeakSelf(self);
    _KTVLogic = [[ZSHKTVLogic alloc]init];
    [_KTVLogic loadKTVListDataWithParamDic:@{@"HONOURUSER_ID":@"d6a3779de8204dfd9359403f54f7d27c"}];
    _KTVLogic.requestDataCompleted = ^(NSArray *KTVListArr){
        weakself.KTVListArr = KTVListArr;
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        [weakself initViewModel];
    };
}

- (void)createUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHHotelCell class] forCellReuseIdentifier:ZSHHotelCellID];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < _KTVListArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(110);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHHotelCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelCellID forIndexPath:indexPath];
            if (i==_KTVListArr.count-1) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
            ZSHKTVModel *KTVModel = _KTVListArr[indexPath.row];
            [cell updateCellWithModel:KTVModel];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHKTVModel *KTVModel = _KTVListArr[indexPath.row];
            NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromHotelVCToHotelDetailVC),@"shopId":KTVModel.SORTHOTEL_ID};
            ZSHKTVDetailViewController *KTVDetailVC = [[ZSHKTVDetailViewController alloc]initWithParamDic:nextParamDic];
            [weakself.navigationController pushViewController:KTVDetailVC animated:YES];
        };
    }
    
    return sectionModel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
