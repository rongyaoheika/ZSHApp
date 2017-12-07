//
//  ZSHBottomBlurPopView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBottomBlurPopView.h"
#import "ZSHTopLineView.h"
#import "ZSHHotelDetailHeadCell.h"
#import "ZSHHotelDetailDeviceCell.h"
#import "ZSHHotelPayHeadCell.h"
#import "ZSHHotelModel.h"
#import "ZSHKTVModel.h"
#import "ZSHHotelPayViewController.h"
#import "ZSHTextFieldCellView.h"
#import "JSNummberCount.h"
//日历
#import "STCalendar.h"
#import "NSCalendar+ST.h"

//年龄
#import "ZSHAgeView.h"

#import "ZSHLivePersonInfoView.h"

//直播弹窗
#import "ZSHLivePopView.h"
#import "ZSHTrainPassengerController.h"
#import "ZSHShareView.h"

//直播 - 附近搜索
#import "ZSHSearchLiveFirstCell.h"
#import "ZSHSearchLiveSecondCell.h"
#import "ZSHSearchLiveThirdCell.h"
#import "ZSHWeiboViewController.h"

//我的-订单列表
#import "ZSHCardBtnListView.h"

//确认订单
#import "ZSHConfirmOrderLogic.h"
#import <FSCalendar.h>

@interface ZSHBottomBlurPopView ()<STCalendarDelegate, FSCalendarDataSource, FSCalendarDelegate>

@property (nonatomic, strong) NSDictionary           *paramDic;
@property (nonatomic, strong) ZSHBaseModel           *model;
@property (nonatomic, strong) ZSHHotelModel          *hotelModel;
@property (nonatomic, strong) ZSHKTVModel            *KTVModel;
@property (nonatomic, strong) ZSHTopLineView         *topLineView;
@property (nonatomic, copy)   NSString               *typeText;
@property (nonatomic, strong) UITableView            *subTab;
@property (nonatomic, strong) NSArray                *titleArr;
@property (nonatomic, assign) CGFloat                subTabHeight;

//日历相关
@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, strong) UIView          *calendarHeadView;
@property (nonatomic, strong) UILabel         *currentDateLabel;
@property (nonatomic, strong) UIView          *weekView;
@property (nonatomic, strong, nullable) STCalendar *calender;

//确认订单
@property (nonatomic, assign) ZSHShopType            shopType;
@property (nonatomic, strong) NSDictionary           *deviceDic;
@property (nonatomic, strong) NSDictionary           *listDic;
@property (nonatomic, copy)   NSString               *liveInfo;
@property (nonatomic, strong) ZSHConfirmOrderLogic   *orderLogic;


//底部年龄弹出框
@property (nonatomic, strong) ZSHAgeView            *ageView;
@property (nonatomic, copy)   NSString              *ageRangeStr;

@property (strong , nonatomic) FSCalendar *calendar;

@end

static NSString *ZSHHeadCellID = @"ZSHHeadCell";
static NSString *ZSHHotelListCellID = @"ZSHHotelListCell";

//兑换券
static NSString *ZSHNumCountCellID = @"ZSHNumCountCell";
static NSString *ZSHExchangeSecondCellID = @"ZSHExchangeSecondCell";

//确认订单
static NSString *ZSHHotelDetailDeviceCellID = @"ZSHHotelDetailDeviceCell";
static NSString *ZSHHotelPayHeadCellID = @"ZSHHotelPayHeadCell";

//日历
static NSString *ZSHCalendarCellID = @"ZSHCalendarCell";

//首页-菜单栏
static NSString *ZSHBaseCellID = @"ZSHBaseCell";

//直播 - 附近搜索
static NSString *ZSHSearchLiveFirstCellID = @"ZSHSearchLiveFirstCell";
static NSString *ZSHSearchLiveSecondCellID = @"ZSHSearchLiveSecondCell";
static NSString *ZSHSearchLiveThirdCellID = @"ZSHSearchLiveThirdCell";


@implementation ZSHBottomBlurPopView

- (instancetype)initWithFrame:(CGRect)frame paramDic:(NSDictionary *)paramDic{
    self = [super initWithFrame:frame];
    if (self) {
        _paramDic = paramDic;
    
        [self loadData];
        [self createUI];
       
    }
    return self;
}

