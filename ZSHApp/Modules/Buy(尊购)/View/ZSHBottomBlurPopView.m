//
//  ZSHBottomBlurPopView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//
#import "ZSHTopLineView.h"
#import "ZSHHotelDetailHeadCell.h"
#import "ZSHHotelDetailDeviceCell.h"
#import "ZSHHotelPayHeadCell.h"
#import "ZSHHotelPayViewController.h"
#import "ZSHTextFieldCellView.h"
#import "JSNummberCount.h"

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

//首页
#import "ZSHHomeSubListCell.h"
#import "ZSHToplineTopView.h"
@interface ZSHBottomBlurPopView ()<FSCalendarDataSource, FSCalendarDelegate>

@property (nonatomic, strong) NSDictionary           *paramDic;
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

//确认订单
@property (nonatomic, assign) ZSHShopType            shopType;
@property (nonatomic, strong) NSDictionary           *deviceDic;
@property (nonatomic, strong) NSDictionary           *listDic;
@property (nonatomic, copy)   NSString               *liveInfo;
@property (nonatomic, strong) ZSHConfirmOrderLogic   *orderLogic;
@property (nonatomic, strong) NSMutableDictionary    *confirmOderDic; //确认订单填写的参数

//底部年龄弹出框
@property (nonatomic, strong) ZSHAgeView            *ageView;
@property (nonatomic, copy)   NSString              *ageRangeStr;

