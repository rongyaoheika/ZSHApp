//
//  ZSHCoinViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCoinViewController.h"
#import "ZSHQuotaHeadView.h"
#import "ZSHLiveProfitViewController.h"
@interface ZSHCoinViewController ()

@property (nonatomic, strong) ZSHQuotaHeadView    *headerView;
@property (nonatomic, strong) NSArray             *pushVCsArr;
@property (nonatomic, strong) NSArray             *paramArr;

@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    self.pushVCsArr = @[@"ZSHLiveProfitViewController",@""];
    self.paramArr = @[@{@"value":self.paramDic[@"value"]},@{}];
    [self initViewModel];
}

- (void)createUI{
    self.title = @"黑卡币";
    
    NSDictionary *nextParamDic = @{@"headKeyTitle":@"黑卡币余额",@"headValueTitle":self.paramDic[@"value"]};
    self.headerView = [[ZSHQuotaHeadView alloc]initWithFrame:CGRectZero paramDic:nextParamDic];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(KNavigationBarHeight+ kRealValue(25));
        make.width.and.height.mas_equalTo(floor(kRealValue(120)));
        make.centerX.mas_equalTo(self.view);
    }];
    
    NSDictionary *activeBtnDic = @{@"title":@"充值",@"font":kPingFangRegular(17)};
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
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *imageArr = @[@"wallet_profit",@"wallet_record"];
    NSArray *titleArr = @[@"直播收益",@"充值记录"];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