- (void)loadData{
    if (kFromClassTypeValue == ZSHFromHotelVCToBottomBlurPopView) {
        self.titleArr = @[@"距离",@"推荐",@"价格从低到高"];
        self.typeText = @"排序";
    } else if (kFromClassTypeValue == ZSHFromExchangeVCToBottomBlurPopView){
        self.typeText = @"请选择兑换数量";
    } else if (kFromClassTypeValue == ZSHFromHotelDetailCalendarVCToBottomBlurPopView){
        self.typeText = @"请选择入住离店时间";
    } else if (kFromClassTypeValue == ZSHConfirmOrderToBottomBlurPopView){
        self.shopType = [self.paramDic[@"shopType"]integerValue]; //弹窗类型
        self.deviceDic = self.paramDic[@"deviceDic"];  //详情页上半部分数据
        self.listDic = self.paramDic[@"listDic"];      //详情页下半部分列表数据
        self.liveInfo = self.paramDic[@"liveInfoStr"]; //酒店居住时间信息
        
        
        self.model = (ZSHHotelModel *)_paramDic[@"model"];
    } else if (kFromClassTypeValue == ZSHFromKTVConfirmOrderVCToBottomBlurPopView){
        self.model = (ZSHKTVModel *)_paramDic[@"model"];
    } else if (kFromClassTypeValue == ZSHFromAirplaneCalendarVCToBottomBlurPopView || kFromClassTypeValue == ZSHFromTrainCalendarVCToBottomBlurPopView){//机票日期选择
        self.typeText = @"请选择出发时间";
    }
    if (self.paramDic[@"typeText"]) {
        self.typeText = self.paramDic[@"typeText"];
    }
    
    self.tableViewModel = [[ZSHBaseTableViewModel alloc] init];
    [self initViewModel];
}

