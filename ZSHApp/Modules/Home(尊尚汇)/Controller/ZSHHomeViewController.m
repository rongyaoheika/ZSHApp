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
#import "ZSHHomeLogic.h"
#import "ZSHHotelViewController.h"
#import "ZSHKTVDetailViewController.h"
#import "PYSearchViewController.h"
#import "ZSHGoodsTitleContentViewController.h"
#import "GYZChooseCityController.h"
#import "ZSHFindViewController.h"
#import "ZSHMagazineViewController.h"
#import "ZSHGuideView.h"


static NSString *Identify_HeadCell = @"headCell";
static NSString *Identify_NoticeCell = @"noticeCell";
static NSString *Identify_ServiceCell = @"serviceCell";
static NSString *Identify_PlayCell = @"playCell";
static NSString *Identify_MagazineCell = @"magazineCell";
static NSString *Identify_MusicCell = @"musicCell";

@interface ZSHHomeViewController ()<UISearchBarDelegate,GYZChooseCityDelegate,PYSearchViewControllerDelegate>


@property (nonatomic, strong) NSArray                *pushVCsArr;
@property (nonatomic, strong) NSArray                *paramArr;

@property (nonatomic, strong) NSArray                *menuPushVCsArr;
@property (nonatomic, strong) NSArray                *menuParamArr;
@property (nonatomic, strong) ZSHBaseModel           *model;
@property (nonatomic, strong) ZSHBottomBlurPopView   *bottomBlurPopView;

@property (nonatomic, strong) ZSHHomeLogic           *homeLogic;
@property (nonatomic, strong) NSArray                *noticePushVCsArr;
@property (nonatomic, strong) NSArray                *noticeParamArr;

@property (nonatomic, strong) NSArray                *musicPushVCsArr;
@property (nonatomic, strong) NSArray                *musicParamArr;


@end

@implementation ZSHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    //加载网络数据
    [self requestData];
    
    //更多列表
    self.pushVCsArr = @[@"ZSHTitleContentViewController",
                        @"ZSHTitleContentViewController",
                        @"ZSHAirPlaneViewController",
                        @"ZSHAirPlaneViewController",
                        
                        @"ZSHTitleContentViewController",     //马术
                        @"ZSHTitleContentViewController",     //游艇
                        @"ZSHTitleContentViewController",     //豪车
                        
                        @"ZSHMoreSubscribeViewController"];   //更多
    
    self.paramArr = @[
                      @{KFromClassType:@(FromFoodVCToTitleContentVC)},
                      @{KFromClassType:@(FromHotelVCToTitleContentVC)},
                      @{KFromClassType:@(ZSHFromHomeTrainVCToAirPlaneVC),@"title":@"火车票预订"},
                      @{KFromClassType:@(ZSHHomeAirPlaneVCToAirPlaneVC),@"title":@"机票预订"},
                      @{KFromClassType:@(FromHorseVCToTitleContentVC)},  //马术
                      @{KFromClassType:@(FromShipVCToTitleContentVC)},   //游艇
                      @{KFromClassType:@(FromLuxcarVCToTitleContentVC)}, //豪车
                      @{}
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
    
    //酒吧，美食，ktv，酒店
    self.noticePushVCsArr = @[@"ZSHBarDetailViewController",@"ZSHFoodDetailViewController", @"ZSHKTVDetailViewController",@"ZSHHotelDetailViewController"];
    
    //歌手，排行榜，曲库，电台
    self.musicPushVCsArr = @[@"ZSHSingerViewController",@"ZSHMusicRankViewController",@"ZSHMusicLibraryViewController",@"ZSHMusicRadioViewController"];

}