@property (strong, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSString *currentDate;

//头条
@property (nonatomic, strong) ZSHToplineTopView    *toplineTopView;

//直播 - 附近筛选
@property (nonatomic, copy) NSString               *gender;     //性别
@property (nonatomic, copy) NSString               *activeTime; //活跃时间

//键盘处理
@property (nonatomic, assign) BOOL                  isKeyboardEdit;

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
static NSString *ZSHHomeSubListCellID = @"ZSHHomeSubListCell";

//直播 - 附近筛选
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
    _confirmOderDic = [[NSMutableDictionary alloc]init];
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
        
    } else if (kFromClassTypeValue == ZSHFromAirplaneUserInfoVCToBottomBlurPopView) {//机票个人信息
        _subTabHeight = kRealValue(310.5);
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
    } else if (kFromClassTypeValue == ZSHFromAirplaneAgeVCToBottomBlurPopView) {//吃喝玩乐年龄
        _subTabHeight = kRealValue(165);
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
    }  else if (kFromClassTypeValue == ZSHFromHomeMenuVCToBottomBlurPopView) {//首页-菜单栏
        
        self.subTab.frame = CGRectMake(KScreenWidth - kRealValue(15) - kRealValue(120), 0, kRealValue(120),kRealValue(175));
        self.subTab.backgroundColor = KClearColor;
        UIImageView *tbBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_bg"]];
        tbBgImageView.frame = self.subTab.bounds;
        self.subTab.backgroundView = tbBgImageView;
        self.subTab.delegate = self.tableViewModel;
        self.subTab.dataSource = self.tableViewModel;
        [self.subTab registerClass:[ZSHHomeSubListCell class] forCellReuseIdentifier:ZSHHomeSubListCellID];
        self.subTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.subTab setSeparatorColor:KZSHColor3E3E3E];
        [self.subTab setSeparatorInset:UIEdgeInsetsMake(0, kRealValue(12.5), 0, kRealValue(12.5))];
        [self.subTab reloadData];
        return;
        
    } else if (kFromClassTypeValue == ZSHFromPersonInfoVCToBottomBlurPopView) {
        ZSHLivePersonInfoView *personInfoView = [[ZSHLivePersonInfoView alloc] initWithFrame:CGRectMake((KScreenWidth - kRealValue(260))/2, (KScreenHeight - kRealValue(318))/2, kRealValue(260), kRealValue(318)) paramDic:_paramDic[@"userInfo"]];
        personInfoView.userInteractionEnabled = YES;
        [self addSubview:personInfoView];
        
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
        NSArray *titleArr = self.paramDic[@"titleArr"];
        NSDictionary *nextParamDic = @{@"titleArr":titleArr,@"normalImage":@"card_normal",@"selectedImage":@"card_press",@"btnTag":@([self.paramDic[@"btnTag"]integerValue])};
        
        CGFloat listViewH = ceil(titleArr.count/3.0) *kRealValue(30) +  (ceil(titleArr.count/3.0) - 1)*kRealValue(15) + kRealValue(20);
        ZSHCardBtnListView *listView = [[ZSHCardBtnListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, listViewH) paramDic:nextParamDic];
        // [listView selectedByIndex:1];
        listView.tag = 2;
        [self addSubview:listView];
        return;
    } else if (kFromClassTypeValue == ZSHFromTrainCalendarVCToBottomBlurPopView||kFromClassTypeValue == ZSHFromHotelDetailCalendarVCToBottomBlurPopView||kFromClassTypeValue == ZSHFromAirplaneCalendarVCToBottomBlurPopView) {// 火车票
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
    }  else if (kFromClassTypeValue == ZSHFromGoodsVCToBottomBlurPopView) {//商品分类
        self.subTab.frame = CGRectMake(KScreenWidth - kRealValue(7.5) - kRealValue(120), KNavigationBarHeight+45, kRealValue(120),kRealValue(96));
        self.subTab.backgroundColor = KClearColor;
        UIImageView *tbBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_bg"]];
        tbBgImageView.frame = self.subTab.bounds;
        self.subTab.backgroundView = tbBgImageView;
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
        self.subTab.delegate = self.tableViewModel;
        self.subTab.dataSource = self.tableViewModel;
        self.subTab.scrollEnabled = YES;
        [self.subTab reloadData];
        return;
    }  else if (kFromClassTypeValue == ZSHFromFoodVCToBottomBlurPopView) {//美食分类
        self.subTab.frame = CGRectMake(kScreenWidth/[self.paramDic[@"count"]floatValue]*[self.paramDic[@"index"]floatValue]+kRealValue(17), KNavigationBarHeight+35, kRealValue(120),kRealValue(96));
        self.subTab.backgroundColor = KClearColor;
        UIImageView *tbBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_bg"]];
        tbBgImageView.frame = self.subTab.bounds;
        self.subTab.backgroundView = tbBgImageView;
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
        self.subTab.delegate = self.tableViewModel;
        self.subTab.dataSource = self.tableViewModel;
        
        [self.subTab reloadData];
        return;
    } else if (kFromClassTypeValue == ZSHFromFoodVCToBottomBlurPopView) {//头条
        [self addSubview:self.toplineTopView];
        return;
        
    } else if (kFromClassTypeValue == ZSHSubscribeVCToBottomBlurPopView) {//游艇
        self.shopType = ZSHShipType;
        _subTabHeight = kRealValue(295);
        [self.subTab registerClass:[ZSHHotelPayHeadCell class] forCellReuseIdentifier:ZSHHotelPayHeadCellID];
        [self.subTab registerClass:[ZSHHotelDetailDeviceCell class] forCellReuseIdentifier:ZSHHotelDetailDeviceCellID];
        [self.subTab registerClass:[ZSHHotelPayHeadCell class] forCellReuseIdentifier:ZSHHotelPayHeadCellID];
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
    } else if (kFromClassTypeValue == ZSHFromAirplaneUserInfoVCToBottomBlurPopView){//机票个人信息
        
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
    } else if (kFromClassTypeValue == ZSHFromGoodsVCToBottomBlurPopView){// 商品分类
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeGoodsListSection]];
    } else if (kFromClassTypeValue == ZSHFromFoodVCToBottomBlurPopView) { // 美食
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeFoodListSection]];
    } else if (kFromClassTypeValue == ZSHSubscribeVCToBottomBlurPopView) { //游艇
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storePayHeadSection]];           //名字
        [self.tableViewModel.sectionModelArray addObject:[self storeHotelDetailSection]];       //图片详情
        [self.tableViewModel.sectionModelArray addObject:[self storeHotelDetailOtherSection]];  //联系人，手机号码，备注等
        [self.tableViewModel.sectionModelArray addObject:[self storeConfirmBtnSection]];        //确认按钮
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
        [_confirmOderDic setValue:@(1) forKey:@"ORDERROOMNUM"];
        countBtn.NumberChangeBlock = ^(NSInteger count) {
            [_confirmOderDic setValue:@(count) forKey:@"ORDERROOMNUM"];
        };
        [cell.contentView addSubview:countBtn];
        [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell).offset(-KLeftMargin);
            make.size.mas_equalTo(CGSizeMake(kRealValue(60), kRealValue(20)));
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
//酒店确定订单： 酒店名称，设备类型
- (ZSHBaseTableViewSectionModel*)storePayHeadSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    
    __block NSDictionary *deviceParamDic = nil;
    if (kFromClassTypeValue == ZSHSubscribeVCToBottomBlurPopView) {//游艇-无设备按钮
        cellModel.height = kRealValue(15);
        deviceParamDic = self.paramDic[@"requestDic"];
    } else {
        cellModel.height = kRealValue(80);
        deviceParamDic = self.deviceDic;
    }
    
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelDetailDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelDetailDeviceCellID forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
        cell.backgroundColor = KWhiteColor;
        cell.showCellType = ZSHPopType;
        cell.shopType = weakself.shopType;
        [cell updateCellWithParamDic:deviceParamDic];
        
        
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