- (void)createUI{
    self.backgroundColor = KClearColor;
//    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlurViewAction:)]];
    
    if (kFromClassTypeValue != ZSHFromPersonInfoVCToBottomBlurPopView && kFromClassTypeValue != ZSHFromLiveMidVCToBottomBlurPopView && kFromClassTypeValue != ZSHFromGoodsMineVCToToBottomBlurPopView) {
        self.subTab = [ZSHBaseUIControl createTableView];
        self.subTab.backgroundColor = KWhiteColor;
        self.subTab.scrollEnabled = NO;
        self.subTab.tag = 2;
        [self addSubview: self.subTab];
    }
    if (kFromClassTypeValue == ZSHFromHotelVCToBottomBlurPopView){//酒店排序
        _subTabHeight = kRealValue(200);
        
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHotelListCellID];
    } else if (kFromClassTypeValue == ZSHFromExchangeVCToBottomBlurPopView) {//积分兑换
        _subTabHeight =  kRealValue(170);
        
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHNumCountCellID];
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHExchangeSecondCellID];
    } else if (kFromClassTypeValue == ZSHConfirmOrderToBottomBlurPopView) {//确认订单
        _subTabHeight = kRealValue(410);
        [self.subTab registerClass:[ZSHHotelDetailDeviceCell class] forCellReuseIdentifier:ZSHHotelDetailDeviceCellID];
        [self.subTab registerClass:[ZSHHotelPayHeadCell class] forCellReuseIdentifier:ZSHHotelPayHeadCellID];
    } else if (kFromClassTypeValue == ZSHFromHotelDetailCalendarVCToBottomBlurPopView||kFromClassTypeValue == ZSHFromAirplaneCalendarVCToBottomBlurPopView) {//酒店入住(机票预订)日历
        _subTabHeight = kRealValue(360);
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
        [self.subTab registerClass:[ZSHHotelPayHeadCell class] forCellReuseIdentifier:ZSHHotelPayHeadCellID];
    } else if (kFromClassTypeValue == ZSHFromAirplaneUserInfoVCToBottomBlurPopView) {//机票个人信息
        _subTabHeight = kRealValue(310.5);
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
    } else if (kFromClassTypeValue == ZSHFromAirplaneAgeVCToBottomBlurPopView) {//吃喝玩乐年龄
        _subTabHeight = kRealValue(165);
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
    }  else if (kFromClassTypeValue == ZSHFromHomeMenuVCToBottomBlurPopView) {//首页-菜单栏
        
        self.subTab.frame = CGRectMake(KScreenWidth - kRealValue(7.5) - kRealValue(100), 0, kRealValue(100),kRealValue(128));
        self.subTab.backgroundColor = KClearColor;
        UIImageView *tbBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_bg"]];
        tbBgImageView.frame = self.subTab.bounds;
        self.subTab.backgroundView = tbBgImageView;
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
        self.subTab.delegate = self.tableViewModel;
        self.subTab.dataSource = self.tableViewModel;
        [self.subTab reloadData];
        return;
        
    } else if (kFromClassTypeValue == ZSHFromPersonInfoVCToBottomBlurPopView) {
        ZSHLivePersonInfoView *personInfoView = [[ZSHLivePersonInfoView alloc] init];
        personInfoView.userInteractionEnabled = YES;
        [self addSubview:personInfoView];
        [personInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kRealValue(260), kRealValue(318)));
        }];
    }  else if (kFromClassTypeValue == ZSHFromLiveMidVCToBottomBlurPopView) {//直播-直播弹窗
        
        ZSHLivePopView *livePopView = [[ZSHLivePopView alloc]initWithFrame:CGRectMake(0, KScreenHeight- kRealValue(150), KScreenWidth, kRealValue(150))];
        livePopView.backgroundColor = KWhiteColor;
        livePopView.tag = 2;
        [self addSubview:livePopView];
        return;
    }  else if (kFromClassTypeValue == ZSHFromLiveNearSearchVCToBottomBlurPopView) {//直播-筛选播主
        _subTabHeight = kRealValue(217);
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
        [self.subTab registerClass:[ZSHSearchLiveFirstCell class] forCellReuseIdentifier:ZSHSearchLiveFirstCellID];
        [self.subTab registerClass:[ZSHSearchLiveSecondCell class] forCellReuseIdentifier:ZSHSearchLiveSecondCellID];
        [self.subTab registerClass:[ZSHSearchLiveThirdCell class] forCellReuseIdentifier:ZSHSearchLiveThirdCellID];
    } else if (kFromClassTypeValue == ZSHFromShareVCToToBottomBlurPopView) { //分享
        
        ZSHShareView *shareView = [[ZSHShareView alloc] init];
        [self addSubview:shareView];
        [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, kRealValue(185)));
        }];
        return;
    } else if (kFromClassTypeValue == ZSHFromTrainUserInfoVCToBottomBlurPopView) {//火车票个人信息
        _subTabHeight = kRealValue(266.5);
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
    } else if (kFromClassTypeValue == ZSHFromGoodsMineVCToToBottomBlurPopView) { //我的-订单中心-订单列表
        NSArray *titleArr = @[@"尊购",@"火车票",@"机票",@"酒店",@"KTV",@"美食",@"酒吧",@"电影"];
        NSDictionary *nextParamDic = @{@"titleArr":titleArr,@"normalImage":@"card_normal",@"selectedImage":@"card_press"};
        ZSHCardBtnListView *listView = [[ZSHCardBtnListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(140)) paramDic:nextParamDic];
        [listView selectedByIndex:1];
        listView.tag = 2;
        [self addSubview:listView];
        return;
    }else if (kFromClassTypeValue == ZSHFromTrainCalendarVCToBottomBlurPopView) {// 火车票
        kWeakSelf(self);
        [self addSubview:self.topLineView];
        self.topLineView.backgroundColor = [UIColor whiteColor];
        self.topLineView.frame = CGRectMake(0, kScreenHeight-364, KScreenWidth, 50);
        self.topLineView.btnActionBlock = ^(NSInteger tag) {
            tag == 0? [weakself dismiss]:[weakself saveChange];
        };
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, kScreenHeight-314, KScreenWidth, 314)];
        calendar.backgroundColor = [UIColor whiteColor];
        calendar.dataSource = self;
        calendar.delegate = self;
        calendar.calendarHeaderView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        calendar.appearance.weekdayTextColor = KZSHColorFD5739;
        calendar.appearance.todayColor = KZSHColorFD5739;
        calendar.appearance.headerTitleColor = KZSHColor929292;
        calendar.appearance.selectionColor = KZSHColorD8D8D8;
        calendar.appearance.headerDateFormat = @"YYYY年M月";
        calendar.appearance.headerTitleFont  = kPingFangRegular(12);
        calendar.headerHeight = 30.0;
        calendar.weekdayHeight = 50.0;
        [self addSubview:calendar];
        self.calendar = calendar;
        return;
    }
    
    
    self.subTab.delegate = self.tableViewModel;
    self.subTab.dataSource = self.tableViewModel;
    self.subTab.frame = CGRectMake(0, KScreenHeight, KScreenWidth,_subTabHeight);
    self.subTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.subTab setSeparatorColor:KZSHColorE9E9E9];
    [self.subTab setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.subTab reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect mainFrame =  self.subTab.frame;
        mainFrame.origin.y = self.frame.size.height - mainFrame.size.height;
        self.subTab.frame = mainFrame;
    }];
}

