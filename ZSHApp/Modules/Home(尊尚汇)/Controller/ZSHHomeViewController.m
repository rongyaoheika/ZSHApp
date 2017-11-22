//
//  ZSHHomeViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.

#import "ZSHHomeViewController.h"
#import "ZSHHomeHeadView.h"
#import "ZSHCycleScrollView.h"
#import "ZSHNoticeViewCell.h"
#import "ZSHBaseCell.h"
#import "ZSHSearchBarView.h"
#import "ZSHTitleContentViewController.h"
#import "ZSHAirPlaneViewController.h"
#import "ZSHKTVModel.h"
#import "ZSHSubscribeViewController.h"
#import "ZSHBottomBlurPopView.h"
#import "ZSHServiceCenterViewController.h"
#import "ZSHToplineViewController.h"
#import "ZSHCityViewController.h"
#import "ZSHBaseTitleButtonCell.h"
#import "ZSHHomeMainModel.h"
#import "ZSHHotelDetailViewController.h"

static NSString *Identify_HeadCell = @"headCell";
static NSString *Identify_NoticeCell = @"noticeCell";
static NSString *Identify_ServiceCell = @"serviceCell";
static NSString *Identify_PlayCell = @"playCell";
static NSString *Identify_MagazineCell = @"magazineCell";

@interface ZSHHomeViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSArray                *pushVCsArr;
@property (nonatomic, strong) NSArray                *paramArr;

@property (nonatomic, strong) NSArray                *menuPushVCsArr;
@property (nonatomic, strong) NSArray                *menuParamArr;
@property (nonatomic, strong) ZSHBaseModel           *model;
@property (nonatomic, strong) ZSHBottomBlurPopView   *bottomBlurPopView;
@property (nonatomic, strong) NSArray                *dataArr;                 //字典数组

@property (nonatomic, strong) NSMutableDictionary    *dataDic;
@end

@implementation ZSHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    self.pushVCsArr = @[@"ZSHTitleContentViewController",
                        @"ZSHTitleContentViewController",
                        @"ZSHAirPlaneViewController",
                        @"ZSHAirPlaneViewController",
                        @"ZSHSubscribeViewController",
                        @"ZSHSubscribeViewController",
                        @"ZSHSubscribeViewController",
                        @"ZSHMoreSubscribeViewController"];
    
    self.paramArr = @[
                      @{KFromClassType:@(FromFoodVCToTitleContentVC)},
                      @{KFromClassType:@(FromHotelVCToTitleContentVC)},
                      @{KFromClassType:@(ZSHFromHomeTrainVCToAirPlaneVC),@"title":@"火车票预订"},
                      @{KFromClassType:@(ZSHHomeAirPlaneVCToAirPlaneVC),@"title":@"机票预订"},
                      @{KFromClassType:@(FromHorseVCToSubscribeVC),@"title":@"马术"},
                      @{KFromClassType:@(FromShipVCToSubscribeVC),@"title":@"游艇"},
                      @{KFromClassType:@(FromCarVCToSubscribeVC),@"title":@"豪车"},
                      @{KFromClassType:@(FromHelicopterVCToSubscribeVC),@"title":@"飞机"},
                      @{KFromClassType:@(FromGolfVCToSubscribeVC),@"title":@"高尔夫汇"}
                      ];
    self.menuPushVCsArr = @[@"",
                            @"ZSHServiceCenterViewController",
                            @"ZSHServiceCenterViewController",
                            @""];
    self.menuParamArr = @[@{},
                          @{KFromClassType:@(ZSHFromHomeMenuVCToServiceCenterVC),@"title":@"消息中心",@"titleArr":@[@"评论／回复我的",@"赞我的"],@"imageArr":@[@"menu_news",@"menu_love"], @"pushVCsArr":@[@"ZSHDiscussViewController", @"ZSHLikeViewController"]},
                            @{KFromClassType:@(ZSHFromHomeMenuVCToServiceCenterVC),@"title":@"系统通知",@"titleArr":@[@"荣耀黑卡官方帐号"],@"imageArr":@[@"menu_noti"]},

                            @{KFromClassType:@(ZSHFromHomeMenuVCToServiceCenterVC),@"title":@"消息中心",@"titleArr":@[@"评论／回复我的",@"赞我的"],@"imageArr":@[@"menu_news",@"menu_love"]},
                            @{KFromClassType:@(ZSHFromHomeMenuVCToServiceCenterVC),@"title":@"系统通知",@"titleArr":@[@"荣耀黑卡官方帐号"],@"imageArr":@[@"menu_noti"]},
                            @""];

    [self requestData];
    [self initViewModel];
}

