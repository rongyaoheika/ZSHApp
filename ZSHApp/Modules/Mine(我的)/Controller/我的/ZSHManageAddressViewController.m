//
//  ZSHManageAddressViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHManageAddressViewController.h"
#import "ZSHBaseCell.h"
#import "ZSHPickView.h"
#import "ZSHManageAddressListViewController.h"
#import "FXBlurView.h"

@interface ZSHManageAddressViewController ()

@property (nonatomic,strong)NSArray                   *titleArr;
@property (nonatomic,strong)ZSHPickView               *pickView;
@property (nonatomic,strong)NSArray                   *vcArr;
@end

@implementation ZSHManageAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    self.titleArr = @[@"收货人",@"联系电话",@"所在地区",@"详细地址"];
    self.vcArr = @[@"ZSHManageAddressListViewController",@""];
    
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight-KBottomNavH);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self initViewModel];
    [self.tableView reloadData];
}

- (void)createUI{
    self.title = @"收货地址管理";
    [self addNavigationItemWithTitles:@[@"保存"] isLeft:NO target:self action:@selector(saveAction) tags:@[@(1)]];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<self.titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(44);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
            if (!cell) {
                cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"cellId"];
            }
            cell.backgroundColor = KClearColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = weakself.titleArr[indexPath.row];
            cell.textLabel.font = kPingFangRegular(14);
            cell.textLabel.textColor = KZSHColor929292;
            if (indexPath.row == 2) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            if (indexPath.row == 2 ) {
                weakself.pickView = [weakself createPickViewWithType:WindowRegion];
                [weakself.pickView show:WindowRegion];
            } else if (indexPath.row == 0){
                ZSHManageAddressListViewController *manageAddressListVC = [[ZSHManageAddressListViewController alloc]init];
                [self.navigationController pushViewController:manageAddressListVC animated:YES];
            }
            
        };
    }
    
    return sectionModel;
}


#pragma pickView
-(ZSHPickView *)createPickViewWithType:(NSUInteger)type{
   NSArray *regionArr = @[@[@"北京",@"天津市",@"河北省",@"山东省"],
                          @[@"北京市",@"天津市",@"石家庄",@"聊城市"],
                          @[@"朝阳区",@"天津市",@"北辰区",@"聊城市"]
                       ];
    NSDictionary *nextParamDic = @{@"type":@(type),@"midTitle":@"城市区域选择",@"dataArr":regionArr};
    _pickView = [[ZSHPickView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) paramDic:nextParamDic];
    _pickView.controller = self;
    return _pickView;
}

#pragma action
- (void)saveAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
