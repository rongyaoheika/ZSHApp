//
//  ZSHActivityViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHActivityViewController.h"
#import "ZSHEnterTainmentCell.h"
#import "ZSHEntertainmentModel.h"
#import "ZSHTogetherLogic.h"
#import "ZSHEntertainmentDetailViewController.h"


@interface ZSHActivityViewController ()

@property (nonatomic, strong) ZSHTogetherLogic         *togetherLogic;

@end

static NSString *ZSHEnterTainmentCellID = @"ZSHEnterTainmentCell";

@implementation ZSHActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
    
    _togetherLogic = [[ZSHTogetherLogic alloc] init];
    [self requestData];
}

- (void)createUI{
    self.title = @"活动中心";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHEnterTainmentCell class] forCellReuseIdentifier:ZSHEnterTainmentCellID];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
    lineView.backgroundColor = KZSHColor1D1D1D;
    [self.view addSubview:lineView];
    
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
    for (int i = 0; i<_togetherLogic.entertainModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(250);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHEnterTainmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHEnterTainmentCellID];
            cell.fromClassType = ZSHFromActivityVCToEnterTainmentCell;
            [cell updateCellWithModel:weakself.togetherLogic.entertainModelArr[indexPath.row]];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHEntertainmentDetailViewController *enterTainMentDetailVC = [[ZSHEntertainmentDetailViewController alloc]initWithParamDic:@{@"CONVERGEDETAIL_ID":weakself.togetherLogic.entertainModelArr[indexPath.row].CONVERGEDETAIL_ID}];
            [weakself.navigationController pushViewController:enterTainMentDetailVC animated:YES];
        };
    }
    return sectionModel;
}



- (void)requestData {
    kWeakSelf(self);
    [_togetherLogic requestPartyListWithDic:@{@"CONVERGE_ID":@"", @"HONOURUSER_ID":@"d6a3779de8204dfd9359403f54f7d27c", @"STATUS":self.paramDic[@"STATUS"]} success:^(id response) {
        [weakself initViewModel];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
    }];
}

- (void)headerRereshing{
    [self requestData];
}

- (void)footerRereshing{
    [self requestData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
