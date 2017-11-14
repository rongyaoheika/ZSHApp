//
//  ZSHPersonalDetailViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPersonalDetailViewController.h"

static NSString *PersonalDetailIdentifier = @"PersonalDetailIdentifier";

@interface ZSHPersonalDetailViewController ()

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ZSHPersonalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.titleArr = @[@"昵称", @"性别", @"生日", @"签名", @"等级"];
    self.dataArr = @[@"姜小白", @"女", @"1990年1月1日", @"你是我最重要的决定", @"1级"];
    [self initViewModel];
}

- (void)createUI{
    self.title = @"资料";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:PersonalDetailIdentifier];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    for (int i = 0; i<self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(35);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:PersonalDetailIdentifier];
            cell.textLabel.text = self.titleArr[indexPath.row];
            cell.textLabel.textColor = KZSHColor929292;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.detailTextLabel.text = self.dataArr[indexPath.row];
            cell.detailTextLabel.textColor = KZSHColor929292;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            return cell;
        };
    }
    
    return sectionModel;
}




@end
