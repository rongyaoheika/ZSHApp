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
#import "ZSHHotelCell.h"
#import "ZSHGuideView.h"


@interface ZSHFoodViewController ()

@property (nonatomic, strong) NSArray                  *foodListArr;
@property (nonatomic, strong) ZSHFoodLogic             *foodLogic;
@property (nonatomic, strong) ZSHGuideView             *guideView;

@end

static NSString *ZSHFoodCellID = @"ZSHFoodCell";
@implementation ZSHFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateListData:) name:KUpdateDataWithSort object:nil];
    [self createUI];
    [self loadData];


    // abc 

    
    //zwwTest more
}

- (void)loadData{
    _foodLogic = [[ZSHFoodLogic alloc]init];
    [self requestData];
    [self initViewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_foodListArr) {
        [self requestData];
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
    [self.tableView registerClass:[ZSHHotelCell class] forCellReuseIdentifier:ZSHFoodCellID];
    self.tableView.tableHeaderView = self.guideView;

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
    for (int i = 0; i < _foodListArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(110);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHHotelCell *cell =  [tableView dequeueReusableCellWithIdentifier:ZSHFoodCellID forIndexPath:indexPath];
            if (i==_foodListArr.count-1) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
            cell.shopType = ZSHFoodShopType;
            NSDictionary *foodDic = _foodListArr[indexPath.row];
            [cell updateCellWithParamDic:foodDic];
            return cell;
        };

        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            NSDictionary *foodDic = _foodListArr[indexPath.row];
            NSDictionary *nextParamDic = @{@"shopId":foodDic[@"SORTFOOD_ID"]};
            ZSHFoodDetailViewController *foodDetailVC = [[ZSHFoodDetailViewController alloc]initWithParamDic:nextParamDic];
            [weakself.navigationController pushViewController:foodDetailVC animated:YES];
        };
    }
    
    return sectionModel;
}

- (void)requestData{
    kWeakSelf(self);
    [_foodLogic loadFoodListDataWithParamDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        _foodListArr = responseObject[@"pd"];
        [weakself updateAd:responseObject[@"ad"]];
        [weakself initViewModel];
    } fail:nil];

}

- (void)updateAd:(NSArray *)arr {
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic  in arr) {
        [imageArr addObject:dic[@"SHOWIMG"]];
    }
    [_guideView updateViewWithParamDic:@{@"dataArr":imageArr}];
}

-(void)headerRereshing{
    [self requestData];
}


-(void)footerRereshing{
     [self.tableView.mj_footer endRefreshing];
}


- (void)updateListData:(NSNotification *)notification{
    kWeakSelf(self);
   
    ZSHToTitleContentVC type = [notification.object[KFromClassType]integerValue];
    if (type != FromFoodVCToTitleContentVC) {
        return;
    }
    
    //类型
    NSString *midTitle = notification.object[@"midTitle"];
    //行数
    NSInteger row = [notification.object[@"row"] integerValue];
    //行标题
    NSString *rowTitle = notification.object[@"rowTitle"];
    
    NSDictionary *paramDic = nil;
    NSArray *paramArr = nil;
    if ([midTitle containsString:@"排序"]) {
        //0:推荐  1：距离由近到远  2：评分由高到低 3：价格由高到低 4：价格由低到高
        paramArr = @[@{},@{},
                     @{@"HONOURUSER_ID":HONOURUSER_IDValue,@"COLUMN":@"SHOPEVALUATE",@"SEQUENCE":@"DESC",@"BRAND":@"",@"STYLE":@""}, @{@"HONOURUSER_ID":HONOURUSER_IDValue,@"COLUMN":@"SHOPPRICE",@"SEQUENCE":@"DESC",@"BRAND":@"",@"STYLE":@""}, @{@"HONOURUSER_ID":HONOURUSER_IDValue,@"COLUMN":@"SHOPPRICE",@"SEQUENCE":@"ASC",@"BRAND":@"",@"STYLE":@""}];
        paramDic = paramArr[row];
        
    } else if ([midTitle containsString:@"品牌"]){
        paramDic =  @{@"HONOURUSER_ID":HONOURUSER_IDValue,@"COLUMN":@"",@"SEQUENCE":@"",@"BRAND":rowTitle,@"STYLE":@""};
        
    } else if ([midTitle containsString:@"筛选"]){
        paramDic =  @{@"HONOURUSER_ID":HONOURUSER_IDValue,@"COLUMN":@"",@"SEQUENCE":@"",@"BRAND":@"",@"STYLE":rowTitle};
        
    }
    
    [_foodLogic loadFoodSortWithParamDic:paramDic success:^(id responseObject) {
        RLog(@"排序后的数据==%@",responseObject);
         _foodListArr = responseObject;
        [weakself initViewModel];
    } fail:nil];
}

- (ZSHGuideView *)guideView {
    if(!_guideView) {
        NSDictionary *nextParamDic = @{KFromClassType:@(FromBuyVCToGuideView),@"pageViewHeight":@(kRealValue(120)),@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false)};
        _guideView = [[ZSHGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(120)) paramDic:nextParamDic];
    }
    return _guideView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