- (void)initViewModel {
    if ([self.paramDic[KFromClassType]integerValue] == ZSHFromHotelVCToBottomBlurPopView) {//酒店排序
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    } else if ([self.paramDic[KFromClassType]integerValue] == ZSHFromExchangeVCToBottomBlurPopView) {//积分兑换
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeNumCountSectionWithTitle:@"购买数量"]];
        [self.tableViewModel.sectionModelArray addObject:[self storeExchangeSecondSection]];
    } else if (kFromClassTypeValue == ZSHConfirmOrderToBottomBlurPopView){//确认订单
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storePayHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeHotelDetailSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeNumCountSectionWithTitle:@"数量"]];
        [self.tableViewModel.sectionModelArray addObject:[self storeHotelDetailOtherSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeConfirmBtnSection]];
    } else if (kFromClassTypeValue == ZSHFromHotelDetailCalendarVCToBottomBlurPopView||kFromClassTypeValue == ZSHFromAirplaneCalendarVCToBottomBlurPopView){//酒店入住日历(机票选择日历)
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeCalendarDetailSection]];
    }  else if (kFromClassTypeValue == ZSHFromAirplaneUserInfoVCToBottomBlurPopView){//机票个人信息
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeTicketUserInfoBtnSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeConfirmBtnSection]];
    } else if (kFromClassTypeValue == ZSHFromAirplaneAgeVCToBottomBlurPopView){//年龄选择
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeAgeSection]];
    } else if (kFromClassTypeValue == ZSHFromHomeMenuVCToBottomBlurPopView){//首页-菜单
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeMenuListSection]];
    } else if (kFromClassTypeValue == ZSHFromLiveNearSearchVCToBottomBlurPopView){//直播-筛选播主
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeLiveSearchSection]];
    } else if (kFromClassTypeValue == ZSHFromTrainUserInfoVCToBottomBlurPopView){//火车票个人信息
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self stroreTrainUserInfo]];
        [self.tableViewModel.sectionModelArray addObject:[self storeConfirmBtnSection]];
    }

}

//head
- (ZSHBaseTableViewSectionModel*)storeHeadSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(50);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHeadCellID forIndexPath:indexPath];
        cell.backgroundColor = KWhiteColor;
        [cell.contentView addSubview:self.topLineView];
        self.topLineView.btnActionBlock = ^(NSInteger tag) {
            tag == 0? [weakself dismiss]:[weakself saveChange];
        };
        return cell;
    };
    
    return sectionModel;
}

//酒店排序弹窗
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(16);
    sectionModel.footerHeight = kRealValue(22);
    sectionModel.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(16))];
    sectionModel.headerView.backgroundColor = KWhiteColor;
    sectionModel.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(22))];
    sectionModel.footerView.backgroundColor = KWhiteColor;
    for (int i = 0; i<_titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(37.5);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelListCellID forIndexPath:indexPath];
            cell.backgroundColor = KWhiteColor;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = self.titleArr[indexPath.row];
            cell.textLabel.font = kPingFangRegular(15);
            cell.textLabel.textColor = KZSHColor929292;
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
           
        };
    }
    
    
    return sectionModel;
}

//兑换-兑换第一行(酒店-房间数量)
- (ZSHBaseTableViewSectionModel*)storeNumCountSectionWithTitle:(NSString *)title {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    if ([self.paramDic[KFromClassType]integerValue] == ZSHConfirmOrderToBottomBlurPopView) {
        cellModel.height = kRealValue(47);
    } else {
        cellModel.height = kRealValue(60);
    }
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHNumCountCellID];
        cell.textLabel.text = title;
        JSNummberCount *countBtn = [[JSNummberCount alloc]initWithFrame:CGRectZero];
        [cell.contentView addSubview:countBtn];
        [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell).offset(-KLeftMargin);
            make.size.mas_equalTo(CGSizeMake(kRealValue(50), kRealValue(15)));
            make.centerY.mas_equalTo(cell);
        }];
        cell.backgroundColor = KWhiteColor;
        return cell;
    };
    return sectionModel;
}

//兑换-兑换第二行
- (ZSHBaseTableViewSectionModel*)storeExchangeSecondSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(50);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHExchangeSecondCellID forIndexPath:indexPath];
        cell.backgroundColor = KWhiteColor;
        cell.textLabel.text = @"目前积分可兑换2份";
        cell.textLabel.font = kPingFangRegular(10);
        cell.textLabel.textColor = KZSHColor929292;
        return cell;
    };

    return sectionModel;
}

