//
//  ZSHMoreListViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMoreListViewController.h"
#import "ZSHMoreListCell.h"
#import "ZSHMoreLogic.h"
#import "ZSHSubscribeViewController.h"
@interface ZSHMoreListViewController ()

@property (nonatomic, assign) ZSHShopType    shopType;
@property (nonatomic, strong) ZSHMoreLogic   *moreLogic;
@property (nonatomic, strong) NSArray        *listDataArr;
@property (nonatomic, strong) NSDictionary   *pushNextParamDic;

@end

static NSString *ZSHMoreListCellID = @"ZSHMoreListCell";
@implementation ZSHMoreListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    
    [self requestListData];
    [self initViewModel];
}

- (void)requestListData{
     kWeakSelf(self);
    _moreLogic = [[ZSHMoreLogic alloc]init];
    NSDictionary *paramDic = @{@"HONOURUSER_ID":HONOURUSER_IDValue};
    switch (kFromClassTypeValue) {
        case FromHorseVCToTitleContentVC:{//马术
            _shopType = ZSHHorseType;
            _pushNextParamDic = @{KFromClassType:@(ZSHHorseType),@"title":@"马术"};
            [_moreLogic requestHorseListWithParamDic:paramDic success:^(NSArray *horseDicArr) {
                weakself.listDataArr = horseDicArr;
                [weakself initViewModel];
            } fail:nil];
            
             break;
        }
        case FromShipVCToTitleContentVC:{//游艇
            _shopType = ZSHShipType;
            _pushNextParamDic = @{KFromClassType:@(ZSHShipType),@"title":@"游艇"},
            [_moreLogic requestYachtListWithParamDic:paramDic success:^(NSArray *golfDicArr) {
                weakself.listDataArr = golfDicArr;
                [weakself initViewModel];
            } fail:nil];
            
            break;
        }
        case FromGolfVCToTitleContentVC:{//高尔夫汇
            _shopType = ZSHGolfType;
            _pushNextParamDic = @{KFromClassType:@(ZSHGolfType),@"title":@"高尔夫汇"},
            [_moreLogic requestGolfListWithParamDic:paramDic success:^(NSArray *golfDicArr) {
                weakself.listDataArr = golfDicArr;
                [weakself initViewModel];
            } fail:nil];
            
            break;
        }
        case FromLuxcarVCToTitleContentVC:{//豪车
            _shopType = ZSHLuxcarType;
            _pushNextParamDic = @{KFromClassType:@(ZSHLuxcarType),@"title":@"豪车",},
            [_moreLogic requestLuxcarListWithParamDic:paramDic success:^(NSArray *golfDicArr) {
                weakself.listDataArr = golfDicArr;
                [weakself initViewModel];
            } fail:nil];
            
            break;
        }
            
        default:
            break;
    }
    
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
    
    [self.tableView registerClass:[ZSHMoreListCell class] forCellReuseIdentifier:ZSHMoreListCellID];
    
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
    for (int i = 0; i < _listDataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(110);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHMoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHMoreListCellID forIndexPath:indexPath];
            cell.shopType = weakself.shopType;
            if (i==_listDataArr.count-1) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
           
            NSDictionary *paramDic = _listDataArr[indexPath.row];
            [cell updateCellWithParamDic:paramDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            NSMutableDictionary *mNextParamDic = [[NSMutableDictionary alloc]init];
            NSDictionary *paramDic = _listDataArr[indexPath.row];
            [mNextParamDic setValue:paramDic forKey:@"requestDic"];
            [mNextParamDic setValue:_pushNextParamDic forKey:@"localDic"];
            ZSHSubscribeViewController *subScribeVC = [[ZSHSubscribeViewController alloc]initWithParamDic:mNextParamDic];
            [weakself.navigationController pushViewController:subScribeVC animated:YES];
        };
    }
    
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
