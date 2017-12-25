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


static NSString *cellIdentifier = @"listCell";

@interface ZSHTogetherViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSArray            *pushVCsArr;
@property (nonatomic, strong) ZSHTogetherLogic   *togetherLogic;

@end

@implementation ZSHTogetherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.pushVCsArr = @[@"ZSHEntertainmentViewController",@"ZSHEntertainmentViewController",@"ZSHEntertainmentViewController",@"ZSHEntertainmentViewController",@"ZSHEntertainmentViewController",@"ZSHEntertainmentViewController"];

    [self initViewModel];
    [self requestData];
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
//    [self.navigationItem setTitleView:self.searchView];
//    self.searchView.searchBar.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, KBottomTabH, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHTogetherView class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView reloadData];
    
    [self addNavigationItemWithImageName:@"nav_home_more" title:@"三亚" locate:XYButtonEdgeInsetsStyleRight isLeft:YES target:self action:@selector(locateBtnAction) tag:10];
    
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

- (void)searchAction{
    // 1. Create an Array of popular search
    NSArray *hotSeaches = @[@"阿哲", @"散打哥", @"天佑", @"赵小磊", @"赵雷", @"陈山", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create a search view controller
    kWeakSelf(self);
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"PYExampleSearchPlaceholderText", @"搜索编程语言") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view conroller
        ZSHGoodsTitleContentViewController *goodContentVC = [[ZSHGoodsTitleContentViewController alloc]initWithParamDic:@{@"searchText":searchText,KFromClassType:@(FromSearchResultVCTOGoodsTitleVC)}];
        [weakself.navigationController pushViewController:goodContentVC animated:YES];
    }];
    // 3. Set style for popular search and search history
    searchViewController.hotSearchStyle = PYHotSearchStyleARCBorderTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleARCBorderTag;
    searchViewController.searchBarBackgroundColor = KZSHColor1A1A1A;
    
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    //    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:searchViewController];
    //    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)locateBtnAction{
    ZSHCityViewController *cityVC = [[ZSHCityViewController alloc]init];
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)requestData {
    kWeakSelf(self);
    _togetherLogic = [[ZSHTogetherLogic alloc] init];
    [_togetherLogic requestConvergeList:^(id response) {
        [weakself initViewModel];
    }];
}

@end