/**确认订单弹窗**/
//酒店确定订单-图片，设备
- (ZSHBaseTableViewSectionModel*)storePayHeadSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(80);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelDetailDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelDetailDeviceCellID forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
        cell.backgroundColor = KWhiteColor;
        if (weakself.deviceDic) {
            cell.showCellType = ZSHPopType;
            cell.shopType = weakself.shopType;
            NSDictionary *paramDic = weakself.deviceDic;
            [cell updateCellWithParamDic:paramDic];
        }
       
        return cell;
    };
    
    return sectionModel;
}

//酒店图片等详情
- (ZSHBaseTableViewSectionModel*)storeHotelDetailSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(20);
    sectionModel.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(20))];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(75);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelPayHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelPayHeadCellID forIndexPath:indexPath];
        cell.showCellType = ZSHPopType;
        cell.shopType = weakself.shopType;
        [cell updateCellWithParamDic:weakself.paramDic];
       
        return cell;
    };
    
    return sectionModel;
}

//酒店其他
- (ZSHBaseTableViewSectionModel*)storeHotelDetailOtherSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *titleArr = @[@"联系人",@"手机号码",@"备注"];
    NSArray *placeHolderArr = @[@"请输入您的姓名",@"18888888888",@"安排视野宽阔的房间"];
    NSArray *widtArr = @[@(kRealValue(100)),@(kRealValue(95)),@(kRealValue(130))];
    for (int i = 0; i<3; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(47);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHNumCountCellID];
            cell.backgroundColor = KWhiteColor;
            cell.textLabel.text = titleArr[i];
            
            UITextField *userinfoTextField = [[UITextField alloc]initWithFrame:CGRectZero];
            userinfoTextField.font = kPingFangLight(14);
            userinfoTextField.textColor = KZSHColor929292;
            userinfoTextField.placeholder = placeHolderArr[i];
            [cell.contentView addSubview:userinfoTextField];
            [userinfoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell).offset(-KLeftMargin);
                make.size.mas_equalTo(CGSizeMake([widtArr[i]integerValue], kRealValue(44)));
                make.centerY.mas_equalTo(cell);
            }];
            
            return cell;
        };
    }
    return sectionModel;
}

//酒店订单确认按钮
- (ZSHBaseTableViewSectionModel*)storeConfirmBtnSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = KBottomNavH;
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        NSDictionary *bottomBtnDic = @{@"title":@"确认订单",@"font":kPingFangMedium(17),@"backgroundColor":KZSHColor0B0B0B};
        UIButton  *confirmOrderBtn = [ZSHBaseUIControl createBtnWithParamDic:bottomBtnDic];
        [confirmOrderBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:confirmOrderBtn];
        [confirmOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell);
            make.width.and.height.mas_equalTo(cell);
            make.bottom.mas_equalTo(cell);
        }];
       
        return cell;
    };
    
    return sectionModel;
}


//入住日历
- (ZSHBaseTableViewSectionModel*)storeCalendarDetailSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(80);
    sectionModel.headerView = self.calendarHeadView;
    
    kWeakSelf(self);
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(280);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHNumCountCellID];
        cell.backgroundColor = KWhiteColor;
        
        STCalendar *calender = [[STCalendar alloc]initWithFrame:CGRectMake(0,0,KScreenWidth,kRealValue(280))];
        calender.tag = 2;
        calender.backgroundColor = KWhiteColor;
        [calender returnDate:^(NSString * _Nullable stringDate) {
            NSString *labelDate  = stringDate;
            RLog(@"现在的日期==%@",labelDate);
            weakself.currentDateLabel.text = labelDate;
        }];
        
        calender.delegate = self;
        [calender setTextSelectedColor:[UIColor blackColor]];
        self.calender = calender;
        [cell.contentView addSubview:self.calender];
        [calender mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell);
        }];
        return cell;
    };
    return sectionModel;
}

