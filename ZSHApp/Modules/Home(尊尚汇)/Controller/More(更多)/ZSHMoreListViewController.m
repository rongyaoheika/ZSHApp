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
#import "ZSHGuideView.h"
#import "LXScollTitleView.h"

@interface ZSHMoreListViewController ()

@property (nonatomic, assign) ZSHShopType       shopType;
@property (nonatomic, strong) ZSHMoreLogic      *moreLogic;
@property (nonatomic, strong) NSArray           *listDataArr;
@property (nonatomic, strong) NSDictionary      *pushNextParamDic;
@property (nonatomic, strong) ZSHGuideView      *guideView;
@property (nonatomic, strong) ZSHBaseView       *headView;
@property (nonatomic, strong) LXScollTitleView  *titleView;

@end

static NSString *ZSHMoreListCellID = @"ZSHMoreListCell";
@implementation ZSHMoreListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
            [_moreLogic requestHorseListWithParamDic:paramDic success:^(id responseObject) {
                weakself.listDataArr = responseObject[@"pd"];
                [weakself updateAd:responseObject[@"ad"]];
                [weakself initViewModel];
            } fail:nil];
            
             break;
        }
        case FromShipVCToTitleContentVC:{//游艇
            _shopType = ZSHShipType;
            _pushNextParamDic = @{KFromClassType:@(ZSHShipType),@"title":@"游艇"};
            [_moreLogic requestYachtListWithParamDic:paramDic success:^(id responseObject) {
                weakself.listDataArr = responseObject[@"pd"];
                [weakself updateAd:responseObject[@"ad"]];
                [weakself initViewModel];
            } fail:nil];
            break;
        }
        case FromGolfVCToTitleContentVC:{//高尔夫汇
            _shopType = ZSHGolfType;
            _pushNextParamDic = @{KFromClassType:@(ZSHGolfType),@"title":@"高尔夫汇"};
            [_moreLogic requestGolfListWithParamDic:paramDic success:^(id responseObject) {
                weakself.listDataArr = responseObject[@"pd"];
                [weakself updateAd:responseObject[@"ad"]];
                [weakself initViewModel];
            } fail:nil];
            
            break;
        }
        case FromLuxcarVCToTitleContentVC:{//豪车
            _shopType = ZSHLuxcarType;
            _pushNextParamDic = @{KFromClassType:@(ZSHLuxcarType),@"title":@"豪车"};
            [_moreLogic requestLuxcarListWithParamDic:paramDic success:^(id responseObject) {
                weakself.listDataArr = responseObject[@"pd"];
                [weakself updateAd:responseObject[@"ad"]];
                [weakself initViewModel];
            } fail:nil];
            
            break;
        }

        default:
            break;
    }
    
}

- (void)updateAd:(NSArray *)arr {
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic  in arr) {
        [imageArr addObject:dic[@"SHOWIMG"]];
    }
    [_guideView updateViewWithParamDic:@{@"dataArr":imageArr}];
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
    self.tableView.tableHeaderView = self.headView;//self.guideView;
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

- (ZSHBaseView *)headView{
    if (!_headView) {
        CGFloat headHeight = (kFromClassTypeValue==FromShipVCToTitleContentVC?kRealValue(150):kRealValue(120));
        _headView = [[ZSHBaseView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, headHeight) paramDic:nil];
        [_headView addSubview:self.guideView];
        kFromClassTypeValue==FromShipVCToTitleContentVC?[_headView addSubview:self.titleView]:nil;
        [self.titleView reloadViewWithTitles:@[@"携艇会所",@"游艇买卖",@"游艇租赁", @"游艇基金",@"活动策划",@"码头建设",@"游艇驾校",@"游艇托管"]];
    }
    return _headView;
}

- (ZSHGuideView *)guideView {                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    if(!_guideView) {
        NSDictionary *nextParamDic = @{KFromClassType:@(FromBuyVCToGuideView),@"pageViewHeight":@(kRealValue(120)),@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false)};
        _guideView = [[ZSHGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(120)) paramDic:nextParamDic];
    }
    return _guideView;
}

- (LXScollTitleView *)titleView{
    kWeakSelf(self);
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0,  kRealValue(120), KScreenWidth, kRealValue(30))];
        _titleView.indicatorHeight = 0;
        _titleView.selectedBlock = ^(NSInteger index){
            [weakself shipBtnAction:index];
        };
        _titleView.titleWidth = KScreenWidth/4;
    }
    return _titleView;
}

- (void)shipBtnAction:(NSInteger)index{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