- (void)createUI{
    [self addNavigationItemWithImageName:@"nav_home_more" title:@"三亚" locate:XYButtonEdgeInsetsStyleRight isLeft:YES target:self action:@selector(locateBtnAction) tag:10];
    [self addNavigationItemWithImageName:@"nav_home_menu" isLeft:NO target:self action:@selector(menuBtntClick:) tag:11];
    self.navigationItem.titleView = self.searchView;
    self.searchView.searchBar.delegate = self;

    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight + kRealValue(25), KScreenWidth, KScreenHeight-KNavigationBarHeight- kRealValue(25) - KBottomNavH);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
	[self.tableView registerClass:[ZSHHomeHeadView class] forCellReuseIdentifier:Identify_HeadCell];
	[self.tableView registerClass:[ZSHBaseTitleButtonCell class] forCellReuseIdentifier:Identify_NoticeCell];
    [self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:Identify_ServiceCell];
	[self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:Identify_PlayCell];
    [self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:Identify_MagazineCell];
}

- (void)requestData{
    [self testPostRequest];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeNoticeSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeServiceSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storePlaySection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMagazineSection]];
    [self.tableView reloadData];
}

//head
- (ZSHBaseTableViewSectionModel*)storeHeadSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(180);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHomeHeadView *cell = [tableView dequeueReusableCellWithIdentifier:Identify_HeadCell forIndexPath:indexPath];
        cell.btnClickBlock = ^(NSInteger tag) {
            Class className = NSClassFromString(weakself.pushVCsArr[tag]);
            RootViewController *vc = [[className alloc]initWithParamDic:weakself.paramArr[tag]];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    };
    
    return sectionModel;
}

//公告
- (ZSHBaseTableViewSectionModel*)storeNoticeSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = floor(kRealValue(55));
    NSArray *titleArr = @[@"公告，荣耀黑卡竞技平台全新上线01",@"第二次公告：荣耀黑卡竞技平台全新上线02",@"第三次公告：荣耀黑卡竞技平台全新上线03"];
    
    ZSHCycleScrollView *cellView = [[ZSHCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, sectionModel.headerHeight)];
    cellView.scrollDirection =  ZSHCycleScrollViewVertical;
    cellView.autoScroll = YES;
    cellView.dataArr = [titleArr  mutableCopy];
    kWeakSelf(self);
    cellView.itemClickBlock = ^(NSInteger index) {
        ZSHToplineViewController *toplineVC = [[ZSHToplineViewController alloc] init];
        [weakself.navigationController pushViewController:toplineVC animated:YES];
    };
    sectionModel.headerView = cellView;
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(135);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_NoticeCell forIndexPath:indexPath];
        cell.itemClickBlock = ^(NSInteger tag) {
            NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromHomeKTVVCToHotelDetailVC)};
            ZSHHotelDetailViewController *hotelDetailVC = [[ZSHHotelDetailViewController alloc]initWithParamDic:nextParamDic];
            [weakself.navigationController pushViewController:hotelDetailVC animated:YES];
        };
        
        if(_dataArr){
         [cell updateCellWithDataArr:_dataArr];
        }

        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
    };
    return sectionModel;
}

//荣耀服务
- (ZSHBaseTableViewSectionModel*)storeServiceSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    sectionModel.headerView = [self createHeaderiewWithTitle:@"荣耀服务"];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(80);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHNoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_ServiceCell forIndexPath:indexPath];
        NSDictionary *nextParamDic = @{KFromClassType:@(FromHomeServiceVCToNoticeView)};
        [cell updateCellWithParamDic:nextParamDic];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    };
    return sectionModel;
}

