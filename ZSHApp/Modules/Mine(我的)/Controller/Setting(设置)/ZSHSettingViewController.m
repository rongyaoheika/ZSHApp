//
//  ZSHSettingViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSettingViewController.h"


@interface ZSHSettingViewController ()
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
}

@property (nonatomic, strong) NSArray                 *pushVCsArr;
@property (nonatomic, strong) NSArray                 *paramArr;
@property (nonatomic, strong) NSArray                 *titleArr;

@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.titleArr = @[@"个人资料",@"新消息通知",@"账号与安全",@"关于我们",@"退出当前帐号"];
    self.pushVCsArr = @[@"ZSHUserInfoViewController",@"ZSHNotificationViewController",@"ZSHAccountViewController",@"",@""];
    self.paramArr = @[@{},@{KFromClassType:@(FromSettingVCToNotificationVC),@"title":@"新消息通知"},@{KFromClassType:@""},@{},@""];
    [self initViewModel];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
}

- (void)createUI{
    self.title = @"设置";
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
