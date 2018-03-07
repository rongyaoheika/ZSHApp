//
//  ZSHRewardViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHRewardViewController.h"
#import "ZSHPayView.h"

@interface ZSHRewardViewController ()

@property (nonatomic, strong) ZSHPayView *payView;
@property (nonatomic, strong) UIButton   *nextStepBtn;

@end

@implementation ZSHRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
}

- (void)createUI{
    self.title = @"请选择打赏金额";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(167, 0, 0, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView reloadData];
    self.tableView.scrollEnabled = NO;
    
    [self createTableViewHeadView];
    [self createBottomButton];
}

- (void)createBottomButton {
    NSDictionary *nextStepDic = @{@"title":@"下一步",@"font":kPingFangMedium(17),@"backgroundColor":KBlackColor};
    _nextStepBtn = [ZSHBaseUIControl  createBtnWithParamDic:nextStepDic target:self action:nil];
    [self.view addSubview:_nextStepBtn];
    [_nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(kRealValue(KScreenWidth));
        make.height.mas_equalTo(kRealValue(49));
    }];
}

- (void)createTableViewHeadView {
    NSArray *titleArr = @[@"5元", @"10元", @"30元", @"50元", @"100元"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 10.0;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [KZSHColor929292 CGColor];
        btn.titleLabel.font = kPingFangRegular(14);
        [btn setTitleColor:KZSHColor929292 forState:UIControlStateNormal];
        btn.tag = i+10;
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset((i/3) * (20+20) + 78.5);
            make.left.mas_equalTo(self.view).offset(((i%3)*(58.75+62.5)+35));
            make.width.mas_equalTo(kRealValue(62.5));
            make.height.mas_equalTo(kRealValue(21));
        }];
    }
}

- (void)headBtnClick:(UIButton *)sender {
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    
    kWeakSelf(self);
    NSDictionary *nextParamDic = @{@"title":@"支付方式"};
    _payView = [[ZSHPayView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(40)) paramDic:nextParamDic];
    [self.tableViewModel.sectionModelArray addObject:[_payView storePaySection]];
    _payView.rightBtnBlcok = ^(UIButton *btn) {
        [weakself rightBtnAction:btn];
    };
}


#pragma action
- (void)rightBtnAction:(UIButton *)rightBtn{
    ZSHBaseCell * cell = (ZSHBaseCell *)[[rightBtn superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    // 记录下当前的IndexPath.row
    _payView.selectedCellRow = path.row;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:path.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

@end
