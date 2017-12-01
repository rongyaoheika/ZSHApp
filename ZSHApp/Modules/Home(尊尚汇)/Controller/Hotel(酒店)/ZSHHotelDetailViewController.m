//
//  ZSHHotelDetailViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelDetailViewController.h"
#import "ZSHHotelDetailHeadCell.h"
#import "ZSHHotelDetailDeviceCell.h"
#import "ZSHHotelCalendarCell.h"
#import "ZSHHotelListCell.h"
#import "ZSHHotelModel.h"
#import "ZSHBottomBlurPopView.h"
#import "ZSHKTVModel.h"
#import "ZSHNoticeViewCell.h"
#import "ZSHKTVListCell.h"
#import "ZSHHotelPayViewController.h"
#import "ZSHGoodsCommentSubViewController.h"
#import "ZSHHotelLogic.h"
#import "ZSHShopCommentViewController.h"

@interface ZSHHotelDetailViewController ()

@property (nonatomic, copy)   NSString                  *shopId;
@property (nonatomic, strong) ZSHHotelLogic             *hotelLogic;
@property (nonatomic, strong) ZSHHotelDetailModel       *hotelDetailModel;
@property (nonatomic, strong) NSDictionary              *hotelDetailParamDic;
@property (nonatomic, strong) NSArray                   *modelNameArr;

@property (nonatomic, strong) NSArray                   *hotelDetailListDicArr;
@property (nonatomic, strong) NSArray                   *hotelDetailListModelArr;

@property (nonatomic, strong) ZSHBaseModel              *model;
@property (nonatomic, strong) ZSHKTVModel               *KTVModel;
@property (nonatomic, strong) ZSHBottomBlurPopView      *bottomBlurPopView;
@property (nonatomic, strong) NSMutableArray            *dataArr;
@property (nonatomic, assign) BOOL                      showSeparatorLine;

@end

static NSString *ZSHHotelDetailHeadCellID = @"ZSHHotelDetailHeadCell";
static NSString *ZSHHotelDetailDeviceCellID = @"ZSHHotelDetailDeviceCell";
static NSString *ZSHBaseSubCellID = @"ZSHBaseSubCell";
static NSString *ZSHBookCellID = @"ZSHBookCell";
static NSString *ZSHHotelCalendarCellID = @"ZSHHotelCalendarCell";
static NSString *ZSHHotelListCellID = @"ZSHHotelListCell";
static NSString *ZSHKTVCalendarCellID = @"ZSHNoticeViewCell";
static NSString *ZSHKTVListCellID = @"ZSHKTVListCell";

@implementation ZSHHotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    self.model = self.paramDic[@"model"];
    self.shopId = self.paramDic[@"shopId"];
    self.dataArr = [[NSMutableArray alloc]init];
    [self requestData];
    
    if (kFromClassTypeValue == ZSHFromHomeKTVVCToHotelDetailVC) {
        [self.dataArr removeAllObjects];
        NSDictionary *KTVModelDic =
        @{@"imageName":@"food_image_1",@"price":@"399",@"address":@"三亚市天涯区黄山路90号",@"comment":@"120",@"detailImageName":@"hotel_detail_big",@"KTVName":@"麦乐迪（航天桥店）1",@"roomType":@"小包（2-4人）",@"time":@"10:00-13:00，共3小时"};
        self.model = [ZSHKTVModel mj_objectWithKeyValues:KTVModelDic];
    }
    
    [self initViewModel];
}

