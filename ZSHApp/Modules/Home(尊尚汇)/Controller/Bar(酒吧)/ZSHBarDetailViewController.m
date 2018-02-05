//
//  ZSHBarDetailViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBarDetailViewController.h"
#import "ZSHHotelDetailHeadCell.h"
#import "ZSHHotelDetailDeviceCell.h"
#import "ZSHHotelCalendarCell.h"
#import "ZSHHotelListCell.h"
#import "ZSHHotelModel.h"
#import "ZSHBottomBlurPopView.h"
#import "ZSHNoticeViewCell.h"
#import "ZSHHotelPayViewController.h"
#import "ZSHHotelLogic.h"
#import "ZSHShopCommentViewController.h"
#import "ZSHHotelCell.h"

@interface ZSHBarDetailViewController ()

@property (nonatomic, copy)   NSString                  *shopId;
@property (nonatomic, strong) ZSHHotelLogic             *hotelLogic;
@property (nonatomic, strong) ZSHHotelDetailModel       *hotelDetailModel;
@property (nonatomic, strong) NSDictionary              *barDetailDic;
@property (nonatomic, strong) NSArray                   *barDetailSetDicArr;
@property (nonatomic, strong) NSArray                   *barMoreShopDicArr;

@property (nonatomic, strong) ZSHBottomBlurPopView      *bottomBlurPopView;
@property (nonatomic, copy)   NSString                  *liveInfoStr;
@property (nonatomic, assign) BOOL                      showSeparatorLine;

@end

static NSString *ZSHHotelDetailHeadCellID = @"ZSHHotelDetailHeadCell";
static NSString *ZSHHotelDetailDeviceCellID = @"ZSHHotelDetailDeviceCell";
static NSString *ZSHBaseSubCellID = @"ZSHBaseSubCell";
static NSString *ZSHBookCellID = @"ZSHBookCell";
static NSString *ZSHHotelCalendarCellID = @"ZSHHotelCalendarCell";
static NSString *ZSHHotelListCellID = @"ZSHHotelListCell";
static NSString *ZSHHotelCellID = @"ZSHHotelCell";

@implementation ZSHBarDetailViewController

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
    _hotelLogic = [[ZSHHotelLogic alloc]init];
    NSDictionary *paramDic = @{@"SORTBAR_ID":self.shopId};
    [_hotelLogic loadBarDetailDataWithParamDic:paramDic success:^(NSDictionary *barDetailDic) {
       _barDetailDic = barDetailDic;
        [weakself initViewModel];
    } fail:nil];
   
    //套餐
    [_hotelLogic loadBarDetailSetDataWithParamDic:paramDic success:^(NSArray *barDetailSetDicArr) {
        _barDetailSetDicArr = barDetailSetDicArr;
        weakself.tableViewModel.sectionModelArray[2] = [weakself storeBarSetSection];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
        [weakself updateSectionDatWithSet:indexSet];
    } fail:nil];
    
    //更多商家
    [self loadDetailListData];
}

- (void)loadDetailListData{
    kWeakSelf(self);
    //更多商家（换一批）
    NSDictionary *detailListParamDic = @{@"HONOURUSER_ID":HONOURUSER_IDValue};
    [_hotelLogic loadBarDetailMoreShopDataWithParamDic:detailListParamDic success:^(id responseObject) {
        _barMoreShopDicArr = responseObject;
        weakself.tableViewModel.sectionModelArray[3] = [weakself storeBarMoreShopSection];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:3];
        [weakself updateSectionDatWithSet:indexSet];
    } fail:nil];
}

- (void)updateSectionDatWithSet:(NSIndexSet *)indexSet{
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView registerClass:[ZSHHotelDetailHeadCell class] forCellReuseIdentifier:ZSHHotelDetailHeadCellID];
    [self.tableView registerClass:[ZSHHotelDetailDeviceCell class] forCellReuseIdentifier:ZSHHotelDetailDeviceCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseSubCellID];
    [self.tableView registerClass:[ZSHHotelCalendarCell class] forCellReuseIdentifier:ZSHHotelCalendarCellID];
    [self.tableView registerClass:[ZSHHotelListCell class] forCellReuseIdentifier:ZSHHotelListCellID];
    [self.tableView registerClass:[ZSHHotelCell class] forCellReuseIdentifier:ZSHHotelCellID];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeSubSection]];
//    [self.tableViewModel.sectionModelArray addObject:[self storeCalendarSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeBarSetSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeBarMoreShopSection]];
    [self.tableView reloadData];
}

//图片，设备
- (ZSHBaseTableViewSectionModel*)storeHeadSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(225);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelDetailHeadCellID forIndexPath:indexPath];
        cell.shopType = ZSHBarShopType;
        if (_barDetailDic) {
            [cell updateCellWithParamDic:weakself.barDetailDic];
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
        cell.shopType = ZSHBarShopType;
        [cell updateCellWithParamDic:weakself.barDetailDic];
        [self hideSeparatorLineWithCell:cell hide:YES];
        return cell;
    };
    
    return sectionModel;
}

