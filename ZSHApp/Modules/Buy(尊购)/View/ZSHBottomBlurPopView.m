//
//  ZSHBottomBlurPopView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBottomBlurPopView.h"
#import "ZSHTopLineView.h"
#import "JSNummberCount.h"
#import "ZSHHotelDetailHeadCell.h"
#import "ZSHHotelDetailDeviceCell.h"
#import "ZSHHotelPayHeadCell.h"
#import "ZSHHotelDetailModel.h"
#import "ZSHKTVModel.h"
#import "ZSHHotelPayViewController.h"
#import "ZSHTextFieldCellView.h"
//日历
#import "STCalendar.h"
#import "NSCalendar+ST.h"


@interface ZSHBottomBlurPopView ()<STCalendarDelegate>

@property (nonatomic, strong) NSDictionary           *paramDic;
@property (nonatomic, strong) ZSHBaseModel           *model;
@property (nonatomic, strong) ZSHHotelDetailModel    *hotelModel;
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

//底部年龄弹出框
@property (nonatomic, strong) UISlider        *ageSlider;
@property (nonatomic, strong) UIView          *ageView;
@property (nonatomic, strong) UILabel         *valueLabel;

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
    if (kFromVCType == ZSHFromHotelVCToBottomBlurPopView) {
        self.titleArr = @[@"距离",@"推荐",@"价格从低到高"];
        self.typeText = @"排序";
    } else if (kFromVCType == ZSHFromExchangeVCToBottomBlurPopView){
        self.typeText = @"请选择兑换数量";
    } else if (kFromVCType == ZSHFromHotelDetailCalendarVCToBottomBlurPopView){
        self.typeText = @"请选择入住离店时间";
    } else if (kFromVCType == ZSHFromHotelDetailConfirmOrderVCToBottomBlurPopView){
        self.model = (ZSHHotelDetailModel *)_paramDic[@"model"];
    } else if (kFromVCType == ZSHFromKTVConfirmOrderVCToBottomBlurPopView){
        self.model = (ZSHKTVModel *)_paramDic[@"model"];
    } else if (kFromVCType == ZSHFromAirplaneCalendarVCToBottomBlurPopView){//机票日期选择
        self.typeText = @"请选择出发时间";
    } else if (kFromVCType == ZSHFromAirplaneSeatTypeVCToBottomBlurPopView){//机票坐席
        self.titleArr = @[@"不限",@"经济仓",@"头等／商务舱"];
        self.typeText = @"席别选择";
    } else if (kFromVCType == ZSHFromAirplaneAgeVCToBottomBlurPopView){//年龄
        self.typeText = @"年龄选择";
    }
    
    self.tableViewModel = [[ZSHBaseTableViewModel alloc] init];
    [self initViewModel];
}

- (void)createUI{
    self.backgroundColor = KClearColor;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlurViewAction:)]];
    
    self.subTab = [ZSHBaseUIControl createTableView];
    self.subTab.scrollEnabled = NO;
    self.subTab.tag = 2;
    [self addSubview: self.subTab];
    if (kFromVCType == ZSHFromHotelVCToBottomBlurPopView||kFromVCType == ZSHFromAirplaneSeatTypeVCToBottomBlurPopView){//酒店排序（机票坐席）
        _subTabHeight = kRealValue(200);
        
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHotelListCellID];
    } else if (kFromVCType == ZSHFromExchangeVCToBottomBlurPopView) {//积分兑换
        _subTabHeight =  kRealValue(170);
        
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHNumCountCellID];
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHExchangeSecondCellID];
    } else if (kFromVCType == ZSHFromHotelDetailConfirmOrderVCToBottomBlurPopView || kFromVCType == ZSHFromKTVConfirmOrderVCToBottomBlurPopView) {//酒店(KTV)确认订单
        _subTabHeight = kRealValue(410);
        
        self.subTab.backgroundColor = KWhiteColor;
        [self.subTab registerClass:[ZSHHotelDetailDeviceCell class] forCellReuseIdentifier:ZSHHotelDetailDeviceCellID];
        [self.subTab registerClass:[ZSHHotelPayHeadCell class] forCellReuseIdentifier:ZSHHotelPayHeadCellID];
    } else if (kFromVCType == ZSHFromHotelDetailCalendarVCToBottomBlurPopView||kFromVCType == ZSHFromAirplaneCalendarVCToBottomBlurPopView) {//酒店入住(机票预订)日历
        _subTabHeight = kRealValue(360);
        
        self.subTab.backgroundColor = KWhiteColor;
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
        [self.subTab registerClass:[ZSHHotelPayHeadCell class] forCellReuseIdentifier:ZSHHotelPayHeadCellID];
    } else if (kFromVCType == ZSHFromAirplaneUserInfoVCToBottomBlurPopView) {//机票个人信息
        _subTabHeight = kRealValue(165);
        
        self.subTab.backgroundColor = KWhiteColor;
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
    }  else if (kFromVCType == ZSHFromAirplaneAgeVCToBottomBlurPopView) {//吃喝玩乐年龄
        _subTabHeight = kRealValue(165);
        
        self.subTab.backgroundColor = KWhiteColor;
        [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadCellID];
    }
    
    self.subTab.delegate = self.tableViewModel;
    self.subTab.dataSource = self.tableViewModel;
    self.subTab.frame = CGRectMake(0, KScreenHeight, KScreenWidth,_subTabHeight);
    self.subTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.subTab setSeparatorColor:KZSHColorE9E9E9];
    [self.subTab setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [ self.subTab reloadData];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect mainFrame =  self.subTab.frame;
        mainFrame.origin.y = self.frame.size.height - mainFrame.size.height;
        self.subTab.frame = mainFrame;
    }];
}