- (void)requestData{
    kWeakSelf(self);
    _homeLogic = [[ZSHHomeLogic alloc]init];
    
    if (KScreenWidth == 812.0 && kiOS11Later) {
        if (@available(ios 11.0, *)) {
            [self prefersHomeIndicatorAutoHidden];
        }
    }
   
    
    [_homeLogic loadNewsCellDataSuccess:^(id responseObject) {
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:1];
         [weakself updateSectionDatWithSet:indexSet];
    } fail:nil];
    
    [_homeLogic loadNoticeCellDataSuccess:^(id responseObject) {
      weakself.tableViewModel.sectionModelArray[1] = [weakself storeNoticeSection];
      NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:1];
      [weakself updateSectionDatWithSet:indexSet];
    } fail:nil];
    
    [_homeLogic loadServiceCellDataSuccess:^(id responseObject) {
        weakself.tableViewModel.sectionModelArray[2] = [weakself storeServiceSection];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
        [weakself updateSectionDatWithSet:indexSet];
    } fail:nil];
    
    [_homeLogic loadPartyCellDataSuccess:^(id responseObject) {
        weakself.tableViewModel.sectionModelArray[3] = [weakself storePlaySection];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:3];
        [weakself updateSectionDatWithSet:indexSet];
    } fail:nil];
    
    [_homeLogic loadMagzineCellDataSuccess:^(id responseObject) {
        weakself.tableViewModel.sectionModelArray[4] = [weakself storeMagazineSection];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:4];
        [weakself updateSectionDatWithSet:indexSet];
    } fail:nil];
    
    
    [_homeLogic loadMusicCellDataSuccess:^(id data) {
      weakself.tableViewModel.sectionModelArray[5] = [weakself storeMusicSection];
      NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:5];
      [weakself updateSectionDatWithSet:indexSet];
    } fail:nil];
    
}

- (void)updateSectionDatWithSet:(NSIndexSet *)indexSet{
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endTabViewRefresh];
}

- (void)createUI{
    [self addNavigationItemWithImageName:@"nav_home_more" title:@"三亚" locate:XYButtonEdgeInsetsStyleRight isLeft:YES target:self action:@selector(locateBtnAction) tag:10];
    [self addNavigationItemWithImageName:@"nav_home_menu" isLeft:NO target:self action:@selector(menuBtntClick:) tag:11];
    
    UIButton *searchBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"搜索",@"font":kPingFangRegular(14),@"withImage":@(YES),@"normalImage":@"nav_home_search"}];
    searchBtn.frame = CGRectMake(0, 0, kRealValue(270), 30);
    searchBtn.backgroundColor = KZSHColor1A1A1A;
    searchBtn.layer.cornerRadius = 5.0;
    searchBtn.layer.masksToBounds = YES;
    kWeakSelf(self);
    [searchBtn addTapBlock:^(UIButton *btn) {
        [weakself searchAction];
    }];
    [self.navigationItem setTitleView:searchBtn];
    
//    self.navigationItem.titleView = self.searchView;
//    self.searchView.searchBar.delegate = self;

    self.tableView.frame = CGRectMake(0, KNavigationBarHeight + kRealValue(25), KScreenWidth, KScreenHeight-KNavigationBarHeight- kRealValue(25) - KBottomTabH);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
	[self.tableView registerClass:[ZSHHomeHeadView class] forCellReuseIdentifier:Identify_HeadCell];

//	[self.tableView registerClass:[ZSHBaseTitleButtonCell class] forCellReuseIdentifier:Identify_NoticeCell];
    [self.tableView registerClass:[ZSHBaseTitleButtonCell class] forCellReuseIdentifier:Identify_ServiceCell];

	[self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:Identify_PlayCell];
    [self.tableView registerClass:[ZSHBaseTitleButtonCell class] forCellReuseIdentifier:Identify_MagazineCell];
    [self.tableView registerClass:[ZSHBaseTitleButtonCell class] forCellReuseIdentifier:Identify_MusicCell];
    
    [self initViewModel];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeNoticeSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeServiceSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storePlaySection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMagazineSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMusicSection]];
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

//新闻推荐
- (ZSHBaseTableViewSectionModel*)storeNoticeSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = floor(kRealValue(55));
    NSMutableArray *mTitleArr = [[NSMutableArray alloc]init];
    for (NSDictionary *paramDic in _homeLogic.newsArr) {
        [mTitleArr addObject:paramDic[@"NEWSTITLE"]];
    }
    ZSHCycleScrollView *cellView = [[ZSHCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, sectionModel.headerHeight)];
    cellView.scrollDirection =  ZSHCycleScrollViewVertical;
    cellView.autoScroll = YES;
    cellView.dataArr = mTitleArr;
   
    cellView.itemClickBlock = ^(NSInteger index) {
        NSDictionary *nextParamDic = @{KFromClassType:@(FromFindVCToTitleContentVC),@"title":@"头条",@"shopId":_homeLogic.newsArr[index][@"NEWS_ID"]};
        ZSHTitleContentViewController *titleContentVC = [[ZSHTitleContentViewController alloc]initWithParamDic:nextParamDic];
        [weakself.navigationController pushViewController:titleContentVC animated:YES];
    };
    sectionModel.headerView = cellView;
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(135);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
//        ZSHBaseTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_NoticeCell forIndexPath:indexPath];
        ZSHBaseTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_NoticeCell];
        if (!cell) {
            cell = [[ZSHBaseTitleButtonCell alloc] init];
            cell.itemClickBlock = ^(NSInteger tag) {
                NSDictionary *subDic = _homeLogic.noticeArr[tag];
                if (tag < weakself.noticePushVCsArr.count) {
                    NSDictionary *nextParamDic = @{@"shopId":subDic[@"SORT_ID"]};
                    Class className = NSClassFromString(weakself.noticePushVCsArr[tag]);
                    RootViewController *vc = [[className alloc]initWithParamDic:nextParamDic];
                    [weakself.navigationController pushViewController:vc animated:YES];
                } else {//游艇(4)
                    NSDictionary *nextParamDic = @{KFromClassType:@(ZSHShipType),@"shopId":subDic[@"SORT_ID"]};
                    ZSHSubscribeViewController *subScribeVC = [[ZSHSubscribeViewController alloc]initWithParamDic:nextParamDic];
                    [weakself.navigationController pushViewController:subScribeVC animated:YES];
                    
                }
                
            };
        }
    
        
        if(_homeLogic.noticeArr){
            [cell updateCellWithDataArr:_homeLogic.noticeArr paramDic:@{KFromClassType:@(FromHomeNoticeVCToNoticeView)}];
        }

        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
    };
    return sectionModel;
}

