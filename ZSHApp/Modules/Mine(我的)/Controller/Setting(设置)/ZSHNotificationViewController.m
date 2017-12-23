//
//  ZSHNotificationViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHNotificationViewController.h"
#import "ZSHSimpleCellView.h"

@interface ZSHNotificationViewController ()

@property (nonatomic, strong) NSArray            *pushVCsArr;
@property (nonatomic, strong) NSArray            *paramArr;
@property (nonatomic, strong) NSArray            *titleArr;
@property (nonatomic, strong) NSArray            *detailTitleArr;

@end
static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
  if (kFromClassTypeValue == FromSettingVCToNotificationVC){
        self.titleArr = @[@"接收新消息通知",@"声音",@"震动"];
        self.detailTitleArr = @[@"UISwitch",@"UISwitch",@"UISwitch"];
  }else if (kFromClassTypeValue == FromLiveMineVCToNotificationVC){
      self.titleArr = @[@"礼物特效",@"开播提醒",@"非wifi环境下观看直播提醒"];
      self.detailTitleArr = @[@"UISwitch",@"UISwitch",@"UISwitch"];
  }
    
    [self initViewModel];
}

- (void)createUI{
    self.title = self.paramDic[@"title"];
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
        cellModel.height = (i==0? kRealValue(55):kRealValue(43));
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            if (![cell.contentView viewWithTag:2]) {
                NSDictionary *nextParamDic = @{@"leftTitle":weakself.titleArr[indexPath.row],@"rightTitle":weakself.detailTitleArr[indexPath.row],@"row":@(indexPath.row)};
                ZSHSimpleCellView *cellView = [[ZSHSimpleCellView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(43)) paramDic:nextParamDic];
                cellView.tag = 2;
                [cell.contentView addSubview:cellView];
                [cellView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(cell);
                }];
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
