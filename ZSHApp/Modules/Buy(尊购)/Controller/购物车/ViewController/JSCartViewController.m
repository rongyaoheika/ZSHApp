//
//  JSCartViewController.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/9.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "JSCartViewController.h"
#import "JSCartUIService.h"
#import "JSCartViewModel.h"
#import "JSCartBar.h"

@interface JSCartViewController ()

@property (nonatomic, strong) JSCartUIService *service;
@property (nonatomic, strong) JSCartViewModel *viewModel;
@property (nonatomic, strong) UITableView     *cartTableView;
@property (nonatomic, strong) JSCartBar       *cartBar;
@property (nonatomic, assign) BOOL            isIdit;

@end

@implementation JSCartViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self getNewData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    
    /*add view*/
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight);
    [ self.tableView registerNib:[UINib nibWithNibName:@"JSCartCell" bundle:nil]
         forCellReuseIdentifier:@"JSCartCell"];
     self.tableView.dataSource = self.service;
     self.tableView.delegate   = self.service;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.cartBar];
    
    /* RAC  */
     kWeakSelf(self);
    //全选
    [[self.cartBar.selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
        [weakself.viewModel selectAll:x.selected];
    }];
    //删除
    [[self.cartBar.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        [weakself.viewModel deleteGoodsBySelect];
    }];
    //结算
    [[self.cartBar.balanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        
    }];
    /* 观察价格属性 */
   
    [RACObserve(self.viewModel, allPrices) subscribeNext:^(NSNumber *x) {

        weakself.cartBar.money = x.floatValue;
    }];
    
    /* 全选 状态 */
    RAC(self.cartBar.selectAllButton,selected) = RACObserve(self.viewModel, isSelectAll);
    
    /* 购物车数量 */
    [RACObserve(self.viewModel, cartGoodsCount) subscribeNext:^(NSNumber *x) {
        if(x.integerValue == 0){
//            self.title = [NSString stringWithFormat:@"购物车"];
        } else {
//            self.title = [NSString stringWithFormat:@"购物车(%@)",x];
        }
    }];
}


#pragma mark - lazy load

- (JSCartViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[JSCartViewModel alloc] init];
        _viewModel.cartVC = self;
        _viewModel.cartTableView  = self.cartTableView;
    }
    return _viewModel;
}


- (JSCartUIService *)service{
    
    if (!_service) {
        _service = [[JSCartUIService alloc] init];
        _service.viewModel = self.viewModel;
    }
    return _service;
}

- (JSCartBar *)cartBar{
    
    if (!_cartBar) {
        _cartBar = [[JSCartBar alloc] initWithFrame:CGRectMake(0, KScreenHeight-49, KScreenWidth, 49)];
        _cartBar.isNormalState = YES;
    }
    return _cartBar;
}

#pragma mark - method

- (void)getNewData{
    /**
     *  获取数据
     */
    [self.viewModel getData];
    [self.cartTableView reloadData];
}

- (void)editClick:(UIBarButtonItem *)item{
    _isIdit = !_isIdit;
    NSString *itemTitle = _isIdit == YES?@"完成":@"编辑";
    item.title = itemTitle;
    self.cartBar.isNormalState = !_isIdit;
}

- (void)makeNewData:(UIBarButtonItem *)item{
    
    [self getNewData];
}

@end