//荣耀服务
- (ZSHBaseTableViewSectionModel*)storeServiceSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    sectionModel.headerView = [self createHeaderiewWithTitle:@"荣耀服务"];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(100);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_ServiceCell forIndexPath:indexPath];
        cell.itemClickBlock = ^(NSInteger tag) {//荣耀服务详情
            NSDictionary *subDic = _homeLogic.serviceArr[tag];
            NSDictionary *nextParamDic = @{KFromClassType:@(ZSHServiceType),@"shopId":subDic[@"SERVER_ID"], @"SHOPTYPE":subDic[@"SHOPTYPE"]};
            ZSHSubscribeViewController *subScribeVC = [[ZSHSubscribeViewController alloc]initWithParamDic:nextParamDic];
            [weakself.navigationController pushViewController:subScribeVC animated:YES];
        };
        
        if(_homeLogic.serviceArr){
            [cell updateCellWithDataArr:_homeLogic.serviceArr paramDic:@{KFromClassType:@(FromHomeServiceVCToNoticeView)}];
        }
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
            NSDictionary *nextParamDic = @{KFromClassType:@(FromBuyVCToGuideView),@"pageViewHeight":@(cellHeight),@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false)};
            ZSHGuideView *guideView = [[ZSHGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, cellHeight) paramDic:nextParamDic];
            guideView.tag = 2;
            [cell addSubview:guideView];
        }
        if (_homeLogic.partyArr.count) {
            ZSHGuideView *guideView = [cell viewWithTag:2];
            NSMutableArray *imageArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic  in _homeLogic.partyArr) {
                [imageArr addObject:dic[@"PARTYIMG"]];
            }
            [guideView updateViewWithParamDic:@{@"dataArr":imageArr}];
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
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    sectionModel.headerView = [self createHeaderiewWithTitle:@"荣耀杂志"];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(120);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_MagazineCell forIndexPath:indexPath];
        cell.itemClickBlock = ^(NSInteger tag) {
            ZSHMagazineViewController *magazineVC = [[ZSHMagazineViewController alloc] initWithParamDic:@{@"magazine":weakself.homeLogic.magzineArr[tag]}];
            [weakself.navigationController pushViewController:magazineVC animated:YES];
        };
        if(_homeLogic.magzineArr){
            [cell updateCellWithDataArr:_homeLogic.magzineArr paramDic:@{KFromClassType:@(FromHomeMagazineVCToNoticeView)}];
        }
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
    };
    
    return sectionModel;
}

//荣耀音乐
- (ZSHBaseTableViewSectionModel*)storeMusicSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    sectionModel.headerView = [self createHeaderiewWithTitle:@"荣耀音乐"];
    sectionModel.footerHeight = kRealValue(37);
    sectionModel.footerView = nil;
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(100);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_MusicCell forIndexPath:indexPath];
        cell.itemClickBlock = ^(NSInteger tag) {
            Class className = NSClassFromString(weakself.musicPushVCsArr[tag]);
            RootViewController *vc = [[className alloc]init];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        
        if(_homeLogic.musicArr){
            [cell updateCellWithDataArr:_homeLogic.musicArr paramDic:@{KFromClassType:@(FromHomeMusicVCToNoticeView)}];
        }
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
    };
    return sectionModel;
}