- (void)requestData{
    kWeakSelf(self);
    _hotelLogic = [[ZSHHotelLogic alloc]init];
    NSDictionary *paramDic = @{@"SORTHOTEL_ID":self.shopId};
    [_hotelLogic loadHotelDetailDataWithParamDic:paramDic];
    _hotelLogic.requestDataCompleted = ^(NSDictionary *paramDic){
        weakself.hotelDetailModel = paramDic[@"hotelDetailModel"];
        weakself.hotelDetailParamDic = paramDic[@"hotelDetailParamDic"];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        [weakself initViewModel];
    };
    
    [_hotelLogic loadHotelDetailListDataWithParamDic:paramDic success:^(NSArray *hotelDetailListDicArr) {
        _hotelDetailListDicArr = hotelDetailListDicArr;
        weakself.tableViewModel.sectionModelArray[2] = [weakself storHotelListSection];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
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
    
    if (kFromClassTypeValue == ZSHFromHomeKTVVCToHotelDetailVC) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView setSeparatorColor:KZSHColor1D1D1D];
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
   
    [self.tableView registerClass:[ZSHHotelDetailHeadCell class] forCellReuseIdentifier:ZSHHotelDetailHeadCellID];
    [self.tableView registerClass:[ZSHHotelDetailDeviceCell class] forCellReuseIdentifier:ZSHHotelDetailDeviceCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseSubCellID];
    [self.tableView registerClass:[ZSHHotelCalendarCell class] forCellReuseIdentifier:ZSHHotelCalendarCellID];
    [self.tableView registerClass:[ZSHHotelListCell class] forCellReuseIdentifier:ZSHHotelListCellID];
    
    //KTV
    [self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:ZSHKTVCalendarCellID];
    [self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:ZSHKTVCalendarCellID];
    [self.tableView registerClass:[ZSHKTVListCell class] forCellReuseIdentifier:ZSHKTVListCellID];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    if(kFromClassTypeValue == ZSHFromHotelVCToHotelDetailVC){//酒店详情
        [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeSubSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeCalendarSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storHotelListSection]];
    } else if(kFromClassTypeValue == ZSHFromHomeKTVVCToHotelDetailVC){//KTV详情
        [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeSubSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storKTVCalendarSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storKTVListSection]];
    }
    
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
        cell.fromClassType = [self.paramDic[KFromClassType]integerValue];
        if (weakself.hotelDetailModel) {
            [cell updateCellWithModel:_hotelDetailModel];
        }
        return cell;
        
    };
    
    //设备
    cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(80);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelDetailDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelDetailDeviceCellID forIndexPath:indexPath];
        cell.fromClassType = [self.paramDic[KFromClassType]integerValue];
        if (weakself.hotelDetailParamDic) {
            [cell updateCellWithParamDic:_hotelDetailParamDic];
        }
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
    if (_hotelDetailModel) {
      titleArr =  @[_hotelDetailModel.HOTELADDRESS,_hotelDetailModel.HOTELPHONE];
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
        NSDictionary *nextParamDic = @{@"shopId":self.shopId};
        ZSHShopCommentViewController *shopCommentVC = [[ZSHShopCommentViewController alloc]initWithParamDic:nextParamDic];
        [weakself.navigationController pushViewController:shopCommentVC animated:YES];
    };
    
    return sectionModel;
}

//日历
- (ZSHBaseTableViewSectionModel*)storeCalendarSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(25);
    sectionModel.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, sectionModel.headerHeight)];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(65);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelCalendarCellID forIndexPath:indexPath];
        cell.dateViewTapBlock = ^(NSInteger tag) {//tag = 1入住
            self.bottomBlurPopView = [weakself createBottomBlurPopViewWith:ZSHFromHotelDetailCalendarVCToBottomBlurPopView];
            [kAppDelegate.window addSubview:self.bottomBlurPopView];
        };
        return cell;
    };
    return sectionModel;
}

//酒店列单
- (ZSHBaseTableViewSectionModel*)storHotelListSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<_hotelDetailListDicArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(75);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHHotelListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelListCellID forIndexPath:indexPath];
            NSDictionary *paramDic = _hotelDetailListDicArr[indexPath.row];
            [cell updateCellWithParamDic:paramDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            weakself.bottomBlurPopView = [weakself createBottomBlurPopViewWith:ZSHFromHotelDetailConfirmOrderVCToBottomBlurPopView];
            [kAppDelegate.window addSubview:weakself.bottomBlurPopView];
        };
    }
    
    return sectionModel;
}

//KTV预定日历
- (ZSHBaseTableViewSectionModel*)storKTVCalendarSection{
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(60);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHNoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHKTVCalendarCellID forIndexPath:indexPath];
        NSDictionary *nextParamDic = @{KFromClassType:@(FromKTVCalendarVCToNoticeView)};
        [cell updateCellWithParamDic:nextParamDic];
        return cell;
    };
    
    //包间类型
    cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(43);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHNoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHKTVCalendarCellID forIndexPath:indexPath];
        NSDictionary *nextParamDic = @{KFromClassType:@(FromKTVRoomTypeVCToNoticeView)};
        [cell updateCellWithParamDic:nextParamDic];
        return cell;
    };
    
    return sectionModel;
}

//KTV底部列表
- (ZSHBaseTableViewSectionModel*)storKTVListSection{
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<2; i++){
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(75);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHKTVListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHKTVListCellID forIndexPath:indexPath];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
            NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromKTVDetailVCToHotelPayVC),@"model":self.model};
            ZSHHotelPayViewController *hotelPayVC = [[ZSHHotelPayViewController alloc]initWithParamDic:nextParamDic];
            [[kAppDelegate getCurrentUIVC].navigationController pushViewController:hotelPayVC animated:YES];
        };
    }
    return sectionModel;
}


#pragma getter
- (ZSHBottomBlurPopView *)createBottomBlurPopViewWith:(ZSHFromVCToBottomBlurPopView)fromClassType{
    NSDictionary *nextParamDic = @{KFromClassType:@(fromClassType),@"model":self.model};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:nextParamDic];
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
