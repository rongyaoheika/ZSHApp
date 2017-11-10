//
//  ZSHWithdrawViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHWithdrawViewController.h"
#import "ZSHPayView.h"
@interface ZSHWithdrawViewController ()

@property (nonatomic, strong) ZSHPayView         *payView;
@property (nonatomic, assign) NSInteger          selectedCellRow;
@property (nonatomic, strong) NSArray            *cellParamArr;
@property (nonatomic, strong) NSMutableArray     *btnArr;

@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
}

- (void)createUI{
    self.title = @"提现";
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight - KBottomNavH);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView reloadData];
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    kWeakSelf(self);
    NSDictionary *nextParamDic = @{@"title":@"提现方式"};
    _payView = [[ZSHPayView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(40)) paramDic:nextParamDic];
    [self.tableViewModel.sectionModelArray addObject:[_payView storePaySection]];
    _payView.rightBtnBlcok = ^(UIButton *btn) {
        [weakself rightBtnAction:btn];
    };
    
}

- (ZSHBaseTableViewSectionModel*)storeListSection{
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(40);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.textLabel.text = @"提现金额";
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
        return cell;
    };
    
    cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(45);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        
        UITextField *amountTextField = [[UITextField alloc]initWithFrame:CGRectZero];
        amountTextField.font = kPingFangLight(24);
        amountTextField.textColor = KZSHColor929292;
        amountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:  @"¥" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"454545"]}];
        [cell.contentView addSubview:amountTextField];
        [amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell).offset(KLeftMargin);
            make.right.mas_equalTo(cell).offset(-KLeftMargin);
            make.height.mas_equalTo(kRealValue(40));
            make.centerY.mas_equalTo(cell);
        }];
        return cell;
    };
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    
    return sectionModel;
}
#pragma action
- (void)submitBtnAction{
    
}

- (void)rightBtnAction:(UIButton *)rightBtn{
    ZSHBaseCell * cell = (ZSHBaseCell *)[[rightBtn superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    // 记录下当前的IndexPath.row
    _payView.selectedCellRow = path.row;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:path.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
