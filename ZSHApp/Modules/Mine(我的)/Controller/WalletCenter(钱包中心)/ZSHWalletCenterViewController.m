//
//  ZSHWalletCenterViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHWalletCenterViewController.h"

@interface ZSHWalletCenterViewController ()

@property (nonatomic, strong) NSArray             *pushVCsArr;
@property (nonatomic, strong) NSArray             *paramArr;
@property (nonatomic, strong) UIView              *headerView;
@property (nonatomic, strong) NSArray             *titleArr;
@property (nonatomic, strong) NSArray             *imageArr;

@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHWalletCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    self.pushVCsArr = @[@"ZSHWithdrawViewController",@"ZSHQuotaViewController"];
    self.paramArr = @[
                      @{},
                      @{}
                      ];
    [self initViewModel];
}

- (void)createUI{
    self.title = @"钱包中心";
    [self.view addSubview:[self createHeadView]];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(KNavigationBarHeight+ kRealValue(25));
        make.width.and.height.mas_equalTo(floor(kRealValue(155)));
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(kRealValue(40));
        make.bottom.mas_equalTo(self.view);
    }];
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
    NSArray *imageArr = @[@"wallet_withdraw",@"wallet_limit"];
    NSArray *titleArr = @[@"提现",@"黑卡剩余额度"];
    for (int i = 0; i<imageArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(44);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
            cell.textLabel.text = titleArr[indexPath.row];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            Class className = NSClassFromString(weakself.pushVCsArr[indexPath.row]);
            RootViewController *vc = [[className alloc]initWithParamDic:weakself.paramArr[indexPath.row]];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    return sectionModel;
}


#pragma getter
- (UIView *)createHeadView{
    self.headerView = [[UIView alloc]initWithFrame:CGRectZero];
    self.headerView.backgroundColor = KClearColor;
    UIImageView *ringImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wallet_circle"]];
    ringImage.frame = self.headerView.bounds;
    [self.headerView addSubview:ringImage];
    [ringImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.headerView);
        make.height.and.width.mas_equalTo(self.headerView);
    }];
    
    NSDictionary *bottomDic = @{@"text":@"¥0.00",@"font":kPingFangRegular(36),@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *bottomLabel = [ZSHBaseUIControl createLabelWithParamDic:bottomDic];
    bottomLabel.adjustsFontSizeToFitWidth = YES;
    [_headerView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(ringImage);
        make.height.mas_equalTo(kRealValue(36));
        make.width.mas_equalTo(kRealValue(100));
    }];
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