//汇聚玩趴
- (ZSHBaseTableViewSectionModel*)storePlaySection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    sectionModel.headerView = [self createHeaderiewWithTitle:@"汇聚玩趴"];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(95);
    __block  CGFloat cellHeight = cellModel.height;
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_PlayCell forIndexPath:indexPath];
        if (![cell.contentView viewWithTag:2]) {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_play"]];
            imageView.tag = 2;
            imageView.frame = CGRectMake(15, 0, KScreenWidth-30, cellHeight);
            [cell.contentView addSubview:imageView];
        }
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    return sectionModel;
}

//荣耀杂志
- (ZSHBaseTableViewSectionModel*)storeMagazineSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    sectionModel.headerView = [self createHeaderiewWithTitle:@"荣耀杂志"];
    sectionModel.footerHeight = kRealValue(37);
    sectionModel.footerView = nil;
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(115);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHNoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_MagazineCell forIndexPath:indexPath];
        NSDictionary *nextParamDic = @{KFromClassType:@(FromHomeMagazineVCToNoticeView)};
        [cell updateCellWithParamDic:nextParamDic];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
    };
    
    return sectionModel;
}

//荣耀音乐
- (ZSHBaseTableViewSectionModel*)storeMusicSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    sectionModel.headerView = [self createHeaderiewWithTitle:@"荣耀音乐"];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(80);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHNoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_ServiceCell forIndexPath:indexPath];
        NSDictionary *nextParamDic = @{KFromClassType:@(FromHomeServiceVCToNoticeView),@"":@""};
        [cell updateCellWithParamDic:nextParamDic];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    };
    return sectionModel;
}


#pragma getter
- (UIView *)createHeaderiewWithTitle:(NSString *)title{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(55))];
    NSDictionary *headLabellDic = @{@"text":title, @"font":kPingFangSemibold(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *headLabel = [ZSHBaseUIControl createLabelWithParamDic:headLabellDic];
    [headView addSubview:headLabel];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView).offset(kRealValue(13));
        make.bottom.mas_equalTo(headView).offset(-kRealValue(18));
        make.width.mas_equalTo(KScreenWidth -2*kRealValue(13));
        make.height.mas_equalTo(kRealValue(15));
    }];
    return headView;
}

#pragma mark - UISearchBar Delegate

//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
}

//编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    RLog(@"searchText:%@",searchText);
}

//搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
}

#pragma action
- (void)menuBtntClick:(UIButton *)menuBtn{
    kWeakSelf(self);
    NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromHomeMenuVCToBottomBlurPopView)};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight - KNavigationBarHeight) paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    [ZSHBaseUIControl setAnimationWithHidden:NO view:bottomBlurPopView completedBlock:nil];
    bottomBlurPopView.dissmissViewBlock = ^(UIView *blurView, NSIndexPath *indexpath) {
        [ZSHBaseUIControl setAnimationWithHidden:YES view:blurView completedBlock:^{
            if (indexpath) {//跳转到对应控制器
                Class className = NSClassFromString(weakself.menuPushVCsArr[indexpath.row]);
                RootViewController *vc = [[className alloc]initWithParamDic:weakself.menuParamArr[indexpath.row]];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
            return;
        }];
    };
    
//    [self testPostRequest];
}

- (void)locateBtnAction{
    
    ZSHCityViewController *cityVC = [[ZSHCityViewController alloc]init];
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)testPostRequest {
    [PPNetworkHelper openLog];
    
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlUserHome parameters:nil success:^(id responseObject) {
        RLog(@"请求成功：返回数据&%@",responseObject);
//        _dataArr = responseObject[@"pd"];
         weakself.dataArr = [ZSHHomeMainModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        [weakself initViewModel];
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

#pragma getter
- (ZSHBottomBlurPopView *)createBottomBlurPopViewWith:(ZSHFromVCToBottomBlurPopView)fromClassType{
    NSDictionary *nextParamDic = @{KFromClassType:@(fromClassType)};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    return bottomBlurPopView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
