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

    [self.navigationItem setTitleView:self.searchView];
    self.searchView.searchBar.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, KBottomNavH, 0));
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
    for (int i = 0; i<_togetherLogic.dataArr.count; i++) {
        
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(140);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHTogetherView *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell updateCellWithModel:_togetherLogic.dataArr[i]];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHTogetherModel *model = _togetherLogic.dataArr[i];
            Class className = NSClassFromString(weakself.pushVCsArr[indexPath.row]);
            RootViewController *vc = [[className alloc]initWithParamDic:@{@"CONVERGE_ID":model.CONVERGE_ID}];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    
    
    return sectionModel;
}

- (void)locateBtnAction{
    
}

- (void)requestData {
    kWeakSelf(self);
    _togetherLogic = [[ZSHTogetherLogic alloc] init];
    [_togetherLogic requestConvergeList:^(id response) {
        [weakself initViewModel];
    }];
}

@end