//机票个人信息
- (ZSHBaseTableViewSectionModel*)storeTicketUserInfoBtnSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *titleArr =@[@"乘机人",@"身份证",@"手机号码",@"延误险",@"意外险",@"报销凭证"];
    NSArray *placeHolderArr = @[@"姓名保持与有效证件一致",@"请填写证件号码",@"18888888888",@"¥20X0份",@"¥30X0份",@""];
    NSArray *textFieldTypeArr = @[@(ZSHTextFieldViewUser),@(ZSHTextFieldViewID),@(ZSHTextFieldViewPhone),@(ZSHTextFieldViewUser),@(ZSHTextFieldViewUser),@(ZSHTextFieldViewUser)];
    for (int i = 0; i<titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(44);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            cell.backgroundColor = KWhiteColor;
            if (![cell.contentView viewWithTag:2]) {
                NSDictionary *paramDic = @{@"leftTitle":titleArr[indexPath.row],@"placeholder":placeHolderArr[indexPath.row],@"textFieldType":textFieldTypeArr[indexPath.row],KFromClassType:@(FromAirTicketDetailVCToTextFieldCellView)};
                ZSHTextFieldCellView *textFieldCellView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(44)) paramDic:paramDic];
                [cell.contentView addSubview:textFieldCellView];
                [textFieldCellView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(cell.contentView);
                }];
                textFieldCellView.tag = 2;
                if (i==0) {
                    UIButton  *addUserBtn = [[UIButton alloc] initWithFrame:CGRectZero];
                    addUserBtn.frame = CGRectMake(0, 0, kRealValue(17.5), kRealValue(17.5));
                    [addUserBtn setBackgroundImage:[UIImage imageNamed:@"add_user"] forState:UIControlStateNormal];
                    [addUserBtn addTarget:self action:@selector(addUserBtnAction) forControlEvents:UIControlEventTouchUpInside];
                    cell.accessoryView = addUserBtn;
                }
                if (i>=3) {
                    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchview addTarget:self action:@selector(switchBtnAction:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchview;
                }
            }
            
            return cell;
        };
    }
    return sectionModel;
}

// 火车票详情
- (ZSHBaseTableViewSectionModel *)stroreTrainUserInfo {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *titleArr =@[@"乘机人",@"身份证",@"手机号码",@"意外险",@""];
    NSArray *placeHolderArr = @[@"姓名保持与有效证件一致",@"请填写证件号码",@"18888888888",@"¥20X0份",@""];
    NSArray *textFieldTypeArr = @[@(ZSHTextFieldViewUser),@(ZSHTextFieldViewID),@(ZSHTextFieldViewPhone),@(ZSHTextFieldViewUser),@(ZSHTextFieldViewNone)];
    for (int i = 0; i<titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(44);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            cell.backgroundColor = KWhiteColor;
            NSDictionary *paramDic = @{@"leftTitle":titleArr[indexPath.row],@"placeholder":placeHolderArr[indexPath.row],@"textFieldType":textFieldTypeArr[indexPath.row],KFromClassType:@(FromAirTicketDetailVCToTextFieldCellView)};
            
            ZSHTextFieldCellView *textFieldCellView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(44)) paramDic:paramDic];
            [cell.contentView addSubview:textFieldCellView];
            [textFieldCellView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell.contentView);
            }];
            if (i == 0) {
                UIButton  *addUserBtn = [[UIButton alloc] initWithFrame:CGRectZero];
                addUserBtn.frame = CGRectMake(0, 0, kRealValue(17.5), kRealValue(17.5));
                [addUserBtn setBackgroundImage:[UIImage imageNamed:@"add_user"] forState:UIControlStateNormal];
                [addUserBtn addTarget:self action:@selector(addUserBtnAction) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = addUserBtn;
            } else if (i == 3) {
                UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                [switchview addTarget:self action:@selector(switchBtnAction:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = switchview;
            } else if (i == 4) {
                NSArray *titleArr = @[@"最高保险130W万\n￥30", @"最高保80万\n¥20"];
                for (int i = 0; i < titleArr.count; i++) {
                    UIButton *insuranceBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":titleArr[i],@"font":kPingFangRegular(10)}];
                    insuranceBtn.titleLabel.numberOfLines = 0;
                    insuranceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    insuranceBtn.layer.borderWidth = 0.5;
                    insuranceBtn.layer.borderColor = KZSHColor929292.CGColor;
                    insuranceBtn.layer.cornerRadius = 5.0;
                    [cell.contentView addSubview:insuranceBtn];
                    [insuranceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.contentView).offset(kRealValue(5));
                        make.left.mas_equalTo(cell.contentView).offset(kRealValue(KLeftMargin+i*(15+90)));
                        make.size.mas_equalTo(CGSizeMake(kRealValue(90), kRealValue(35)));
                    }];
                }
            }
            return cell;
        };
    }
    return sectionModel;

}

//吃喝玩乐年龄选择
- (ZSHBaseTableViewSectionModel*)storeAgeSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(115);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        weakself.ageView = [[ZSHAgeView alloc]initWithFrame:CGRectZero];
        [cell addSubview:weakself.ageView];
        [weakself.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell);
        }];
        
        return cell;
    };
    
    return sectionModel;
}

