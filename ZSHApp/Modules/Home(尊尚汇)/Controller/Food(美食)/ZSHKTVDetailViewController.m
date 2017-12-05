//
//  ZSHKTVDetailViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHKTVDetailViewController.h"
#import "ZSHKTVModel.h"
#import "ZSHBottomBlurPopView.h"
#import "ZSHKTVLogic.h"
#import "ZSHHotelDetailHeadCell.h"
#import "ZSHNoticeViewCell.h"
#import "ZSHKTVListCell.h"
#import "ZSHHotelDetailDeviceCell.h"
#import "ZSHHotelCalendarCell.h"
#import "ZSHHotelListCell.h"
#import "ZSHHotelPayViewController.h"
#import "ZSHShopCommentViewController.h"
#import "ZSHHotelCell.h"

@interface ZSHKTVDetailViewController ()

@property (nonatomic, copy)   NSString                  *shopId;
@property (nonatomic, strong) ZSHKTVLogic               *KTVLogic;
@property (nonatomic, strong) ZSHKTVDetailModel         *KTVDetailModel;
@property (nonatomic, strong) NSDictionary              *KTVDetailParamDic;
@property (nonatomic, strong) ZSHBottomBlurPopView      *bottomBlurPopView;

@property (nonatomic, strong) NSArray                    *KTVDetailSetDicArr;
@property (nonatomic, strong) NSArray                    *KTVDetailListArr;

@end

static NSString *ZSHHotelDetailHeadCellID = @"ZSHHotelDetailHeadCell";
static NSString *ZSHHotelDetailDeviceCellID = @"ZSHHotelDetailDeviceCell";
static NSString *ZSHBookCellID = @"ZSHBookCell";
static NSString *ZSHBaseSubCellID = @"ZSHBaseSubCell";
static NSString *ZSHKTVCalendarCellID = @"ZSHNoticeViewCell";
static NSString *ZSHKTVListCellID = @"ZSHKTVListCell";
static NSString *ZSHHotelCellID = @"ZSHHotelCell";

@implementation ZSHKTVDetailViewController

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
    _KTVLogic = [[ZSHKTVLogic alloc]init];
    NSDictionary *paramDic = @{@"SORTKTV_ID":self.shopId};
    [_KTVLogic loadKTVDetailDataWithParamDic:paramDic];
    _KTVLogic.requestDataCompleted = ^(NSDictionary *paramDic){
        
        weakself.KTVDetailModel = paramDic[@"KTVDetailModel"];
        weakself.KTVDetailParamDic = paramDic[@"KTVDetailParamDic"];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        [weakself initViewModel];
    };
    
    //KTV套餐
    [_KTVLogic loadKTVDetailSetDataWithParamDic:paramDic success:^(id responseObject) {
        _KTVDetailSetDicArr = responseObject;
        weakself.tableViewModel.sectionModelArray[3] = [weakself storKTVSetSection];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:3];
        [weakself updateSectionDatWithSet:indexSet];
    } fail:nil];
    
    [weakself loadDetailListData];
}

