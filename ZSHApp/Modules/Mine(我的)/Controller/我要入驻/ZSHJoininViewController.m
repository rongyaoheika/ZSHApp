//
//  ZSHJoininViewController.m
//  ZSHApp
//
//  Created by mac on 12/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHJoininViewController.h"
#import "ZSHJoininCell.h"
#import "ZSHMultiInfoViewController.h"

static NSString * ZSHJoininCellID = @"ZSHJoininCellID";

@interface ZSHJoininViewController ()


@end

@implementation ZSHJoininViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
}

- (void)createUI{
    self.title = @"我要入驻";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0 ));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;

    [self.tableView registerClass:[ZSHJoininCell class] forCellReuseIdentifier:ZSHJoininCellID];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *title = @[@"美食商家入驻", @"酒店商家入驻", @"马术商家入驻", @"游艇商家入驻", @"豪车商家入驻", @"高尔夫商家入驻", @"飞机商家入驻", @"高端品鉴商家入驻", @"娱乐商家入驻", @"金融机构入驻", @"自媒体入驻", @"音乐入驻"];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 0; i < title.count; i++) {
        [dataArr addObject:@{@"image": NSStringFormat(@"join%d",i), @"title": title[i]}];
    }
    
    for (int i = 0; i<dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(60);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHJoininCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHJoininCellID];
            [cell updateCellWithParamDic:dataArr[indexPath.row]];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHMultiInfoViewController *multiInfoVC = [[ZSHMultiInfoViewController alloc] initWithParamDic:@{KFromClassType:@(FromCreateStoreVCToMultiInfoVC),@"title":@"创建门店", @"bottomBtnTitle":@"确认创建",@"showGuide":@(YES)}];
            [weakself.navigationController pushViewController:multiInfoVC animated:YES];
        };
    }
    return sectionModel;
}

@end
