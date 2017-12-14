//
//  LZCartViewController.m
//  LZCartViewController
//
//  Created by LQQ on 16/5/18.
//  Copyright © 2016年 LQQ. All rights reserved.
//  https://github.com/LQQZYY/CartDemo
//  http://blog.csdn.net/lqq200912408
//  QQ交流: 302934443

#import "LZCartViewController.h"
#import "LZCartTableViewCell.h"
#import "LZShopModel.h"
#import "LZGoodsModel.h"
#import "LZTableHeaderView.h"
#import "ZSHBuyLogic.h"
#import "ZSHConfirmOrderViewController.h"

@interface LZCartViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isHiddenNavigationBarWhenDisappear;//记录当页面消失时是否需要隐藏系统导航
    BOOL _isHasTabBarController;//是否含有tabbar
    BOOL _isHasNavitationController;//是否含有导航
}

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (strong, nonatomic) UITableView    *myTableView;
@property (strong, nonatomic) UIButton       *allSellectedButton;
@property (strong, nonatomic) UILabel        *totlePriceLabel;
@property (strong, nonatomic) UIButton       *balanceBtn;
@property (nonatomic, strong) ZSHBuyLogic    *buyLogic;

@end

#define  TAG_CartEmptyView 100

static NSString *lz_BackButtonString = @"back_button";
static NSString *lz_Bottom_UnSelectButtonString = @"goods_choose_normal";
static NSString *lz_Bottom_SelectButtonString = @"goods_choose_press";
static NSString *lz_CartEmptyString = @"cart_default_bg";
static NSInteger lz_CartRowHeight = 120;


@implementation LZCartViewController

#pragma mark - viewController life cicle
- (void)viewWillAppear:(BOOL)animated {
    
    if (_isHasNavitationController == YES) {
        if (self.navigationController.navigationBarHidden == YES) {
            _isHiddenNavigationBarWhenDisappear = NO;
        } else {
            self.navigationController.navigationBarHidden = YES;
            _isHiddenNavigationBarWhenDisappear = YES;
        }
    }
    //初始化显示状态
    _allSellectedButton.selected = NO;
    _totlePriceLabel.attributedText = [self LZSetString:@"￥0.00"];
    
    //当进入购物车的时候判断是否有已选择的商品,有就清空
    //主要是提交订单后再返回到购物车,如果不清空,还会显示
//    if (self.selectedArray.count > 0) {
//        for (LZGoodsModel *model in self.selectedArray) {
//            model.select = NO;//这个其实有点多余,提交订单后的数据源不会包含这些,保险起见,加上了
//        }
//        [self.selectedArray removeAllObjects];
//    }
    [self verityAllSelectState];
    

}

-(void)creatData {
    
    
//    for (int i = 0; i < 10; i++) {
//        LZCartModel *model = [[LZCartModel alloc]init];
//        
//        model.title = [NSString stringWithFormat:@"测试数据%d",i];
//        model.price = @"100.00";
//        model.number = 1;
//        model.image = [UIImage imageNamed:@"aaa.jpg"];
//        model.dateStr = @"2016.02.18";
//        model.subTitle = @"18*20cm";
//        
//        [self.dataArray addObject:model];
//    }
    
    _buyLogic = [[ZSHBuyLogic alloc] init];
    kWeakSelf(self);
    [_buyLogic requestShoppingCartWithHonouruserID:HONOURUSER_IDValue success:^(id response) {
        LZShopModel *model = [[LZShopModel alloc]init];
        model.shopID = @"1";
        model.shopName = @"2";
        model.sID = @"sID";
        [model configGoodsArrayWithArray:response[@"pd"]];
        
        [weakself.dataArray addObject:model];
        if (weakself.myTableView != nil) {
            [weakself.myTableView reloadData];
        } else {
            [weakself setupCartView];
        }
        [weakself changeView];
    }];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"ShopCarNew" ofType:@"plist" inDirectory:nil];