//地址，电话，订购
- (ZSHBaseTableViewSectionModel*)storeSubSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *arrowImageArr = @[@"hotel_map",@"hotel_phone"];
    NSArray *titleArr = @[@"三亚市天涯区黄山路94号",@"0898-86868686"];
    if (_barDetailDic) {
        titleArr =  @[_barDetailDic[@"BARADDRESS"],_barDetailDic[@"BARPHONE"]];
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
            
            [self hideSeparatorLineWithCell:cell hide:YES];
            return cell;
        };
    }
    //订购
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(35);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        NSInteger   commentCount = 99;
        CGFloat     scoreCount = 4.9;
        if (_hotelDetailModel) {
            commentCount = _hotelDetailModel.HOTELEVACOUNT;
            scoreCount = _hotelDetailModel.HOTELEVALUATE;
        }
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ZSHBookCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld条评论",(long)commentCount];
        
        [self hideSeparatorLineWithCell:cell hide:NO];
        if (![cell.contentView viewWithTag:2]) {
            NSDictionary *scoreBtnDic = @{@"title":[NSString stringWithFormat:@"%.1f",scoreCount],@"titleColor":KWhiteColor,@"font":kPingFangMedium(12),@"backgroundColor":[UIColor colorWithHexString:@"F29E19"]};
            UIButton *scoreBtn = [ZSHBaseUIControl createBtnWithParamDic:scoreBtnDic];
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
        //用户评价
        NSDictionary *nextParamDic = @{KFromClassType:@(ZSHBarShopType),@"shopId":self.shopId};
        ZSHShopCommentViewController *shopCommentVC = [[ZSHShopCommentViewController alloc]initWithParamDic:nextParamDic];
        [weakself.navigationController pushViewController:shopCommentVC animated:YES];
    };
    
    return sectionModel;
}

//日历
//- (ZSHBaseTableViewSectionModel*)storeCalendarSection {
//    kWeakSelf(self);
//    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
//    sectionModel.headerHeight = kRealValue(25);
//    sectionModel.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, sectionModel.headerHeight)];
//
//    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
//    [sectionModel.cellModelArray addObject:cellModel];
//    cellModel.height = kRealValue(65);
//    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
//        ZSHHotelCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelCalendarCellID forIndexPath:indexPath];
//        [weakself hideSeparatorLineWithCell:cell hide:YES];
//        _liveInfoStr = @"8-8入住，8-9离开，1天";
//        cell.dateViewTapBlock = ^(NSInteger tag) {//tag = 1入住
//            NSDictionary *paramDic = _barDetailSetDicArr[indexPath.row];
//            NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromHotelDetailCalendarVCToBottomBlurPopView),@"dic":paramDic};
//            self.bottomBlurPopView = [weakself createBottomBlurPopViewWithParamDic:nextParamDic];
//            [kAppDelegate.window addSubview:self.bottomBlurPopView];
//        };
//        return cell;
//    };
//    return sectionModel;
//}

//酒吧套餐
- (ZSHBaseTableViewSectionModel*)storeBarSetSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(40);
    NSDictionary *headTitleParamDic = @{@"text":@"套餐",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    
    for (int i = 0; i<_barDetailSetDicArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(75);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHHotelListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelListCellID forIndexPath:indexPath];
            cell.shopType = ZSHBarShopType;
            NSDictionary *paramDic = _barDetailSetDicArr[indexPath.row];
            [cell updateCellWithParamDic:paramDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            NSDictionary *paramDic = _barDetailSetDicArr[indexPath.row];
            NSDictionary *nextParamDic = @{KFromClassType:@(ZSHConfirmOrderToBottomBlurPopView),@"shopType":@(ZSHBarShopType), @"deviceDic":_barDetailDic,@"listDic":paramDic,@"liveInfoStr":@"酒吧无此字段"};
            weakself.bottomBlurPopView = [weakself createBottomBlurPopViewWithParamDic:nextParamDic];
            [weakself.view addSubview:weakself.bottomBlurPopView];
            
        };
    }
    
    return sectionModel;
}

//酒吧更多商家
- (ZSHBaseTableViewSectionModel*)storeBarMoreShopSection{
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(40);
    NSDictionary *headTitleParamDic = @{@"text":@"更多商家",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    UIButton *btn = [sectionModel.headerView viewWithTag:2];
    btn.hidden = NO;
    [btn addTarget:self action:@selector(loadDetailListData) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i<_barMoreShopDicArr.count; i++){
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(110);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHHotelCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelCellID forIndexPath:indexPath];
            cell.shopType = ZSHBarShopType;
            if (i==_barMoreShopDicArr.count-1) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
            NSDictionary *paramDic = _barMoreShopDicArr[indexPath.row];
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

//隐藏cell的分割线
- (void)hideSeparatorLineWithCell:(ZSHBaseCell *)cell hide:(BOOL)hide{
    if (kFromClassTypeValue == ZSHFromHotelVCToHotelDetailVC || hide) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
    }
}

#pragma action
- (void)bookAction{
    
}


-(void)headerRereshing{
    [self requestData];
}


-(void)footerRereshing{
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
