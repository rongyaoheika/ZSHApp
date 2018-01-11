//
//  RootViewController.m
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "ZSHLoginViewController.h"
#import <UShareUI/UShareUI.h>
#import "UIImage+BlurGlass.h"
#import "PYSearchViewController.h"
#import "ZSHBaseTableView.h"
@interface RootViewController ()

@property (nonatomic,strong) UIImageView        *noDataView;
@property (nonatomic, weak)  UITextField        *searchTextField;
@end

@implementation RootViewController

- (instancetype)initWithParamDic:(NSDictionary *)paramDic{
    self = [super init];
    if (self) {
        self.paramDic = paramDic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = KClearColor;

    //是否显示返回按钮
    self.isShowLiftBack = YES;
    self.StatusBarStyle = UIStatusBarStyleLightContent;
    self.tableViewModel = [[ZSHBaseTableViewModel alloc] init];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_bg"]];
    image.frame = self.view.bounds;
    [self.view insertSubview:image atIndex:0];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [((RootNavigationController *)self.navigationController) setupTransparentStyle];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [((RootNavigationController *)self.navigationController) setupMainStype];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return _StatusBarStyle;
}

//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
    _StatusBarStyle=StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}


- (void)loadData{
    
}

- (void)createUI{
    
}

#pragma mark ————— 跳转登录界面 —————
- (void)goLogin
{
    RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[ZSHLoginViewController new]];
    [self presentViewController:loginNavi animated:YES completion:nil];
}

- (void)goLoginWithPush
{
    [self.navigationController pushViewController:[ZSHLoginViewController new] animated:YES];
}

- (void)showShouldLoginPoint{
    
}

- (void)showLoadingAnimation
{
    
}

- (void)stopLoadingAnimation
{
    
}

-(void)showNoDataImage
{
    _noDataView=[[UIImageView alloc] init];
    [_noDataView setImage:[UIImage imageNamed:@"generl_nodata"]];
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            [_noDataView setFrame:CGRectMake(0, 0,obj.frame.size.width, obj.frame.size.height)];
            [obj addSubview:_noDataView];
        }
    }];
}

-(void)removeNoDataImage{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}



/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = KClearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollsToTop = YES;
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = NO;
        _tableView.mj_header = header;
        
        //底部刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        _tableView.tableFooterView = [[UIView alloc] init];

        
    }
    return _tableView;
}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth , KScreenHeight) collectionViewLayout:flow];
        _collectionView.backgroundColor = KClearColor;
        _collectionView.scrollsToTop = YES;
        
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(collectionHeaderRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = NO;
        _collectionView.mj_header = header;
        
        //底部刷新
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(collectionFooterRereshing)];
        
    }
    return _collectionView;
}

- (ZSHSearchBarView *)searchView{
    if (!_searchView) {
        _searchView = [[ZSHSearchBarView alloc]initWithFrame:CGRectMake(kRealValue(5), kRealValue(7), kRealValue(270), kRealValue(28))];
    }
    return _searchView;
}

- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        NSDictionary *bottomBtnDic = @{@"title":@"申请售后",@"titleColor":KZSHColor929292,@"font":kPingFangMedium(17),@"backgroundColor":KZSHColor0B0B0B};
       _bottomBtn = [ZSHBaseUIControl createBtnWithParamDic:bottomBtnDic];
       _bottomBtn.frame = CGRectMake(0, KScreenHeight - KBottomTabH, KScreenWidth, KBottomNavH);
    }
    return _bottomBtn;
}

- (void)headerRereshing{
    [self.tableView.mj_header endRefreshing];
}

- (void)footerRereshing{
    
}

- (void)endTabViewRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)endCollectionViewRefresh{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)collectionHeaderRereshing {
    [self.collectionView.mj_header endRefreshing];
}

- (void)collectionFooterRereshing {
    [self.collectionView.mj_footer endRefreshing];
}

/**
 *  是否显示返回按钮
 */
- (void) setIsShowLiftBack:(BOOL)isShowLiftBack
{
    _isShowLiftBack = isShowLiftBack;
    NSInteger VCCount = self.navigationController.viewControllers.count;
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
        //        [self addNavigationItemWithTitles:@[@"返回"] isLeft:YES target:self action:@selector(backBtnClicked) tags:nil];
        
        [self addNavigationItemWithImageName:@"nav_back" isLeft:YES target:self  action:@selector(backBtnClicked) tag:0];
        
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}

- (void)backBtnClicked {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addNavigationItemWithImageName:(NSString *)imageName title:(NSString *)title locate:(XYButtonEdgeInsetsStyle)imageLocate isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tag:(NSInteger)tag {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:KZSHColor929292 forState:UIControlStateNormal];
    btn.titleLabel.font = kPingFangMedium(14);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.size = CGSizeMake(44, 44);
    [btn layoutButtonWithEdgeInsetsStyle:imageLocate imageTitleSpace:kRealValue(4)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (isLeft) {
        spaceButtonItem.width = -15;
        self.navigationItem.leftBarButtonItems = @[spaceButtonItem, item];
        
    } else {
        spaceButtonItem.width = -15;
        self.navigationItem.rightBarButtonItems = @[spaceButtonItem, item];
    }

}

- (void)addNavigationItemWithImageName:(NSString *)imageName isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tag:(NSInteger)tag {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
#ifdef __IPHONE_11_0
    if (@available(ios 11.0,*)) {
        if (isLeft) {
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, kRealValue(-5),0,0)];
        } else {
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, kRealValue(5),0,0)];
        }
    }
#endif
   
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = @[item];
    } else {
        self.navigationItem.rightBarButtonItems = @[item];
    }
    
    
}

- (void)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    
    NSMutableArray * items = [[NSMutableArray alloc] init];

    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width= -10;
    [items addObject:spaceItem];
    
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 0, 44, 44);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = kPingFangLight(12);
        [btn setTitleColor:KZSHColor929292 forState:UIControlStateNormal];
        btn.tag = [tags[i++] integerValue];
#ifdef __IPHONE_11_0
        if (@available(ios 11.0,*)) {
            if (isLeft) {
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, kRealValue(-5),0,0)];
            } else {
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, kRealValue(5),0,0)];
            }
        }
#endif
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

//取消请求
- (void)cancelRequest
{
    
}

- (void)dealloc
{
    [self cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    // 是否支持旋转
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认进去类型
    return   UIInterfaceOrientationPortrait;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetToShow = 200.0;
    CGFloat alpha = 1 - (offsetToShow - scrollView.contentOffset.y) / offsetToShow;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIImage *img = [UIImage imageWithColor:[KZSHColor0B0B0B colorWithAlphaComponent:alpha] AndSize:CGSizeMake(kScreenWidth, KNavigationBarHeight)];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    //取消headerview的粘性
    if (scrollView == self.tableView) {
        CGFloat sectionHeaderHeight = 36;
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}


- (void)bottomButtonClick:(UIButton *)btn{
    if (self.bottomBtnViewBtnBlock) {
        self.bottomBtnViewBtnBlock(btn.tag);
    }
}

- (void) showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void) hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