//    
//    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
//    NSLog(@"%@",dic);
//    NSArray *array = [dic objectForKey:@"data"];
//    if (array.count > 0) {
//        for (NSDictionary *dic in array) {
//    LZShopModel *model = [[LZShopModel alloc]init];
//    model.shopID = @"1";
//    model.shopName = @"2";
//    model.sID = @"sID";
//    [model configGoodsArrayWithArray:[dic objectForKey:@"items"]];
//    
//            [self.dataArray addObject:model];
////        }
////    }
//    if (self.myTableView != nil) {
//        [self.myTableView reloadData];
//    } else {
//        [self setupCartView];
//    }
}
- (void)loadData {
    [self creatData];
    [self changeView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _isHasTabBarController = YES;
    _isHasNavitationController = false;
    
    self.title = @"购物车";
    
#warning 模仿请求数据,延迟2s加载数据,实际使用时请移除更换
//    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    [self loadData];

    // 自定义头部视图
//    [self setupCustomNavigationBar];
    if (self.dataArray.count > 0) {
        
        [self setupCartView];
    } else {
        [self setupCartEmptyView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_isHiddenNavigationBarWhenDisappear == YES) {
        self.navigationController.navigationBarHidden = NO;
    }
}

/**
 *  @author LQQ, 16-02-18 11:02:16
 *
 *  计算已选中商品金额
 */
-(void)countPrice {
    double totlePrice = 0.0;
    
    for (LZGoodsModel *model in self.selectedArray) {
        
        double price = [model.PROPRICE doubleValue];
        
        totlePrice += price * [model.PRODUCTCOUNT doubleValue];
    }
    NSString *string = [NSString stringWithFormat:@"￥%.2f",totlePrice];
    self.totlePriceLabel.attributedText = [self LZSetString:string];
    [self.balanceBtn setTitle:[NSString stringWithFormat:@"去结算（%zd）", self.selectedArray.count] forState:UIControlStateNormal];
}

#pragma mark - 初始化数组
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectedArray;
}

#pragma mark - 布局页面视图
#pragma mark -- 自定义导航
- (void)setupCustomNavigationBar {
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KNavigationBarHeight)];
    backgroundView.backgroundColor = KZSHColor929292;
    [self.view addSubview:backgroundView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight - 0.5, KScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"购物车";
    titleLabel.font = [UIFont systemFontOfSize:20];
    
    titleLabel.center = CGPointMake(self.view.center.x, (KNavigationBarHeight - 20)/2.0 + 20);
    CGSize size = [titleLabel sizeThatFits:CGSizeMake(300, 44)];
    titleLabel.bounds = CGRectMake(0, 0, size.width + 20, size.height);
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 20, 40, 44);
    [backButton setImage:[UIImage imageNamed:lz_BackButtonString] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}
#pragma mark -- 自定义底部视图 
- (void)setupCustomBottomView {
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = KBlackColor;
    backgroundView.tag = TAG_CartEmptyView + 1;
    [self.view addSubview:backgroundView];
    
    //当有tabBarController时,在tabBar的上面
    if (_isHasTabBarController == YES) {
        backgroundView.frame = CGRectMake(0, KScreenHeight - KNavigationBarHeight - KBottomNavH - KBottomHeight, KScreenWidth, KBottomNavH);
    } else {
        backgroundView.frame = CGRectMake(0, KScreenHeight -  KBottomNavH - KBottomHeight, KScreenWidth, KBottomNavH);
    }
    
//    UIView *lineView = [[UIView alloc]init];
//    lineView.frame = CGRectMake(0, 0, KScreenWidth, 1);
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [backgroundView addSubview:lineView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:12];
    selectAll.frame = CGRectMake(10, 5, 80, KBottomNavH - 10);
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:lz_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:lz_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectAll setTitleColor:KZSHColor929292 forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:selectAll];
    self.allSellectedButton = selectAll;
    
    //结算按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = KZSHColor141414;
    btn.frame = CGRectMake(KScreenWidth - kRealValue(120), 0, kRealValue(120), KBottomNavH);
    [btn setTitle:@"去结算" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    self.balanceBtn = btn;
    
    //合计
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = KZSHColor929292;
    [backgroundView addSubview:label];
    
    label.attributedText = [self LZSetString:@"¥0.00"];
    CGFloat maxWidth = KScreenWidth - selectAll.bounds.size.width - btn.bounds.size.width - 30;
//    CGSize size = [label sizeThatFits:CGSizeMake(maxWidth, KBottomNavH)];
    label.frame = CGRectMake(selectAll.bounds.size.width + 20, 0, maxWidth - 10, KBottomNavH);
    self.totlePriceLabel = label;
}

