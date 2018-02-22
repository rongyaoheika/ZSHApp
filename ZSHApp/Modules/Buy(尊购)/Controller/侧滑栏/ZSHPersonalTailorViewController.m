//
//  ZSHPersonalTailorViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPersonalTailorViewController.h"
#import "ZSHTogetherView.h"
#import "ZSHTailorDetailViewController.h"
#import "ZSHBuyLogic.h"

static NSString *cellIdentifier = @"listCell";
@interface ZSHPersonalTailorViewController ()

@property (nonatomic, strong) NSArray      *titleArr;
@property (nonatomic, strong) NSArray      *vcArr;
@property (nonatomic, strong) NSArray      *paramDicArr;
@property (nonatomic, strong) ZSHBuyLogic  *buyLogic;
@end

@implementation ZSHPersonalTailorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    self.vcArr = @[@"",@"ZSHGoodsViewController",@"ZSHTitleContentViewController",@"LZCartViewController",@"",@"ZSHPersonalTailorViewController"];
    [self initViewModel];
    _buyLogic = [[ZSHBuyLogic alloc] init];
    [self requestData];
}

- (void)createUI{
    self.title = @"私人频道";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHTogetherView class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    kWeakSelf(self);
    for (int i = 0; i<_buyLogic.personModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(185);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //需要注册，无需判空
            ZSHTogetherView *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell setParamDic:@{KFromClassType:@(ZSHFromPersonalTailorVCToTogetherView)}];
            [cell updateCellWithModel:_buyLogic.personModelArr[indexPath.row]];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHTailorDetailViewController *tailorDetailVC = [[ZSHTailorDetailViewController alloc] initWithParamDic:@{@"PersonalID":_buyLogic.personModelArr[indexPath.row].PERSONAL_ID}];
            [weakself.navigationController pushViewController:tailorDetailVC animated:YES];
        };
    }
    return sectionModel;
}

- (void)requestData {
    kWeakSelf(self);
    [_buyLogic requestPersonLists:^(id response) {
        [weakself initViewModel];
    }];
}

@end
