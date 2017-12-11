//
//  ZSHAccountViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHAccountViewController.h"
#import "ZSHMultiInfoViewController.h"

@interface ZSHAccountViewController ()

@property (nonatomic, strong) NSArray            *pushVCsArr;
@property (nonatomic, strong) NSArray            *paramArr;
@property (nonatomic, strong) NSArray            *titleArr;

@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.titleArr = @[@"登录密码",@"支付密码",@"指纹支付"];
    self.pushVCsArr = @[@"ZSHMultiInfoViewController",@"",@""];
    // @{KFromClassType:@(FromAccountVCToMultiInfoVC),@"title":@"找回登录密码"},
    self.paramArr = @[@{KFromClassType:@(FromUserPasswordVCToMultiInfoVC),@"title":@"更改登录密码",@"bottomBtnTitle":@"提交"},@{KFromClassType:@""},@{}];
    [self initViewModel];
}

- (void)createUI{
    self.title = @"账号与安全";
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, kScreenWidth, kScreenHeight - KNavigationBarHeight);
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<self.titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(43);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.titleArr[indexPath.row];
            if (i == self.titleArr.count - 1) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            Class className = NSClassFromString(self.pushVCsArr[indexPath.row]);
            RootViewController *vc = [[className alloc]initWithParamDic:weakself.paramArr[indexPath.row]];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
