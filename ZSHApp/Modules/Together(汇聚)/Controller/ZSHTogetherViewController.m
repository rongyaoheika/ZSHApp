//
//  ZSHTogetherViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTogetherViewController.h"
#import "ZSHTogetherView.h"
#import "ZSHBaseCell.h"
#import "ZSHEntertainmentViewController.h"
#import "ZSHEntertainmentDetailViewController.h"
#import "ZSHTogetherLogic.h"
#import "ZSHCityViewController.h"
#import "PYSearchViewController.h"
#import "ZSHGoodsTitleContentViewController.h"
#import "ZSHHomeLogic.h"
#import "GYZChooseCityController.h"
static NSString *cellIdentifier = @"listCell";

@interface ZSHTogetherViewController ()<UISearchBarDelegate,PYSearchViewControllerDelegate,GYZChooseCityDelegate,HCLocationManagerDelegate>


@property (nonatomic, strong) NSArray               *pushVCsArr;
@property (nonatomic, strong) ZSHTogetherLogic      *togetherLogic;

@end

@implementation ZSHTogetherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self startLocateWithDelegate:self];
    self.pushVCsArr = @[@"ZSHEntertainmentViewController",@"ZSHEntertainmentViewController",@"ZSHEntertainmentViewController",@"ZSHEntertainmentViewController",@"ZSHEntertainmentViewController",@"ZSHEntertainmentViewController"];
    _togetherLogic = [[ZSHTogetherLogic alloc] init];
    [self initViewModel];
    [self requestData];
    [self requestCarouselFigure];
}

- (void)createUI{
    
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
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, KBottomTabH, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHTogetherView class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView reloadData];
    
    [self addNavigationItemWithImageName:@"nav_home_more" title:@"三亚市" locate:XYButtonEdgeInsetsStyleRight isLeft:YES target:self action:@selector(locateBtnAction) tag:10];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<_togetherLogic.togertherDataArr.count; i++) {
        
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(140);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHTogetherView *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell setParamDic:@{KFromClassType:@(ZSHFromTogetherVCToTogetherView)}];
            [cell updateCellWithModel:_togetherLogic.togertherDataArr[i]];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHTogetherModel *model = _togetherLogic.togertherDataArr[i];
            Class className = NSClassFromString(weakself.pushVCsArr[indexPath.row]);
            RootViewController *vc = [[className alloc]initWithParamDic:@{@"CONVERGE_ID":model.CONVERGE_ID,@"Title":model.IMGCNCHAR}];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    
    
    return sectionModel;
}

- (void)searchAction {
    kWeakSelf(self);
    ZSHHomeLogic *homeLogic = [[ZSHHomeLogic alloc]init];
    NSDictionary *paramDic = @{@"PARENT_ID":@(3)};
    NSMutableArray *hotSearchMArr = [[NSMutableArray alloc]init];
    NSMutableArray *recommendImageMArr = [[NSMutableArray alloc]init];
    [homeLogic loadSearchListWithDic:paramDic success:^(id response) {
        for (NSDictionary *dic in response[@"pd"]) {
            [hotSearchMArr addObject:dic[@"NAME"]];
        }
        
        for (NSDictionary *dic in response[@"showimgs"]) {
            [recommendImageMArr addObject:dic[@"SHOWIMAGES"]];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSearchMArr searchBarPlaceholder:NSLocalizedString(@"Search", @"搜索") recommendArr:recommendImageMArr didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
                ZSHGoodsTitleContentViewController *goodContentVC = [[ZSHGoodsTitleContentViewController alloc]initWithParamDic:@{@"searchText":searchText,KFromClassType:@(FromSearchResultVCTOGoodsTitleVC)}];
                [weakself.navigationController pushViewController:goodContentVC animated:YES];
            }];
            searchViewController.showRecommendView = YES;
//            searchViewController.hotSearchStyle = PYHotSearchStyleARCBorderTag;
//            searchViewController.searchHistoryStyle = PYSearchHistoryStyleARCBorderTag;
//            searchViewController.searchBarBackgroundColor = KZSHColor1A1A1A;
            searchViewController.delegate = self;
            [self.navigationController pushViewController:searchViewController animated:YES];
        });
        
        
    }];
    
}

- (void)locateBtnAction{
//    ZSHCityViewController *cityVC = [[ZSHCityViewController alloc]init];
//    [self.navigationController pushViewController:cityVC animated:YES];
    
    GYZChooseCityController *cityVC = [[GYZChooseCityController alloc]init];
    [cityVC setDelegate:self];
    cityVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    cityVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    [self.navigationController pushViewController:cityVC animated:YES];

}

#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
//    [self addNavigationItemWithImageName:@"nav_home_more" title:city.cityName locate:XYButtonEdgeInsetsStyleRight isLeft:YES target:self action:@selector(locateBtnAction) tag:10];
    [self.leftBtn setTitle:city.cityName forState:UIControlStateNormal];
    [chooseCityController.navigationController popViewControllerAnimated:YES];
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [chooseCityController.navigationController popViewControllerAnimated:YES];
}

- (void)requestData {
    kWeakSelf(self);
    
    [_togetherLogic requestConvergeList:^(id response) {
        [weakself initViewModel];
    }];
}


- (void)requestCarouselFigure {

    [_togetherLogic requestAdvertiseListWithAdPosition:@"0" success:^(id response) {
        
    }];
}

#pragma mark - <HCLocationManagerDelegate>
- (void)loationMangerSuccessLocationWithCity:(NSString *)city{
    RLog(@"city = %@",city);
    [self.leftBtn setTitle:city forState:UIControlStateNormal];
}

@end