#pragma getter
- (UIView *)createHeaderiewWithTitle:(NSString *)title{
    kWeakSelf(self);
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(55))];
    NSDictionary *headLabellDic = @{@"text":title, @"font":kPingFangMedium(15),@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *headLabel = [ZSHBaseUIControl createLabelWithParamDic:headLabellDic];
    [headView addSubview:headLabel];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView).offset(kRealValue(13));
        make.bottom.mas_equalTo(headView).offset(-kRealValue(18));
        make.width.mas_equalTo(KScreenWidth -2*kRealValue(13));
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    if ([title isEqualToString:@"荣耀杂志"]) {
        UIButton *moreBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"withImage":@(YES),@"normalImage":@"mine_next"}];
        [moreBtn addTapBlock:^(UIButton *btn) {
            // 荣耀杂志
            ZSHTitleContentViewController *magazineVC = [[ZSHTitleContentViewController alloc] initWithParamDic:@{KFromClassType:@(FromMagazineVCToTitleContentVC),@"title":@"荣耀杂志"}];
            [weakself.navigationController pushViewController:magazineVC animated:YES];
        }];
        
        [headView addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(headView).offset(kRealValue(-KLeftMargin));
            make.center.centerY.mas_equalTo(headLabel);
            make.size.mas_equalTo(CGSizeMake(kRealValue(9), kRealValue(14)));
        }];
    }
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
- (void)searchAction {
    kWeakSelf(self);
    NSArray *hotSeaches = @[@"酒店", @"美食", @"旅游", @"聚会", @"KTV", @"酒吧", @"品鉴", @"豪车", @"游艇"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"PYExampleSearchPlaceholderText", @"搜索编程语言") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        ZSHGoodsTitleContentViewController *goodContentVC = [[ZSHGoodsTitleContentViewController alloc]initWithParamDic:@{@"searchText":searchText,KFromClassType:@(FromSearchResultVCTOGoodsTitleVC)}];
        [weakself.navigationController pushViewController:goodContentVC animated:YES];
    }];
    searchViewController.recommendViewType = 0;
    searchViewController.showRecommendView = YES;
    searchViewController.hotSearchStyle = PYHotSearchStyleARCBorderTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleARCBorderTag;
    searchViewController.searchBarBackgroundColor = KZSHColor1A1A1A;
    searchViewController.delegate = self;
    [self.navigationController pushViewController:searchViewController animated:YES];
}


- (void)menuBtntClick:(UIButton *)menuBtn {
    kWeakSelf(self);
    [ZSHBaseUIControl setAnimationWithHidden:NO view:self.bottomBlurPopView completedBlock:nil];
    self.bottomBlurPopView.dissmissViewBlock = ^(UIView *blurView, NSIndexPath *indexpath) {
        [ZSHBaseUIControl setAnimationWithHidden:YES view:blurView completedBlock:^{
            if (indexpath) {//跳转到对应控制器
                Class className = NSClassFromString(weakself.menuPushVCsArr[indexpath.row]);
                RootViewController *vc = [[className alloc]initWithParamDic:weakself.menuParamArr[indexpath.row]];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
            return;
        }];
    };
}

- (void)locateBtnAction {
//    ZSHCityViewController *cityVC = [[ZSHCityViewController alloc]init];
//    [self.navigationController pushViewController:cityVC animated:YES];

    GYZChooseCityController *cityVC = [[GYZChooseCityController alloc]init];
    [cityVC setDelegate:self];
    cityVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    cityVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    [self.navigationController pushViewController:cityVC animated:YES];
}



#pragma getter
- (ZSHBottomBlurPopView *)bottomBlurPopView{
    if (!_bottomBlurPopView) {
         NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromHomeMenuVCToBottomBlurPopView)};
        _bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight - KNavigationBarHeight) paramDic:nextParamDic];
        _bottomBlurPopView.blurRadius = 20;
        _bottomBlurPopView.dynamic = NO;
        _bottomBlurPopView.tintColor = KClearColor;
    }
    return _bottomBlurPopView;
}

#pragma mark ————— 下拉刷新 —————
-(void)headerRereshing{
    [self requestData];
}

#pragma mark ————— 上拉刷新 —————
-(void)footerRereshing{
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    [self addNavigationItemWithImageName:@"nav_home_more" title:city.cityName locate:XYButtonEdgeInsetsStyleRight isLeft:YES target:self action:@selector(locateBtnAction) tag:10];
    [chooseCityController.navigationController popViewControllerAnimated:YES];
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
     [chooseCityController.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersHomeIndicatorAutoHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
