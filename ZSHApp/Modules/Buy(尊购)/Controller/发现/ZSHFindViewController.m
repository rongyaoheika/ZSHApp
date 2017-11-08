//
//  ZSHFindViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFindViewController.h"

@interface ZSHFindViewController ()

@end

@implementation ZSHFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self loadData];
//    [self createUI];
}

//- (void)loadData{
//    
//    [self initViewModel];
//    
//}
//
//- (void)createUI{
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
//    self.tableView.delegate = self.tableViewModel;
//    self.tableView.dataSource = self.tableViewModel;
//    
//    [self.tableView reloadData];
//    
//}
//
//- (void)initViewModel {
//    [self.tableViewModel.sectionModelArray removeAllObjects];
//    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
//    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
//}
//
////head
//- (ZSHBaseTableViewSectionModel*)storeHeadSection {
//    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
//    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
//    [sectionModel.cellModelArray addObject:cellModel];
//    cellModel.height = kRealValue(175);
//    __block  CGFloat cellHeight = cellModel.height;
//    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_headCell];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                          reuseIdentifier:Identify_headCell];
//        }
//        cell.backgroundColor = KClearColor;
//        UIImage *image = [UIImage imageNamed:@"buy_banner1"];
//        ZSHCycleScrollView *cellView = [[ZSHCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, cellHeight)];
//        cellView.scrollDirection =  ZSHCycleScrollViewHorizontal;
//        cellView.dataArr = [@[image,image,image]mutableCopy];
//        [cell.contentView addSubview:cellView];
//        return cell;
//    };
//    
//    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        RLog(@"点击了该行%ld",indexPath.row);
//    };
//    return sectionModel;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