//首页-菜单
- (ZSHBaseTableViewSectionModel*)storeMenuListSection {
    NSArray *imageArr = @[@"list_scan",@"list_news",@"list_noti",@"list_unlock"];
    NSArray *titleArr = @[@"扫一扫",@"消息中心",@"系统通知",@"解锁特权"];
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(8);
    sectionModel.headerView = [[UIView alloc]initWithFrame:self.subTab.bounds];
    for (int i = 0; i<[imageArr count]; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(30);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID];
            cell.textLabel.text = titleArr[i];
            cell.textLabel.font = kPingFangLight(14);
            cell.imageView.image = [UIImage imageNamed:imageArr[i]];
            cell.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            RLog(@"点击了");
            if (self.dissmissViewBlock) {
                self.dissmissViewBlock(self,indexPath);
            }
        };
    }
    return sectionModel;
}

//直播-附近-筛选播主
- (ZSHBaseTableViewSectionModel*)storeLiveSearchSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(45);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHSearchLiveFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHSearchLiveFirstCellID];
        cell.btnClickBlock = ^(UIButton *btn) {
            if (btn.tag == 1) {//黑微博
                [weakself pushWeiboVCAction];
            }
        };
        return cell;
    };
    
    cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(45);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHSearchLiveSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHSearchLiveSecondCellID];
        return cell;
    };
    
    cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(217) - kRealValue(50) - 2*kRealValue(45);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHSearchLiveThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHSearchLiveThirdCellID];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
        return cell;
    };
    
    return sectionModel;
}
#pragma mark- FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.currentDateLabel.text = [dateFormatter stringFromDate:date];
    
}

#pragma getter
- (ZSHTopLineView *)topLineView{
    if (!_topLineView) {
        NSDictionary *paramDic = @{@"typeText":self.typeText};
        _topLineView = [[ZSHTopLineView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(50)) paramDic:paramDic];
    }
    return _topLineView;
}

#pragma mark - 创建星期视图
- (UIView *)calendarHeadView{
    if (!_calendarHeadView) {
        _calendarHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(80))];

         NSDictionary *currentDateLabelDic = @{@"text":@"2017年11月",@"font":kPingFangRegular(12),@"textAlignment":@(NSTextAlignmentCenter)};
        UILabel *currentDateLabel = [ZSHBaseUIControl createLabelWithParamDic:currentDateLabelDic];
        currentDateLabel.frame = CGRectMake(0, 0, KScreenWidth, kRealValue(30));
        currentDateLabel.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        [_calendarHeadView addSubview:currentDateLabel];
        self.currentDateLabel = currentDateLabel;
        
        [_calendarHeadView addSubview:self.weekView];
    }
    return _calendarHeadView;
}

- (UIView *)weekView{
    if (!_weekView) {
        _weekView = [[UIView alloc]initWithFrame:CGRectMake(-1, kRealValue(30), KScreenWidth+2, kRealValue(50))];
        NSArray *title = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        for (int i =0 ; i < 7 ; i++) {
            NSDictionary *labelDic = @{@"text":title[i],@"font":kPingFangRegular(15),@"textColor":KZSHColorFD5739,@"textAlignment":@(NSTextAlignmentCenter)};
            UILabel *label = [ZSHBaseUIControl createLabelWithParamDic:labelDic];
            label.frame = CGRectMake(KScreenWidth/7*i+1, 0, KScreenWidth/7, _weekView.bounds.size.height);
            [_weekView addSubview:label];
        }
        _weekView.backgroundColor = [UIColor whiteColor];
    }
    return _weekView;
}

#pragma mark - event response 日历事件相应
- (void)calendarResultWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate
{
    NSString *resultStr = [beginDate stringByAppendingString:endDate];
    RLog(@"选择的日期==%@",resultStr);
    self.currentDateLabel.text = resultStr;
}

- (void)nextMonth:(UIButton *)button
{
    ++self.calender.month;
}

- (void)upMonth:(UIButton *)button
{
    --self.calender.month;
}

- (void)currentMonth:(UIButton *)button
{
    self.calender.year = [NSCalendar currentYear];
    self.calender.month = [NSCalendar currentMonth];
}

#pragma action
- (void)updateViewWithParamDic:(NSDictionary *)paramDic{
    
}

- (void)switchBtnAction:(UISwitch *)switchBtn{
    
}

