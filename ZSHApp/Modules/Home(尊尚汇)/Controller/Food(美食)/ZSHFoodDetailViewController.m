//
//  ZSHFoodDetailViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFoodDetailViewController.h"
#import "ZSHFoodLogic.h"
#import "ZSHHotelDetailHeadCell.h"
#import "ZSHHotelDetailDeviceCell.h"
#import "ZSHShopCommentViewController.h"

#import "ZSHHotelCell.h"
#import "ZSHHotelListCell.h"

@interface ZSHFoodDetailViewController ()

@property (nonatomic, copy)   NSString                  *shopId;
@property (nonatomic, strong) ZSHFoodLogic              *foodLogic;
@property (nonatomic, strong) ZSHFoodDetailModel        *foodDetailModel;
@property (nonatomic, strong) NSDictionary              *foodDetailParamDic;
@property (nonatomic, strong) ZSHBottomBlurPopView      *bottomBlurPopView;
@property (nonatomic, strong) NSArray                   *foodDetailSetDicArr;
@property (nonatomic, strong) NSArray                   *foodDetailListDicArr;

@end

static NSString *ZSHHotelDetailHeadCellID = @"ZSHHotelDetailHeadCell";
static NSString *ZSHHotelDetailDeviceCellID = @"ZSHHotelDetailDeviceCell";
static NSString *ZSHBaseSubCellID = @"ZSHBaseSubCell";
static NSString *ZSHBookCellID = @"ZSHBookCell";
static NSString *ZSHHotelCellID = @"ZSHHotelCell";
static NSString *ZSHHotelListCellID = @"ZSHHotelListCell";

@implementation ZSHFoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    self.shopId = self.paramDic[@"shopId"];
    [self requestData];
    [self initViewModel];
}

- (void)requestData{
    kWeakSelf(self);
    
    _foodLogic = [[ZSHFoodLogic alloc]init];
    NSDictionary *paramDic = @{@"SORTFOOD_ID":self.shopId};
    [_foodLogic loadFoodDetailDataWithParamDic:paramDic];
    _foodLogic.requestDataCompleted = ^(NSDictionary *paramDic){
        _foodDetailModel = paramDic[@"foodDetailModel"];
        _foodDetailParamDic = paramDic[@"foodDetailParamDic"];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        [weakself initViewModel];
    };
    
    //套餐
    [_foodLogic loadFoodDetailSetWithParamDic:paramDic success:^(id responseObject) {
        _foodDetailSetDicArr = responseObject;
        weakself.tableViewModel.sectionModelArray[2] = [weakself storeSetMenuSection];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
        [weakself updateSectionDatWithSet:indexSet];
    } fail:nil];
   
    [self loadDetailListData];
    
}

- (void)loadDetailListData{
    kWeakSelf(self);
    //换一批
    NSDictionary *detailListParamDic = @{@"HONOURUSER_ID":HONOURUSER_IDValue};
    [_foodLogic loadFoodDetailListDataWithParamDic:detailListParamDic success:^(NSArray *foodDetaiDicListArr) {
        _foodDetailListDicArr = foodDetaiDicListArr;
        weakself.tableViewModel.sectionModelArray[3] = [weakself storeMoreShopSection];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:3];
        [weakself updateSectionDatWithSet:indexSet];
        
    } fail:nil];
}

- (void)updateSectionDatWithSet:(NSIndexSet *)indexSet{
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)createUI{
    
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.view addSubview:self.tableView];
   
    [self.tableView registerClass:[ZSHHotelDetailHeadCell class] forCellReuseIdentifier:ZSHHotelDetailHeadCellID];
    [self.tableView registerClass:[ZSHHotelDetailDeviceCell class] forCellReuseIdentifier:ZSHHotelDetailDeviceCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseSubCellID];
    [self.tableView registerClass:[ZSHHotelListCell class] forCellReuseIdentifier:ZSHHotelListCellID];
    [self.tableView registerClass:[ZSHHotelCell class] forCellReuseIdentifier:ZSHHotelCellID];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeSubSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeSetMenuSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMoreShopSection]];
    [self.tableView reloadData];
}

//图片，设备
- (ZSHBaseTableViewSectionModel*)storeHeadSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(225);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelDetailHeadCellID forIndexPath:indexPath];
        cell.shopType = ZSHFoodShopType;
        if (_foodDetailParamDic) {
            [cell updateCellWithParamDic:_foodDetailParamDic];
        }
        return cell;
        
    };
    
    //设备
    cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(80);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelDetailDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelDetailDeviceCellID forIndexPath:indexPath];
        cell.showCellType = ZSHNormalType;
        cell.shopType = ZSHFoodShopType;
        if (_foodDetailParamDic) {
            [cell updateCellWithParamDic:_foodDetailParamDic];
        }
        
        return cell;
    };
    
    return sectionModel;
}

