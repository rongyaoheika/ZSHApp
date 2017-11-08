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

@interface ZSHFoodViewController ()

@property (nonatomic, strong)NSMutableArray           *dataArr;

@end

static NSString *ZSHFoodCellID = @"ZSHFoodCell";
@implementation ZSHFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    NSArray *baseDataArr = @[
                         @{@"imageName":@"food_image_1",@"price":@"399",@"address":@"三亚市天涯区黄山路90号",@"comment":@"120",@"detailImageName":@"food_image_big",@"foodName":@"菲罗牛排主题自助西餐厅1"},
                         @{@"imageName":@"food_image_1",@"price":@"309",@"address":@"三亚市天涯区黄山路78号",@"comment":@"10",@"detailImageName":@"food_image_big",@"foodName":@"菲罗牛排主题自助西餐厅2" }
                             ];
    self.dataArr = [ZSHFoodModel mj_objectArrayWithKeyValuesArray:baseDataArr];
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
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        kWeakSelf(cellModel);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHFoodCellID forIndexPath:indexPath];
            ZSHFoodModel *foodModel = weakself.dataArr[indexPath.row];
            [cell updateCellWithModel:foodModel];
            weakcellModel.height = foodModel.cellHeight;
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
             ZSHFoodModel *foodModel = weakself.dataArr[indexPath.row];
            NSDictionary *nextParamDic = @{@"fromClassType":@(ZSHFromFoodVCToHotelDetailVC),@"model":foodModel};
            ZSHHotelDetailViewController *hotelDetailVC = [[ZSHHotelDetailViewController alloc]initWithParamDic:nextParamDic];
            [weakself.navigationController pushViewController:hotelDetailVC animated:YES];
           
        };
    }
    
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
