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

@end

@implementation ZSHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
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
                            @{KFromClassType:@(ZSHFromHomeMenuVCToServiceCenterVC),@"title":@"消息中心",@"titleArr":@[@"评论／回复我的",@"赞我的"],@"imageArr":@[@"menu_news",@"menu_love"]},
                            @{KFromClassType:@(ZSHFromHomeMenuVCToServiceCenterVC),@"title":@"系统通知",@"titleArr":@[@"隐形者官方帐号"],@"imageArr":@[@"menu_noti"]},
                            @""];
    
    [self initViewModel];
}

- (void)createUI{
    [self addNavigationItemWithImageName:@"nav_home_more" title:@"三亚" locate:XYButtonEdgeInsetsStyleRight isLeft:YES target:self action:@selector(locateBtnAction) tag:10];
    [self addNavigationItemWithImageName:@"nav_home_menu" isLeft:NO target:self action:@selector(menuBtntClick:) tag:11];
//    self.navigationItem.titleView.backgroundColor = [UIColor redColor];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
//    RLog(@"navigationItem 的frame ==%@",NSStringFromCGRect(self.navigationController.navigationBar.frame));
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight + kRealValue(25), KScreenWidth, KScreenHeight-KNavigationBarHeight- kRealValue(25) - KBottomNavH);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
	[self.tableView registerClass:[ZSHHomeHeadView class] forCellReuseIdentifier:Identify_HeadCell];
	[self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:Identify_NoticeCell];
    [self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:Identify_ServiceCell];
	[self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:Identify_PlayCell];
    [self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:Identify_MagazineCell];
    
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeNoticeSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeServiceSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storePlaySection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMagazineSection]];
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
    sectionModel.headerView = cellView;
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(135);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHNoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_NoticeCell forIndexPath:indexPath];
        NSDictionary *nextParamDic = @{KFromClassType:@(FromHomeNoticeVCToNoticeView)};
        [cell updateCellWithParamDic:nextParamDic];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_play"]];
        imageView.frame = CGRectMake(15, 0, KScreenWidth-30, cellHeight);
        [cell.contentView addSubview:imageView];
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
//    [self setAnimationWithHidden:NO view:bottomBlurPopView completedBlock:nil];
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
    
    //    http://18000d15f7.iask.in/appuserin/useraddshipadr?SHIPADR(混淆码)
    
//    [self testPostRequest];
    
}



- (void)locateBtnAction{
    
}

- (void)testPostRequest{
    [PPNetworkHelper openLog];
    //http://18000d15f7.iask.in/MVNFHM//appuserin/useraddshipadr?SHIPADR
    //    NSDictionary *dic = @{@"CONSIGNEE":@"赵维维",@"ADRPHONE":@"13718127415",@"PROVINCE":@"北京市阐扬去大望路",@"ADDRESS":@"珠江帝景D区"};
    NSDictionary *dic = @{@"FKEY":@"408d5b21299a4e99a9be464d4b47a9cd"};
    [PPNetworkHelper POST:@"http://18000d15f7.iask.in/MVNFHM//appuserin/usershipadr?SHIPADR" parameters:dic success:^(id responseObject) {
        RLog(@"请求成功：返回数据&%@",responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

- (void)testGetRequest{
    //CONSIGNEE 收货人姓名/ADRPHONE 收货人电话/PROVINCE  收货人所在地区/ADDRESS  收货人详细地址
    NSDictionary *dic = @{@"CONSIGNEE":@"赵维维",@"ADRPHONE":@"13718127415",@"PROVINCE":@"北京市阐扬去大望路",@"ADDRESS":@"珠江帝景D区"};
    [PPNetworkHelper GET:@"http://18000d15f7.iask.in/appuserin/useraddshipadr?SHIPADR" parameters:nil success:^(id responseObject) {
        RLog(@"get请求成功%@",responseObject);
    } failure:^(NSError *error) {
        RLog(@"get请求错误");
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