- (void)pushWeiboVCAction{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect mainFrame = _subTab.frame;
        mainFrame.origin.y = self.frame.size.height;
        _subTab.frame = mainFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self setHidden:YES];
        
        ZSHWeiboViewController *weiboVC = [[ZSHWeiboViewController alloc]initWithParamDic:@{KFromClassType:@(FromSelectToWeiboVC)}];
        [[kAppDelegate getCurrentUIVC].navigationController pushViewController:weiboVC animated:YES];
    }];
}


- (void)addUserBtnAction{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect mainFrame = _subTab.frame;
        mainFrame.origin.y = self.frame.size.height;
        _subTab.frame = mainFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self setHidden:YES];
        
        ZSHTrainPassengerController *passengerVC = [[ZSHTrainPassengerController alloc]init];
        [[kAppDelegate getCurrentUIVC].navigationController pushViewController:passengerVC animated:YES];
    }];
    
   
}

//确认订单
- (void)confirmBtnAction{
    kWeakSelf(self);
    [UIView animateWithDuration:0.5 animations:^{
        CGRect mainFrame = _subTab.frame;
        mainFrame.origin.y = self.frame.size.height;
        _subTab.frame = mainFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self setHidden:YES];
        
        //生成订单
        [weakself requestData];
        
        self.shopType = [self.paramDic[@"shopType"]integerValue]; //弹窗类型
        self.deviceDic = self.paramDic[@"deviceDic"];  //详情页上半部分数据
        self.listDic = self.paramDic[@"listDic"];      //详情页下半部分列表数据
        self.liveInfo = self.paramDic[@"liveInfoStr"]; //酒店居住时间信息
        
        if ( kFromClassTypeValue == ZSHConfirmOrderToBottomBlurPopView) {
            NSDictionary *nextParamDic = @{@"shopType":@(self.shopType), @"deviceDic":weakself.deviceDic,@"listDic":weakself.listDic,@"liveInfoStr":weakself.liveInfo};
            ZSHHotelPayViewController *hotelPayVC = [[ZSHHotelPayViewController alloc]initWithParamDic:nextParamDic];
            [[kAppDelegate getCurrentUIVC].navigationController pushViewController:hotelPayVC animated:YES];
        }

    }];
}

- (void)saveChange{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect mainFrame = _subTab.frame;
        mainFrame.origin.y = self.frame.size.height;
        _subTab.frame = mainFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self setHidden:YES];
        
        NSDictionary *preParamDic;
        if (kFromClassTypeValue == ZSHFromAirplaneCalendarVCToBottomBlurPopView) {
            preParamDic = @{@"trainDate":_currentDateLabel.text};
            
        } else if (kFromClassTypeValue == ZSHFromAirplaneAgeVCToBottomBlurPopView) {
            preParamDic = @{@"ageRange":self.ageView.ageRangeStr, @"trainDate":_currentDateLabel.text};
        }
         //保存年龄
        if (self.confirmOrderBlock) {
            self.confirmOrderBlock(preParamDic);
        }
    }];
    
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect mainFrame = _subTab.frame;
        mainFrame.origin.y = self.frame.size.height;
        _subTab.frame = mainFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self setHidden:YES];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view.tag != 2) {
        kFromClassTypeValue!= ZSHFromHomeMenuVCToBottomBlurPopView?[self dismiss]:self.dissmissViewBlock?self.dissmissViewBlock(self,nil):nil;
    }
}

- (void)requestData{
    _orderLogic = [[ZSHConfirmOrderLogic alloc]init];
    
    ////参数：ORDERUNAME 入住人姓名/ORDERPHONE 入住人手机号码/ORDERREMARK 订单备注/ORDERMONEY 订单价格/ORDERROOMNUM 预定酒店房间数量/ORDERCHECKDATE 入住日期/ORDERLEAVEDATE 离开日期
    ///ORDERDAYS 入住天数 /HOTELDETAIL_ID 预定房间类型id/HONOURUSER_ID 提交订单用户id
    
    NSDictionary *paramDic = @{@"ORDERUNAME":@"彩薇",@"ORDERPHONE":@"18888888888",@"ORDERREMARK":@"大房",@"ORDERMONEY":@(199),@"ORDERROOMNUM":@(1),@"ORDERCHECKDATE":@"20171205",@"ORDERLEAVEDATE":@"20171220",@"ORDERDAYS":@(1),@"HOTELDETAIL_ID":@"经济型",@"HONOURUSER_ID":HONOURUSER_IDValue};
    [_orderLogic requestHotelConfirmOrderWithParamDic:paramDic Success:^(id responseObject) {
        RLog(@"确认订单数据==%@",responseObject);
    } fail:nil];
}

@end