//酒店其他：联系人，手机号码，备注
- (ZSHBaseTableViewSectionModel*)storeHotelDetailOtherSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *titleArr = @[@"联系人",@"手机号码",@"备注"];
    NSArray *placeHolderArr = @[@"请输入您的姓名",@"18888888888",@"安排视野宽阔的房间"];
    NSArray *widtArr = @[@(kRealValue(100)),@(kRealValue(100)),@(kRealValue(130))];
    for (int i = 0; i<3; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(47);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHNumCountCellID];
            cell.backgroundColor = KWhiteColor;
            cell.textLabel.text = titleArr[i];
            
            UITextField *userinfoTextField = [[UITextField alloc]initWithFrame:CGRectZero];
            userinfoTextField.tag = i+10;
            [userinfoTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
            userinfoTextField.font = kPingFangLight(14);
            userinfoTextField.textColor = KZSHColor929292;
            userinfoTextField.placeholder = placeHolderArr[i];
            [cell.contentView addSubview:userinfoTextField];
            [userinfoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell).offset(-KLeftMargin);
                make.size.mas_equalTo(CGSizeMake([widtArr[i]integerValue], kRealValue(44)));
                make.centerY.mas_equalTo(cell);
            }];
            if(indexPath.row == 1){
                userinfoTextField.keyboardType = UIKeyboardTypePhonePad;
            }
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
        UIButton  *confirmOrderBtn = [ZSHBaseUIControl  createBtnWithParamDic:bottomBtnDic target:self action:@selector(confirmBtnAction)];
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
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(280);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHNumCountCellID];
        cell.backgroundColor = KWhiteColor;
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0,0,KScreenWidth,kRealValue(280))];
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
        [cell.contentView addSubview:calendar];
        self.calendar = calendar;
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
                    UIButton *insuranceBtn = [ZSHBaseUIControl  createBtnWithParamDic:@{@"title":titleArr[i],@"font":kPingFangRegular(10)} target:self action:nil];
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


