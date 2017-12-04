//
//  ZSHFoodViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFoodViewController.h"
#import "ZSHFoodCell.h"
#import "ZSHFoodModel.h"
#import "ZSHHotelDetailViewController.h"

#import "ZSHFoodDetailViewController.h"
#import "ZSHFoodLogic.h"

@interface ZSHFoodViewController ()

@property (nonatomic, strong) NSMutableArray           *dataArr;
@property (nonatomic, strong) ZSHFoodLogic             *foodLogic;

@end

static NSString *ZSHFoodCellID = @"ZSHFoodCell";
@implementation ZSHFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    _foodLogic = [[ZSHFoodLogic alloc]init];
    [self requestData];
    [self initViewModel];
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHFoodCell class] forCellReuseIdentifier:ZSHFoodCellID];
   
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
    for (int i = 0; i < _foodLogic.foodListArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        kWeakSelf(cellModel);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHFoodCellID forIndexPath:indexPath];
            ZSHFoodModel *foodModel = _foodLogic.foodListArr[indexPath.row];
            [cell updateCellWithModel:foodModel];
            weakcellModel.height = foodModel.cellHeight;
            return cell;
        };
        
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHFoodModel *foodModel = _foodLogic.foodListArr[indexPath.row];
            NSDictionary *nextParamDic = @{@"shopId":foodModel.SORTFOOD_ID};
            ZSHFoodDetailViewController *foodDetailVC = [[ZSHFoodDetailViewController alloc]initWithParamDic:nextParamDic];
            [weakself.navigationController pushViewController:foodDetailVC animated:YES];
        };
    }
    
    return sectionModel;
}

- (void)requestData{
    kWeakSelf(self);
    [_foodLogic loadFoodListDataWithParamDic:@{@"HONOURUSER_ID":@"d6a3779de8204dfd9359403f54f7d27c"}];
    _foodLogic.requestDataCompleted = ^(id data){
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        [weakself initViewModel];
    };
}

-(void)headerRereshing{
    [self requestData];
}

#pragma mark ————— 上拉刷新 —————
-(void)footerRereshing{
     [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
