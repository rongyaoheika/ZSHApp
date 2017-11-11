//
//  ZSHLiveProfitViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveProfitViewController.h"
#import "ZSHQuotaHeadView.h"

@interface ZSHLiveProfitViewController ()

@property (nonatomic, strong) NSArray            *pushVCsArr;
@property (nonatomic, strong) NSArray            *paramArr;
@property (nonatomic, strong) ZSHQuotaHeadView   *headerView;

@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHLiveProfitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    self.pushVCsArr = @[@"",@""];
    self.paramArr = @[@{},@{}];
    [self initViewModel];
}

- (void)createUI{
    self.title = @"黑咖币";
    NSDictionary *nextParamDic = @{@"headKeyTitle":@"直播收益",@"headValueTitle":@"500.00"};
    self.headerView = [[ZSHQuotaHeadView alloc]initWithFrame:CGRectZero paramDic:nextParamDic];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(KNavigationBarHeight+ kRealValue(25));
        make.width.and.height.mas_equalTo(floor(kRealValue(120)));
        make.centerX.mas_equalTo(self.view);
    }];
    
    NSDictionary *activeBtnDic = @{@"title":@"提现",@"font":kPingFangRegular(17)};
    UIButton *activeBtn = [ZSHBaseUIControl createBtnWithParamDic:activeBtnDic];
    [self.view addSubview:activeBtn];
    [activeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(kRealValue(140));
        make.height.mas_equalTo(kRealValue(35));
    }];
    [ZSHSpeedy zsh_chageControlCircularWith:activeBtn AndSetCornerRadius:kRealValue(35)/2 SetBorderWidth:1.0 SetBorderColor:KZSHColor929292 canMasksToBounds:YES];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(activeBtn.mas_bottom).offset(kRealValue(40));
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
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(44);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"wallet_withdraw"];
        cell.textLabel.text = @"提现记录";
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
      
    };
    return sectionModel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