- (ZSHBaseTableViewSectionModel*)storeFoodListSection {
    //    NSArray *imageArr = @[@"list_scan",@"list_news",@"list_noti",@"list_unlock"];
    NSArray *titleArr = self.paramDic[@"shopSortArr"];
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(8);
    sectionModel.headerView = [[UIView alloc]initWithFrame:self.subTab.bounds];
    for (int i = 0; i<[titleArr count]; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(30);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHeadCellID];
            cell.textLabel.text = titleArr[i];
            cell.textLabel.font = kPingFangLight(14);
            //            cell.imageView.image = [UIImage imageNamed:imageArr[i]];
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

//尊购商品分类
- (ZSHBaseTableViewSectionModel*)storeGoodsListSection {
    //    NSArray *imageArr = @[@"list_scan",@"list_news",@"list_noti",@"list_unlock"];
    NSMutableArray *titleArr = [NSMutableArray array];
    NSArray *filters = self.paramDic[@"filters"];
    for (NSDictionary *dic in filters) {
        [titleArr addObject:dic[@"BRANDNAME"]];
    }
    //    NSArray *titleArr = @[@"全部",@"名品",@"名物"];
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(8);
    sectionModel.headerView = [[UIView alloc]initWithFrame:self.subTab.bounds];
    for (int i = 0; i<[titleArr count]; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(30);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHeadCellID];
            cell.textLabel.text = titleArr[i];
            cell.textLabel.font = kPingFangLight(14);
            //            cell.imageView.image = [UIImage imageNamed:imageArr[i]];
            cell.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
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

//首页-菜单
- (ZSHBaseTableViewSectionModel*)storeMenuListSection {
    NSArray *paramArr = @[
                          @{@"imageName":@"list_scan",@"titleText":@"扫一扫"},
                          @{@"imageName":@"list_news",@"titleText":@"消息中心"},
                          @{@"imageName":@"list_noti",@"titleText":@"系统通知"},
                          @{@"imageName":@"list_unlock",@"titleText":@"解锁特权"}];
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(8);
    sectionModel.headerView = [[UIView alloc]initWithFrame:self.subTab.bounds];
    for (int i = 0; i<[paramArr count]; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(41.5);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHHomeSubListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHomeSubListCellID forIndexPath:indexPath];
            [cell updateCellWithParamDic:paramArr[indexPath.row]];
            if (indexPath.row == paramArr.count - 1) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
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
            switch (btn.tag) {
                case 1:{//黑微博
                    [weakself pushWeiboVCAction];
                    break;
                }
                    
                    
                default:
                    break;
            }
            
        };
        return cell;
    };
    
    cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(45);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHSearchLiveSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHSearchLiveSecondCellID];
        _gender = @"全部";
        cell.btnClickBlock = ^(UIButton *btn) {
            _gender = btn.titleLabel.text;
        };
        return cell;
    };
    
    cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(217) - kRealValue(50) - 2*kRealValue(45);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHSearchLiveThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHSearchLiveThirdCellID];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
        _activeTime = @"0";
        cell.btnClickBlock = ^(NSString *activeTime) {
            _activeTime = activeTime;
        };
        return cell;
    };
    
    return sectionModel;
}

#pragma mark- FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.currentDate = [dateFormatter stringFromDate:date];
    [[NSNotificationCenter defaultCenter]postNotificationName:KCalendarDateChanged object:@{@"dateStr":self.currentDate,@"btnTag":self.paramDic[@"btnTag"]}];
    
}

#pragma getter
- (ZSHTopLineView *)topLineView{
    if (!_topLineView) {
        NSDictionary *paramDic = @{@"typeText":self.typeText};
        _topLineView = [[ZSHTopLineView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(50)) paramDic:paramDic];
    }
    return _topLineView;
}

