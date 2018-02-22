//
//  ZSHLiveClassifyViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveClassifyViewController.h"
#import "LXScrollContentView.h"
#import "LXScollTitleView.h"
#import "ZSHLiveContentFirstViewController.h"
#import "ZSHLiveLogic.h"


@interface ZSHLiveClassifyViewController ()

@property (nonatomic, strong) LXScrollContentView *contentView;
@property (nonatomic, strong) LXScollTitleView    *topTitleView;
@property (nonatomic, strong) LXScollTitleView    *bottomTitleView;
@property (nonatomic, strong) NSArray             *topTitleArr;
@property (nonatomic, strong) NSArray             *bottomTitleArr;
@property (nonatomic, strong) NSMutableArray      *vcs;
@property (nonatomic, assign) CGFloat             titleWidth;
@property (nonatomic, assign) CGFloat             indicatorHeight;
@property (nonatomic, strong) NSArray             *contentVCS;
@property (nonatomic, strong) NSArray             *paramArr;
@property (nonatomic, strong) NSArray             *topTypeArr;
@property (nonatomic, strong) NSArray             *bottomTypeArr;
@property (nonatomic, strong) ZSHLiveLogic        *liveLogic;

@end

@implementation ZSHLiveClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    [self createUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.topTitleArr.count ||!self.topTitleArr) {
        [self requestTypeData];
    }
    
}

- (void)loadData{
    
    _liveLogic = [[ZSHLiveLogic alloc]init];
//    [self requestTypeData];
    
//    self.topTitleArr = @[@"黑咖美女",@"黑咖帅哥",@"黑咖达人",@"黑咖名人",@"黑咖明星"];
//    self.contentVCS = @[@"ZSHLiveContentFirstViewController",@"ZSHLiveContentFirstViewController",@"ZSHLiveContentFirstViewController",@"ZSHLiveContentFirstViewController",@"ZSHLiveContentFirstViewController"];
//    self.paramArr = @[@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)}];
//    self.titleWidth = kRealValue(85);
}

- (void)createUI{
    self.title = self.paramDic[@"title"];
    [self.view addSubview:self.topTitleView];
    [self.topTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(kRealValue(40));
        make.width.mas_equalTo(KScreenWidth);
        make.left.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.bottomTitleView];
    [self.bottomTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topTitleView.mas_bottom);
        make.height.mas_equalTo(kRealValue(40));
        make.width.mas_equalTo(KScreenWidth);
        make.left.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomTitleView.mas_bottom);
        make.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
    }];
    
}

#pragma getter
- (LXScollTitleView *)topTitleView{
    if (!_topTitleView) {
        _topTitleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, kRealValue(40))];
        _topTitleView.normalTitleFont = kPingFangLight(12);
        _topTitleView.selectedTitleFont = kPingFangLight(12);
        _topTitleView.selectedColor = KZSHColor929292;
        _topTitleView.normalColor = KZSHColor929292;
        _topTitleView.indicatorHeight = self.indicatorHeight;
        __weak typeof(self) weakSelf = self;
        _topTitleView.selectedBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakSelf;
            strongSelf.contentView.currentIndex = index;
        };
        _topTitleView.backgroundColor = [UIColor clearColor];
        _topTitleView.titleWidth = kRealValue(85);
    }
    return _topTitleView;
}

- (LXScrollContentView *)contentView{
    if (!_contentView) {
        _contentView = [[LXScrollContentView alloc] initWithFrame:CGRectMake(0,kRealValue(80) + KNavigationBarHeight, KScreenWidth,KScreenHeight - kRealValue(40) - KNavigationBarHeight  - KBottomNavH)];
        _contentView.backgroundColor = KClearColor;
        kWeakSelf(self);
        _contentView.scrollBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakself;
            strongSelf.topTitleView.selectedIndex = index;
        };
    }
    return _contentView;
}

- (LXScollTitleView *)bottomTitleView{
    if (!_bottomTitleView) {
        _bottomTitleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, kRealValue(80) + KNavigationBarHeight, KScreenWidth, kRealValue(40))];
        _bottomTitleView.normalTitleFont = kPingFangLight(12);
        _bottomTitleView.selectedTitleFont = kPingFangLight(12);
        _bottomTitleView.selectedColor = KZSHColor929292;
        _bottomTitleView.normalColor = KZSHColor929292;
        _bottomTitleView.indicatorHeight = self.indicatorHeight;
        __weak typeof(self) weakSelf = self;
        _bottomTitleView.selectedBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakSelf;
            strongSelf.contentView.currentIndex = index;
        };
        _bottomTitleView.backgroundColor = [UIColor clearColor];
        _bottomTitleView.titleWidth = kRealValue(85);
    }
    return _bottomTitleView;
}

- (void)reloadListData{
    [self.topTitleView reloadViewWithTitles:self.topTitleArr];
    [self.bottomTitleView reloadViewWithTitles:self.bottomTitleArr];
    
    
    self.vcs = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.bottomTypeArr.count; i++) {//根据二级titleView
        ZSHLiveContentFirstViewController *liveFirstVC = [[ZSHLiveContentFirstViewController alloc]initWithParamDic:@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC),@"LIVETYPE_ID":_bottomTypeArr[i][@"LIVETYPE_ID"]}];
        [self.vcs addObject:liveFirstVC];
    }
    
    [self.contentView reloadViewWithChildVcs:self.vcs parentVC:self];
}

- (void)requestTypeData{
  
    //第一级titleview
    NSMutableArray *topTitleMArr = [[NSMutableArray alloc]init];
    [_liveLogic requestkUrlGetLiveTypeListWithDic:nil success:^(id response) {
        _topTypeArr = response[@"pd"];;
        for (NSDictionary *dic in _topTypeArr) {
            [topTitleMArr addObject:dic[@"NAME"]];
        }
        _topTitleArr = topTitleMArr;
        
        //第二级titleview
        NSMutableArray *bottomTitleMArr = [[NSMutableArray alloc]init];
        NSDictionary *paraDic = @{@"PARENT_ID":_topTypeArr[0][@"LIVETYPE_ID"]};
        [_liveLogic requestkUrlGetLiveTypeListWithDic:paraDic success:^(id response) {
            _bottomTypeArr = response[@"pd"];
            for (NSDictionary *dic in _bottomTypeArr) {
                [bottomTitleMArr addObject:dic[@"NAME"]];
            }
            _bottomTitleArr = bottomTitleMArr;
            [self reloadListData];
        }];
        
       
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