- (void)loadDetailListData{
    kWeakSelf(self);
    //更多商家（换一批）
    NSDictionary *detailListParamDic = @{@"HONOURUSER_ID":HONOURUSER_IDValue};
    [_KTVLogic loadKTVDetailListDataWithParamDic:detailListParamDic success:^(id responseObject) {
        _KTVDetailListArr = responseObject;
        weakself.tableViewModel.sectionModelArray[4] = [weakself storKTVMorShopSection];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:4];
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
    
    //KTV
    [self.tableView registerClass:[ZSHHotelDetailHeadCell class] forCellReuseIdentifier:ZSHHotelDetailHeadCellID];
    [self.tableView registerClass:[ZSHHotelDetailDeviceCell class]
           forCellReuseIdentifier:ZSHHotelDetailDeviceCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseSubCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBookCellID];
    [self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:ZSHKTVCalendarCellID];
    [self.tableView registerClass:[ZSHKTVListCell class] forCellReuseIdentifier:ZSHKTVListCellID];
     [self.tableView registerClass:[ZSHHotelCell class] forCellReuseIdentifier:ZSHHotelCellID];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeSubSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storKTVCalendarSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storKTVSetSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storKTVMorShopSection]];
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
        cell.shopType = ZSHKTVShopType;
        if (_KTVDetailParamDic) {
            [cell updateCellWithParamDic:_KTVDetailParamDic];
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
        cell.shopType = ZSHKTVShopType;
        if (_KTVDetailParamDic) {
            [cell updateCellWithParamDic:_KTVDetailParamDic];
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
    if (_KTVDetailModel) {
        titleArr = @[_KTVDetailModel.KTVADDRESS,_KTVDetailModel.KTVPHONE];
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
        NSInteger  commentCount = 99;
        CGFloat    scoreCount = 4.5;
        if (_KTVDetailModel) {
            commentCount = _KTVDetailModel.KTVEVACOUNT;
            scoreCount = _KTVDetailModel.KTVEVALUATE;
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
        NSDictionary *nextParamDic = @{KFromClassType:@(ZSHKTVShopType), @"shopId":self.shopId};
        ZSHShopCommentViewController *shopCommentVC = [[ZSHShopCommentViewController alloc]initWithParamDic:nextParamDic];
        [weakself.navigationController pushViewController:shopCommentVC animated:YES];
    };
    
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

//KTV套餐列表
- (ZSHBaseTableViewSectionModel*)storKTVSetSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(40);
    NSDictionary *headTitleParamDic = @{@"text":@"套餐",@"font":kPingFangMedium(15),@"textAlignment":@(NSTextAlignmentLeft)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    
    for (int i = 0; i<_KTVDetailSetDicArr.count; i++){
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(75);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHKTVListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHKTVListCellID forIndexPath:indexPath];
            NSDictionary *nextParamDic = _KTVDetailSetDicArr[indexPath.row];
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            NSDictionary *paramDic = _KTVDetailListArr[indexPath.row];
            NSDictionary *nextParamDic = @{KFromClassType:@(ZSHConfirmOrderToBottomBlurPopView),@"shopType":@(ZSHKTVShopType), @"deviceDic":weakself.KTVDetailParamDic,@"listDic":paramDic,@"liveInfoStr":@""};
            weakself.bottomBlurPopView = [weakself createBottomBlurPopViewWithParamDic:nextParamDic];
            [kAppDelegate.window addSubview:weakself.bottomBlurPopView];
        };
    }
    return sectionModel;
}

//KTV更多商家
- (ZSHBaseTableViewSectionModel*)storKTVMorShopSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(40);
    NSDictionary *headTitleParamDic = @{@"text":@"更多商家",@"font":kPingFangMedium(15),@"textAlignment":@(NSTextAlignmentLeft)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    UIButton *btn = [sectionModel.headerView viewWithTag:2];
    btn.hidden = NO;
    [btn addTarget:self action:@selector(loadDetailListData) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i<_KTVDetailListArr.count; i++){
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(110);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHHotelCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelCellID forIndexPath:indexPath];
            cell.shopType = ZSHKTVShopType;
            if (i==_KTVDetailListArr.count-1) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
            NSDictionary *paramDic = _KTVDetailListArr[indexPath.row];
            [cell updateCellWithParamDic:paramDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            NSDictionary *paramDic = _KTVDetailListArr[indexPath.row];
            NSDictionary *nextParamDic = @{KFromClassType:@(ZSHConfirmOrderToBottomBlurPopView),@"shopType":@(ZSHKTVShopType), @"deviceDic":weakself.KTVDetailParamDic,@"listDic":paramDic,@"liveInfoStr":@""};
            weakself.bottomBlurPopView = [weakself createBottomBlurPopViewWithParamDic:nextParamDic];
            [kAppDelegate.window addSubview:weakself.bottomBlurPopView];
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