//头条顶部发布view
- (ZSHToplineTopView *)toplineTopView{
    if (!_toplineTopView) {
        _toplineTopView = [[ZSHToplineTopView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, kScreenWidth, kRealValue(50))];
    }
    return _toplineTopView;
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
    NSMutableDictionary *nextParamDic = [[NSMutableDictionary alloc]init];
    if ( kFromClassTypeValue == ZSHConfirmOrderToBottomBlurPopView) {
        self.shopType = [self.paramDic[@"shopType"]integerValue]; //弹窗类型
        self.deviceDic = self.paramDic[@"deviceDic"];  //详情页上半部分数据
        self.listDic = self.paramDic[@"listDic"];      //详情页下半部分列表数据
        self.liveInfo = self.paramDic[@"liveInfoStr"]; //酒店居住时间信息
        [nextParamDic setDictionary: @{@"shopType":@(self.shopType), @"deviceDic":weakself.deviceDic,@"listDic":weakself.listDic,@"liveInfoStr":weakself.liveInfo}];
        [nextParamDic setObject:@(kFromClassTypeValue) forKey:KFromClassType];
        
    } else if(kFromClassTypeValue == ZSHSubscribeVCToBottomBlurPopView){//高级特权
        self.liveInfo = self.paramDic[@"liveInfoStr"];
        [nextParamDic setDictionary:@{@"shopType":@(self.shopType),@"requestDic":self.paramDic[@"requestDic"],@"liveInfoStr":weakself.liveInfo}];
        [nextParamDic setObject:@(kFromClassTypeValue) forKey:KFromClassType];
    }
    //生成订单
    [weakself requestDataComplete:^(NSDictionary *dic){
        [UIView animateWithDuration:0.5 animations:^{
            CGRect mainFrame = _subTab.frame;
            mainFrame.origin.y = self.frame.size.height;
            _subTab.frame = mainFrame;
        } completion:^(BOOL finished){
            [weakself removeFromSuperview];
            [weakself setHidden:YES];
            
            [nextParamDic setValue:dic forKey:@"confirmOderDic"];
            ZSHHotelPayViewController *hotelPayVC = [[ZSHHotelPayViewController alloc]initWithParamDic:nextParamDic];
            [[kAppDelegate getCurrentUIVC].navigationController pushViewController:hotelPayVC animated:YES];
        }];
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
        switch (kFromClassTypeValue) {
            case ZSHFromAirplaneCalendarVCToBottomBlurPopView:{
                preParamDic = @{@"trainDate":_currentDateLabel.text};
                break;
            }
            case ZSHFromAirplaneAgeVCToBottomBlurPopView:{
                preParamDic = @{@"ageRange":self.ageView.ageRangeStr};
                break;
            }
            case ZSHFromTrainCalendarVCToBottomBlurPopView:{
                preParamDic = @{@"trainDate":_currentDate};
                break;
            }
            case ZSHFromLiveNearSearchVCToBottomBlurPopView:{
                preParamDic = @{@"SEX":_gender,@"LIVE_START":_activeTime};
                break;
            }
            default:
                break;
        }
        
        //确定保存
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
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view.tag != 2) {
        if (kFromClassTypeValue == ZSHFromHomeMenuVCToBottomBlurPopView || kFromClassTypeValue == ZSHFromGoodsVCToBottomBlurPopView || kFromClassTypeValue == ZSHFromFoodVCToBottomBlurPopView) {
            self.dissmissViewBlock?self.dissmissViewBlock(self,nil):nil;
        } else {
            [self dismiss];
        }
        
    }
}

//美食，酒店,酒吧，KTV等订单生成
- (void)requestDataComplete:(void(^)(NSDictionary *dic))complete{
    if (!_confirmOderDic[@"ORDERUNAME"]||!_confirmOderDic[@"ORDERPHONE"]||!_confirmOderDic[@"ORDERREMARK"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息填写不全" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![ZSHBaseFunction validateMobile:_confirmOderDic[@"ORDERPHONE"]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    _orderLogic = [[ZSHConfirmOrderLogic alloc]init];
    NSString *beginDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"beginDate"];
    NSString *endDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"endDate"];
    NSString *days = [[NSUserDefaults standardUserDefaults]objectForKey:@"days"];
    NSString *storePrice = nil;
    NSString *storeId = nil;
    switch (kFromClassTypeValue) {
        case ZSHConfirmOrderToBottomBlurPopView:{//美食，酒店，KTV,酒吧订单生成
            switch (self.shopType) {
                case ZSHFoodShopType:{
                    storePrice = self.paramDic[@"listDic"][@"FOODDETPRICE"];
                    storeId = self.paramDic[@"listDic"][@"SORTFOOD_ID"];
                    break;
                }
                case ZSHHotelShopType:{
                    storePrice = self.paramDic[@"listDic"][@"HOTELDETPRICE"];
                    storeId = self.paramDic[@"listDic"][@"SORTHOTEL_ID"];
                    [_confirmOderDic setValue:days forKey:@"ORDERDAYS"];
                    break;
                }
                case ZSHKTVShopType:{
                    storePrice = self.paramDic[@"listDic"][@"KTVDETPRICE"];
                    storeId = self.paramDic[@"listDic"][@"KTVDETAIL_ID"];
                    beginDate = self.paramDic[@"listDic"][@"KTVDETBEGIN"];
                    endDate = self.paramDic[@"listDic"][@"KTVDETEND"];
                    break;
                }
                case ZSHBarShopType:{
                    storePrice = self.paramDic[@"listDic"][@"BARDETPRICE"];
                    storeId = self.paramDic[@"listDic"][@"SORTBAR_ID"];
                    break;
                }
                    
                default:
                    break;
            }
            
            [_confirmOderDic setValue:storePrice forKey:@"ORDERMONEY"];
            [_confirmOderDic setValue:storeId forKey:@"DETAIL_ID"];
            [_confirmOderDic setValue:beginDate forKey:@"ORDERROOMBEGIN"];
            [_confirmOderDic setValue:endDate forKey:@"ORDERROOMEND"];
            [_confirmOderDic setValue:@(self.shopType) forKey:@"ORDERTYPE"];
            [_confirmOderDic setValue:HONOURUSER_IDValue forKey:@"HONOURUSER_ID"];
            complete(_confirmOderDic);
            break;
        }
        case ZSHSubscribeVCToBottomBlurPopView:{//高端特权生成订单
            [_confirmOderDic setValue:self.paramDic[@"requestDic"][@"YACHTPRICE"] forKey:@"ORDERMONEY"];
            [_confirmOderDic setValue:beginDate forKey:@"ORDERROOMBEGIN"];
            [_confirmOderDic setValue:endDate forKey:@"ORDERROOMEND"];
            [_confirmOderDic setValue:days forKey:@"ORDERDAYS"];
            [_confirmOderDic setValue:self.paramDic[@"requestDic"][@"YACHTSHOP_ID"] forKey:@"SHOP_ID"];
            [_confirmOderDic setValue:self.paramDic[@"requestDic"][@"HONOURUSER_ID"] forKey:@"HONOURUSER_ID"];
            [_confirmOderDic setValue:@(self.shopType) forKey:@"ORDERTYPE"];
            complete(_confirmOderDic);
            break;
        }
        default:
            break;
    }
    
}



//生成订单输入的参数
- (void)textFieldEditChanged:(UITextField *)textField{
    
    NSLog(@"textfield text %@",textField.text);
    switch (textField.tag) {
        case 10:{
            [_confirmOderDic setValue:textField.text forKey:@"ORDERUNAME"];
            break;
        }
        case 11:{
            [_confirmOderDic setValue:textField.text forKey:@"ORDERPHONE"];
            break;
        }
        case 12:{
            [_confirmOderDic setValue:textField.text forKey:@"ORDERREMARK"];
            break;
        }
            
        default:
            break;
    }
    
    RLog(@"_confirmOderDic == %@",_confirmOderDic);
    
}



@end