//地址，电话，评论
- (ZSHBaseTableViewSectionModel*)storeSubSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *arrowImageArr = @[@"hotel_map",@"hotel_phone"];
    NSArray *titleArr = @[@"三亚市天涯区黄山路94号",@"0898-86868686"];
    if (_foodDetailModel) {
        titleArr = @[_foodDetailModel.SHOPADDRESS, _foodDetailModel.SHOPPHONE];
    }

    for (int i = 0; i <arrowImageArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(35);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseSubCellID forIndexPath:indexPath];
            cell.arrowImageName = arrowImageArr[i];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = titleArr[i];
            cell.textLabel.font = kPingFangMedium(12);
            return cell;
        };
    }
    //评论
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(35);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        NSInteger   commentCount = 99;
        CGFloat     scoreCount = 4.9;
        if (_foodDetailModel) {
            commentCount = _foodDetailModel.SHOPEVACOUNT;
            scoreCount = _foodDetailModel.SHOPEVALUATE;
        }
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ZSHBookCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld条评论",(long)commentCount];
        if (![cell.contentView viewWithTag:2]) {
            NSDictionary *scoreBtnDic = @{@"title":[NSString stringWithFormat:@"%.1f",scoreCount] ,@"titleColor":KWhiteColor,@"font":kPingFangMedium(12),@"backgroundColor":[UIColor colorWithHexString:@"F29E19"]};
            UIButton *scoreBtn = [ZSHBaseUIControl  createBtnWithParamDic:scoreBtnDic target:self action:nil];
            scoreBtn.tag = 2;
            scoreBtn.layer.cornerRadius = kRealValue(2.5);
            [cell.contentView addSubview:scoreBtn];
            [scoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kRealValue(30), kRealValue(20)));
                make.centerY.mas_equalTo(cell);
                make.left.mas_equalTo(cell).offset(KLeftMargin);
            }];
        }
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFoodShopType), @"shopId":self.shopId};
        ZSHShopCommentViewController *shopCommentVC = [[ZSHShopCommentViewController alloc]initWithParamDic:nextParamDic];
        [weakself.navigationController pushViewController:shopCommentVC animated:YES];
    };
    
    return sectionModel;
}

//套餐列表
- (ZSHBaseTableViewSectionModel*)storeSetMenuSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(40);
    NSDictionary *headTitleParamDic = @{@"text":@"套餐",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    
    for (int i = 0; i<_foodDetailSetDicArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(75);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHHotelListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelListCellID forIndexPath:indexPath];
            cell.shopType = ZSHFoodShopType;
            NSDictionary *paramDic = _foodDetailSetDicArr[indexPath.row];
            [cell updateCellWithParamDic:paramDic];
            
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            NSDictionary *paramDic = _foodDetailSetDicArr[indexPath.row];
            NSDictionary *nextParamDic = @{KFromClassType:@(ZSHConfirmOrderToBottomBlurPopView),@"shopType":@(ZSHFoodShopType), @"deviceDic":weakself.foodDetailParamDic,@"listDic":paramDic,@"liveInfoStr":@""};
            weakself.bottomBlurPopView = [weakself createBottomBlurPopViewWithParamDic:nextParamDic];
            [weakself.view addSubview:weakself.bottomBlurPopView];
        };
    }
    
    return sectionModel;
}

//更多商家
- (ZSHBaseTableViewSectionModel*)storeMoreShopSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(40);
    NSDictionary *headTitleParamDic = @{@"text":@"更多商家",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    UIButton *btn = [sectionModel.headerView viewWithTag:2];
    btn.hidden = NO;
    [btn addTarget:self action:@selector(loadDetailListData) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i<_foodDetailListDicArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(110);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHHotelCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelCellID forIndexPath:indexPath];
            cell.shopType = ZSHFoodShopType;
            if (i==_foodDetailListDicArr.count-1) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
            NSDictionary *paramDic = _foodDetailListDicArr[indexPath.row];
            [cell updateCellWithParamDic:paramDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
           
        };
    }
    
    return sectionModel;
}


#pragma getter
- (ZSHBottomBlurPopView *)createBottomBlurPopViewWithParamDic:(NSDictionary *)paramDic{
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:paramDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    return bottomBlurPopView;
}

#pragma action


#pragma mark ————— 下拉刷新 —————
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
