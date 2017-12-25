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

@interface ZSHLiveClassifyViewController ()

@property (nonatomic, strong) LXScrollContentView *contentView;
@property (nonatomic, strong) LXScollTitleView    *titleView;
@property (nonatomic, strong) NSArray             *titleArr;
@property (nonatomic, strong) NSMutableArray      *vcs;
@property (nonatomic, assign) CGFloat             titleWidth;
@property (nonatomic, assign) CGFloat             indicatorHeight;
@property (nonatomic, strong) NSArray             *contentVCS;
@property (nonatomic, strong) NSArray             *paramArr;

@end

@implementation ZSHLiveClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.titleArr = @[@"黑咖美女",@"黑咖帅哥",@"黑咖达人",@"黑咖名人",@"黑咖明星"];
    self.contentVCS = @[@"ZSHLiveContentFirstViewController",@"ZSHLiveContentFirstViewController",@"ZSHLiveContentFirstViewController",@"ZSHLiveContentFirstViewController",@"ZSHLiveContentFirstViewController"];
    self.paramArr = @[@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)}];
    self.titleWidth = kRealValue(85);
}

- (void)createUI{
    self.title = self.paramDic[@"title"];
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(kRealValue(40));
        make.width.mas_equalTo(KScreenWidth);
        make.left.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
    }];
    [self reloadListData];
}

#pragma getter
- (LXScollTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, kRealValue(40))];
        _titleView.normalTitleFont = kPingFangLight(12);
        _titleView.selectedTitleFont = kPingFangLight(12);
        _titleView.selectedColor = KZSHColor929292;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = self.indicatorHeight;
        __weak typeof(self) weakSelf = self;
        _titleView.selectedBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakSelf;
            strongSelf.contentView.currentIndex = index;
        };
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.titleWidth = self.titleWidth;
    }
    return _titleView;
}

- (LXScrollContentView *)contentView{
    if (!_contentView) {
        _contentView = [[LXScrollContentView alloc] initWithFrame:CGRectMake(0,kRealValue(40) + KNavigationBarHeight, KScreenWidth,KScreenHeight - kRealValue(40) - KNavigationBarHeight  - KBottomNavH)];
        _contentView.backgroundColor = KClearColor;
        kWeakSelf(self);
        _contentView.scrollBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakself;
            strongSelf.titleView.selectedIndex = index;
        };
    }
    return _contentView;
}

- (void)reloadListData{
    [self.titleView reloadViewWithTitles:self.titleArr];
    self.vcs = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.titleArr.count; i++) {
        Class className = NSClassFromString(self.contentVCS[i]);
        RootViewController *vc  = nil;
        if (self.paramArr.count) {
            vc = [[className alloc]initWithParamDic:self.paramArr[i]];
        } else {
            vc = [[className alloc]init];
        }
        
        [self.vcs addObject:vc];
    }
    
    [self.contentView reloadViewWithChildVcs:self.vcs parentVC:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
