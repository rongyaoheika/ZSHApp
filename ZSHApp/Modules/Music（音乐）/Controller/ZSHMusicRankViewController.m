//
//  ZSHMusicRankViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicRankViewController.h"
#import "ZSHMusicRankCell.h"

@interface ZSHMusicRankViewController ()

@end

static NSString *ZSHMusicRankCellID = @"ZSHMusicRankCell";

@implementation ZSHMusicRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    [self initViewModel];
}

- (void)createUI{
    self.title = @"排行榜";
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = KZSHColor1D1D1D;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHMusicRankCell class] forCellReuseIdentifier:ZSHMusicRankCellID];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.footerHeight = 5;
    sectionModel.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    for (int i = 0; i < 7; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(110);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHMusicRankCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHMusicRankCellID forIndexPath:indexPath];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
           
        };
    }
    
    return sectionModel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
