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
    NSArray *titleArr = @[@"美食商家", @"酒店商家", @"马术商家", @"游艇商家", @"豪车商家", @"高尔夫商家", @"飞机商家", @"高端品鉴商家", @"尊购商家", @"娱乐商家", @"金融机构", @"自媒体", @"音乐"];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i++) {
        [dataArr addObject:@{@"image": NSStringFormat(@"join%d",i), @"title": titleArr[i]}];
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
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {//我要入驻

            NSString *title = indexPath.row>1?@"企业入驻":@"门店入驻";
            if (indexPath.row == 11) { // 自媒体
                ZSHMultiInfoViewController *multiInfoVC = [[ZSHMultiInfoViewController alloc] initWithParamDic:@{KFromClassType:@(FromWeMediaVCToMultiInfoVC),@"title":title, @"bottomBtnTitle":@"确认创建",@"showGuide":@(YES),@"row":@(indexPath.row),@"categoryId":titleArr[indexPath.row]}];
                [weakself.navigationController pushViewController:multiInfoVC animated:YES];
            } else {
                ZSHMultiInfoViewController *multiInfoVC = [[ZSHMultiInfoViewController alloc] initWithParamDic:@{KFromClassType:@(FromCreateStoreVCToMultiInfoVC),@"title":title, @"bottomBtnTitle":@"确认创建",@"showGuide":@(YES),@"row":@(indexPath.row),@"categoryId":titleArr[indexPath.row]}];
                [weakself.navigationController pushViewController:multiInfoVC animated:YES];
            }
        };
    }
    return sectionModel;
}

@end