- (void)initViewModel {
    if ([self.paramDic[@"fromClassType"]integerValue] == ZSHFromHotelVCToBottomBlurPopView|| [self.paramDic[@"fromClassType"]integerValue] == ZSHFromAirplaneSeatTypeVCToBottomBlurPopView) {//酒店排序（机票坐席）
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    } else if ([self.paramDic[@"fromClassType"]integerValue] == ZSHFromExchangeVCToBottomBlurPopView) {//积分兑换
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeNumCountSectionWithTitle:@"购买数量"]];
        [self.tableViewModel.sectionModelArray addObject:[self storeExchangeSecondSection]];
    } else if (kFromVCType == ZSHFromHotelDetailConfirmOrderVCToBottomBlurPopView){//酒店确认订单
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storePayHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeHotelDetailSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeNumCountSectionWithTitle:@"房间数量"]];
        [self.tableViewModel.sectionModelArray addObject:[self storeHotelDetailOtherSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeConfirmBtnSection]];
    } else if (kFromVCType == ZSHFromHotelDetailCalendarVCToBottomBlurPopView||kFromVCType == ZSHFromAirplaneCalendarVCToBottomBlurPopView){//酒店入住日历(机票选择日历)
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeCalendarDetailSection]];
    }  else if (kFromVCType == ZSHFromAirplaneUserInfoVCToBottomBlurPopView){//机票个人信息
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeTicketUserInfoBtnSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeConfirmBtnSection]];
    } else if (kFromVCType == ZSHFromAirplaneAgeVCToBottomBlurPopView){//年龄选择
        
        [self.tableViewModel.sectionModelArray removeAllObjects];
        [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
        [self.tableViewModel.sectionModelArray addObject:[self storeAgeSection]];
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
            if (!tag) {
                [weakself dismiss];
            } else{
                [weakself saveChange];
            }
        };
        return cell;
    };
    
    return sectionModel;
}

//酒店弹窗
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
    }
    return sectionModel;
}

//兑换-兑换第一行(酒店-房间数量)
- (ZSHBaseTableViewSectionModel*)storeNumCountSectionWithTitle:(NSString *)title {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    if ([self.paramDic[@"fromClassType"]integerValue] == ZSHFromHotelDetailConfirmOrderVCToBottomBlurPopView) {
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

//酒店确定订单-图片，设备
- (ZSHBaseTableViewSectionModel*)storePayHeadSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(80);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelDetailDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelDetailDeviceCellID forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
        cell.backgroundColor = KWhiteColor;
        cell.fromClassType = ZSHFromHotelPayVCToHotelDetailVC;
        [cell updateCellWithModel:self.model];
        return cell;
    };
    
    return sectionModel;
}

//酒店详情
- (ZSHBaseTableViewSectionModel*)storeHotelDetailSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(20);
    sectionModel.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(20))];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(75);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelPayHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelPayHeadCellID forIndexPath:indexPath];
        cell.fromClassType = ZSHFromHotelDetailBottomVCToHotelPayVC;
        return cell;
    };
    
    return sectionModel;
}

//酒店其他
- (ZSHBaseTableViewSectionModel*)storeHotelDetailOtherSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *titleArr = @[@"入住人",@"手机号码",@"备注"];
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
            make.center.mas_equalTo(cell);
            make.width.and.height.mas_equalTo(cell);
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
            _currentDateLabel.text = labelDate;
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
            NSDictionary *paramDic = @{@"leftTitle":titleArr[indexPath.row],@"placeholder":placeHolderArr[indexPath.row],@"textFieldType":textFieldTypeArr[indexPath.row],@"fromClassType":@(FromAirTicketDetailVCToTextFieldCellView)};
            
            ZSHTextFieldCellView *textFieldCellView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(44)) paramDic:paramDic];
            [cell.contentView addSubview:textFieldCellView];
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
            return cell;
        };
    }
    return sectionModel;
}

