//
//  ZSHHotelViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelViewController.h"
#import "ZSHHotelCell.h"
#import "ZSHHotelDetailViewController.h"
#import "ZSHBarDetailViewController.h"
#import "ZSHHotelModel.h"
#import "ZSHHotelLogic.h"

@interface ZSHHotelViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) ZSHHotelLogic              *hotelLogic;
@property (nonatomic, assign) ZSHShopType                shopType;
@property (nonatomic, strong) NSArray <ZSHHotelModel *>  *hotelModelArr;
@property (nonatomic, strong) NSArray <NSDictionary *>   *hotelListDicArr;

@end

static NSString *ZSHHotelCellID = @"ZSHHotelCell";

@implementation ZSHHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    [self createUI];
    [self loadData];
}

- (void)loadData{
   
    [self requestHotelListData];
    [self initViewModel];
}

- (void)requestHotelListData{
    kWeakSelf(self);
    _hotelLogic = [[ZSHHotelLogic alloc]init];
    NSDictionary *paramDic = @{@"HONOURUSER_ID":@"d6a3779de8204dfd9359403f54f7d27c"};
    if (kFromClassTypeValue == FromHotelVCToTitleContentVC) {//酒店
        [_hotelLogic loadHotelListDataWithParamDic:paramDic success:^(NSArray *hotelListDicArr) {
            [weakself endrefresh];
            _shopType = ZSHHotelShopType;
            _hotelListDicArr = hotelListDicArr;
            [weakself initViewModel];
            
        } fail:nil];
    } else if (kFromClassTypeValue == FromBarVCToTitleContentVC){//酒吧
        [_hotelLogic loadBarListDataWithParamDic:paramDic success:^(NSArray *barListDicArr) {
            [weakself endrefresh];
            _shopType = ZSHBarShopType;
            _hotelListDicArr = barListDicArr;
            [weakself initViewModel];
        } fail:nil];
    }
}

- (void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
    for (int i = 0; i < _hotelListDicArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(110);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHHotelCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelCellID forIndexPath:indexPath];
            if (i==_hotelListDicArr.count-1) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
            cell.shopType = _shopType;
            NSDictionary *paramDic = _hotelListDicArr[indexPath.row];
            [cell updateCellWithParamDic:paramDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            switch (kFromClassTypeValue) {
                case FromHotelVCToTitleContentVC:{//酒店
                    NSDictionary *paramDic = _hotelListDicArr[indexPath.row];
                    NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromHotelVCToHotelDetailVC),@"shopId":paramDic[@"SORTHOTEL_ID"]};
                    ZSHHotelDetailViewController *hotelDetailVC = [[ZSHHotelDetailViewController alloc]initWithParamDic:nextParamDic];
                    [weakself.navigationController pushViewController:hotelDetailVC animated:YES];
                     break;
                    
                }
                case FromBarVCToTitleContentVC:{//酒吧
                    NSDictionary *paramDic = _hotelListDicArr[indexPath.row];
                    NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromHotelVCToHotelDetailVC),@"shopId":paramDic[@"SORTBAR_ID"]};
                    ZSHBarDetailViewController *barlDetailVC = [[ZSHBarDetailViewController alloc]initWithParamDic:nextParamDic];
                    [weakself.navigationController pushViewController:barlDetailVC animated:YES];
                    break;
                    
                }
                    
                   
                    
                default:
                    break;
            }
        };
    }
    
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