- (NSMutableAttributedString*)LZSetString:(NSString*)string {
    
    NSString *text = [NSString stringWithFormat:@"合计:%@",string];
    NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange rang = [text rangeOfString:@"合计:"];
    [LZString addAttribute:NSForegroundColorAttributeName value:KZSHColor929292 range:rang];
    [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rang];
    return LZString;
}
#pragma mark -- 购物车为空时的默认视图
- (void)changeView {
    if (!self.dataArray.count) return;

    LZShopModel *model = [self.dataArray objectAtIndex:0];
    if (model.goodsArray.count > 0) {
        UIView *view = [self.view viewWithTag:TAG_CartEmptyView];
        if (view != nil) {
            [view removeFromSuperview];
        }
        
        [self setupCartView];
    } else {
        UIView *bottomView = [self.view viewWithTag:TAG_CartEmptyView + 1];
        [bottomView removeFromSuperview];
        
        [self.myTableView removeFromSuperview];
        self.myTableView = nil;
        [self setupCartEmptyView];
    }
}

- (void)setupCartEmptyView {
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight - KNavigationBarHeight)];
    backgroundView.tag = TAG_CartEmptyView;
    [self.view addSubview:backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:lz_CartEmptyString]];
    img.center = CGPointMake(KScreenWidth/2.0, KScreenHeight/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.center = CGPointMake(KScreenWidth/2.0, KScreenHeight/2.0 - 10);
    warnLabel.bounds = CGRectMake(0, 0, KScreenWidth, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = @"购物车为空!";
    warnLabel.textColor = KZSHColor929292;
    warnLabel.font = [UIFont systemFontOfSize:15];
    [backgroundView addSubview:warnLabel];
}
#pragma mark -- 购物车有商品时的视图
- (void)setupCartView {
    //创建底部视图
    [self setupCustomBottomView];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    table.delegate = self;
    table.dataSource = self;
    
    table.rowHeight = lz_CartRowHeight;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = KBlackColor;
    [self.view addSubview:table];
    self.myTableView = table;
    
    if (_isHasTabBarController) {
        table.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KNavigationBarHeight - KBottomNavH - KBottomHeight);
    } else {
        table.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KNavigationBarHeight-KBottomNavH - KBottomHeight);
    }
    
    [table registerClass:[LZTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"LZHeaderView"];
}
#pragma mark --- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    LZShopModel *model = [self.dataArray objectAtIndex:section];
    return model.goodsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCell"];
    if (cell == nil) {
        cell = [[LZCartTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LZCartReusableCell"];
    }
    
    LZShopModel *shopModel = self.dataArray[indexPath.section];
    LZGoodsModel *model = [shopModel.goodsArray objectAtIndex:indexPath.row];
    
    __block typeof(cell)wsCell = cell;
    
    [cell numberAddWithBlock:^(NSInteger number) {
        wsCell.lzNumber = number;
        model.PRODUCTCOUNT = [NSString stringWithFormat:@"%ld",(long)number];
        
        [shopModel.goodsArray replaceObjectAtIndex:indexPath.row withObject:model];
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell numberCutWithBlock:^(NSInteger number) {
        
        wsCell.lzNumber = number;
        model.PRODUCTCOUNT = [NSString stringWithFormat:@"%ld",(long)number];
        
        [shopModel.goodsArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell cellSelectedWithBlock:^(BOOL select) {
        
        model.select = select;
        if (select) {
            [self.selectedArray addObject:model];
        } else {
            [self.selectedArray removeObject:model];
        }
        
        [self verityAllSelectState];
        [self verityGroupSelectState:indexPath.section];
        
        [self countPrice];
    }];
    
    [cell reloadDataWithModel:model];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    LZTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LZHeaderView"];
//    LZShopModel *model = [self.dataArray objectAtIndex:section];
//    NSLog(@">>>>>>%d", model.select);
//    view.title = model.shopName;
//    view.select = model.select;
//    view.lzClickBlock = ^(BOOL select) {
//        model.select = select;
//        if (select) {
//
//            for (LZGoodsModel *good in model.goodsArray) {
//                good.select = YES;
//                if (![self.selectedArray containsObject:good]) {
//                    
//                    [self.selectedArray addObject:good];
//                }
//            }
//            
//        } else {
//            for (LZGoodsModel *good in model.goodsArray) {
//                good.select = NO;
//                if ([self.selectedArray containsObject:good]) {
//                    
//                    [self.selectedArray removeObject:good];
//                }
//            }
//        }
//        
//        [self verityAllSelectState];
//
//        [tableView reloadData];
//        [self countPrice];
//    };
//    
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return LZTableViewHeaderHeight;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    
//    return 1;
//}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            LZShopModel *shop = [self.dataArray objectAtIndex:indexPath.section];
            LZGoodsModel *model = [shop.goodsArray objectAtIndex:indexPath.row];
            // 删除
            [_buyLogic requestShoppingCartDelWithDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue,@"PRODUCT_ID":model.PRODUCT_ID} success:^(id response) {
                
            }];
            [shop.goodsArray removeObjectAtIndex:indexPath.row];
            //    删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if (shop.goodsArray.count == 0) {
                [self.dataArray removeObjectAtIndex:indexPath.section];
            }
            
            //判断删除的商品是否已选择
            if ([self.selectedArray containsObject:model]) {
                //从已选中删除,重新计算价格
                [self.selectedArray removeObject:model];
                [self countPrice];
            }
            
            NSInteger count = 0;
            for (LZShopModel *shop in self.dataArray) {
                count += shop.goodsArray.count;
            }
            
            if (self.selectedArray.count == count) {
                _allSellectedButton.selected = YES;
            } else {
                _allSellectedButton.selected = NO;
            }
            
            if (count == 0) {
                [self changeView];
            }
            
            //如果删除的时候数据紊乱,可延迟0.5s刷新一下
            [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }

}
- (void)reloadTable {
    [self.myTableView reloadData];
}
#pragma mark -- 页面按钮点击事件
#pragma mark --- 返回按钮点击事件
- (void)backButtonClick:(UIButton*)button {
    if (_isHasNavitationController == NO) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark --- 全选按钮点击事件
- (void)selectAllBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (LZGoodsModel *model in self.selectedArray) {
        model.select = NO;
    }
    
    [self.selectedArray removeAllObjects];
    
    if (button.selected) {
        
        for (LZShopModel *shop in self.dataArray) {
            shop.select = YES;
            for (LZGoodsModel *model in shop.goodsArray) {
                model.select = YES;
                [self.selectedArray addObject:model];
            }
        }
        
    } else {
        for (LZShopModel *shop in self.dataArray) {
            shop.select = NO;
        }
    }
    
    [self.myTableView reloadData];
    [self countPrice];
}
#pragma mark --- 确认选择,提交订单按钮点击事件
- (void)goToPayButtonClick:(UIButton*)button {
    if (self.selectedArray.count > 0) {
//        for (LZGoodsModel *model in self.selectedArray) {
//            NSLog(@"选择的商品>>%@>>>%ld",model,(long)model.count);
//        }
        ZSHConfirmOrderViewController *confirmOrderVC = [[ZSHConfirmOrderViewController alloc]init];
//        confirmOrderVC.goodsModel = _goodModel;
        [self.navigationController pushViewController:confirmOrderVC animated:YES];
    } else {
        NSLog(@"你还没有选择任何商品");
    }
    
}

- (void)verityGroupSelectState:(NSInteger)section {
    
    // 判断某个区的商品是否全选
    LZShopModel *tempShop = self.dataArray[section];
    // 是否全选标示符
    BOOL isShopAllSelect = YES;
    for (LZGoodsModel *model in tempShop.goodsArray) {
        // 当有一个为NO的是时候,将标示符置为NO,并跳出循环
        if (model.select == NO) {
            isShopAllSelect = NO;
            break;
        }
    }
    
    LZTableHeaderView *header = (LZTableHeaderView *)[self.myTableView headerViewForSection:section];
    header.select = isShopAllSelect;
    tempShop.select = isShopAllSelect;
}

- (void)verityAllSelectState {
    
    NSInteger count = 0;
    for (LZShopModel *shop in self.dataArray) {
        count += shop.goodsArray.count;
    }
    
    if (self.selectedArray.count == count) {
        _allSellectedButton.selected = YES;
    } else {
        _allSellectedButton.selected = NO;
    }
}


@end
