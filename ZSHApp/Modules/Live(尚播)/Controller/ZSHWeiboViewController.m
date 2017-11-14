//
//  ZSHWeiboViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHWeiboViewController.h"
#import "ZSHWeiBoCell.h"
#import "ZSHWeiBoCellModel.h"

@interface ZSHWeiboViewController ()

@property (nonatomic,strong)NSArray *dataArr;

@end

@implementation ZSHWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.dataArr = [ZSHWeiBoCellModel mj_objectArrayWithFilename:@"cellData.plist"];
    [self initViewModel];
}

- (void)createUI{
    self.title = @"黑微博";
//    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHWeiBoCell class] forCellReuseIdentifier:NSStringFromClass([ZSHWeiBoCell class])];
     [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    kWeakSelf(self);
    for (int i = 0; i<self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        kWeakSelf(cellModel);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHWeiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZSHWeiBoCell class])];
            cell.backgroundColor = KClearColor;
            ZSHWeiBoCellModel *model = weakself.dataArr[indexPath.row];
             weakcellModel.height = [ZSHWeiBoCell getCellHeightWithModel:model];
            NSDictionary *ndextParamDic = @{KFromClassType:@(ZSHWeiboVCToWeiBoCell)};
            [cell updateCellWithParamDic:ndextParamDic];
            [cell updateCellWithModel:model];
            return cell;
        };
    }

    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