//吃喝玩乐年龄选择
- (ZSHBaseTableViewSectionModel*)storeAgeSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(115);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        [cell addSubview:self.ageView];
        [self.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self.subTab);
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(kRealValue(165));
            make.width.mas_equalTo(KScreenWidth);
            make.left.mas_equalTo(self.subTab);
        }];
        
        return cell;
    };
    
    return sectionModel;
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

- (UIView *)ageView{
    if (!_ageView) {
        _ageView = [[UIView alloc]initWithFrame:CGRectZero];
        [_ageView addSubview:self.ageSlider];
        [self.ageSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_ageView);
            make.centerX.mas_equalTo(_ageView);
            make.width.mas_equalTo(kRealValue(220));
            make.height.mas_equalTo(kRealValue(20));
        }];
        
        // 当前值label
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 100) / 2, self.ageSlider.frame.origin.y + 30, 100, 20)];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        self.valueLabel.text = [NSString stringWithFormat:@"%.1f岁", self.ageSlider.value];
        [_ageView addSubview:self.valueLabel];
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.ageSlider);
            make.bottom.mas_equalTo(self.ageSlider.mas_top).offset(-kRealValue(5));
            make.width.mas_equalTo(kRealValue(30));
            make.height.mas_equalTo(kRealValue(15));
        }];
        
        // 最小值label
        UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.ageSlider.frame.origin.x - 35, self.ageSlider.frame.origin.y, 30, 20)];
        minLabel.textAlignment = NSTextAlignmentRight;
        minLabel.text = [NSString stringWithFormat:@"%.1f岁", self.ageSlider.minimumValue];
        [_ageView addSubview:minLabel];
        [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.ageSlider).offset(-kRealValue(5));
            make.width.mas_equalTo(kRealValue(30));
            make.height.mas_equalTo(kRealValue(15));
            make.top.mas_equalTo(self.ageSlider.mas_bottom).offset(kRealValue(3));
        }];
        
        // 最大值label
        UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.ageSlider.frame.origin.x + self.ageSlider.frame.size.width + 5, self.ageSlider.frame.origin.y, 30, 20)];
        maxLabel.textAlignment = NSTextAlignmentLeft;
        maxLabel.text = [NSString stringWithFormat:@"%.1f岁", self.ageSlider.maximumValue];
        [_ageView addSubview:maxLabel];
        [maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.ageSlider).offset(kRealValue(5));
            make.width.mas_equalTo(kRealValue(30));
            make.height.mas_equalTo(kRealValue(15));
            make.top.mas_equalTo(self.ageSlider.mas_bottom).offset(kRealValue(3));
        }];
    }
    return _ageView;
}

- (UISlider *)ageSlider{
    if (!_ageSlider) {
        _ageSlider = [[UISlider alloc]initWithFrame:CGRectZero];
        _ageSlider.minimumValue = 18;// 设置最小值
        _ageSlider.maximumValue = 50;// 设置最大值
        _ageSlider.minimumValueImage = [UIImage imageNamed:@"order_point"];
        _ageSlider.maximumValueImage = [UIImage imageNamed:@"age_icon"];
        [_ageSlider setThumbImage:[UIImage imageNamed:@"order_point"] forState:UIControlStateNormal];
        _ageSlider.continuous = YES;
        [_ageSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _ageSlider;
}

#pragma mark - event response 日历事件相应

- (void)calendarResultWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate
{
    NSString *resultStr = [beginDate stringByAppendingString:endDate];
    RLog(@"选择的日期==%@",resultStr);
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

- (void)tapBlurViewAction:(UIGestureRecognizer *)tap{
    if (tap.view.tag == 2) {
        return;
    } else {
        [self dismiss];
    }
}

- (void)switchBtnAction:(UISwitch *)switchBtn{
    
}

- (void)addUserBtnAction{
    
}

//确认订单
- (void)confirmBtnAction{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect mainFrame = _subTab.frame;
        mainFrame.origin.y = self.frame.size.height;
        _subTab.frame = mainFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self setHidden:YES];
        
        if ( kFromVCType == ZSHFromHotelDetailConfirmOrderVCToBottomBlurPopView) {
            NSDictionary *nextParamDic = @{@"model":self.model};
            ZSHHotelPayViewController *hotelPayVC = [[ZSHHotelPayViewController alloc]initWithParamDic:nextParamDic];
            [[kAppDelegate getCurrentUIVC].navigationController pushViewController:hotelPayVC animated:YES];
        }
    }];
}

- (void)saveChange{
    
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

//年龄滑动块
-(void)sliderValueChanged:(id)sender{
    UISlider *ageSlider = (UISlider *)sender;
    if(ageSlider == _ageSlider){
        CGFloat floatvalue = ageSlider.value;
        RLog(@"滑动值===%f",floatvalue);
    }
    self.valueLabel.text = [NSString stringWithFormat:@"%.1f岁", ageSlider.value];
}
@end
