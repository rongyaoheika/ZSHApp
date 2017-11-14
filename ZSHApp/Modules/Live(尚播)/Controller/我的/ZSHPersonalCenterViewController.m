//
//  ZSHPersonalCenterViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPersonalCenterViewController.h"
#import "LXScollTitleView.h"
#import "LXScrollContentView.h"

@interface ZSHPersonalCenterViewController ()

@property (nonatomic, strong) LXScrollContentView            *contentView;
@property (nonatomic, strong) LXScollTitleView               *titleView;
@property (nonatomic, strong) NSMutableArray                 *vcs;
@property (nonatomic, strong) NSArray                        *titleArr;
@property (nonatomic, assign) CGFloat                        titleWidth;
@property (nonatomic, strong) NSArray                        *contentVCS;

@end

@implementation ZSHPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    self.titleArr = @[@"黑微博",@"小视频",@"资料"];
    self.titleWidth = kScreenWidth/[self.titleArr count];
    self.contentVCS = @[@"ZSHWeiboViewController",@"ZSHVideoViewController",@"ZSHPersonalDetailViewController"];
    
}

- (void)createUI{
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_center_1"]];
    [self.view addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, kRealValue(200)));
    }];

    UILabel *nicknameLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"姜小白",@"font":kPingFangMedium(15),@"textColor":KWhiteColor,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self.view addSubview:nicknameLabel];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(95));
        make.left.mas_equalTo(self.view).offset(kRealValue(15));
        make.size.mas_equalTo(CGSizeMake(kRealValue(50), kRealValue(17)));
    }];
    
    UILabel *briefLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"你还没填写个人说明",@"font":kPingFangRegular(12),@"textColor":KWhiteColor,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self.view addSubview:briefLabel];
    [briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nicknameLabel);
        make.top.mas_equalTo(nicknameLabel).offset(kRealValue(25));
        make.size.mas_equalTo(CGSizeMake(kRealValue(120), kRealValue(17)));
    }];
    
    UILabel *followLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"关注 42 | 粉丝 6.3万",@"font":kPingFangRegular(12),@"textColor":KWhiteColor,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self.view addSubview:followLabel];
    [followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(briefLabel);
        make.top.mas_equalTo(briefLabel).offset(kRealValue(24));
        make.size.mas_equalTo(CGSizeMake(kRealValue(130), kRealValue(13)));
    }];
    
    
    UIButton *liveBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"直播中",@"titleColor":KBlackColor,@"font":kPingFangRegular(11)}];
    liveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [liveBtn setBackgroundImage:[UIImage imageNamed:@"personal_center_2"] forState:UIControlStateNormal];
    [self.view addSubview:liveBtn];
    [liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(120));
        make.right.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kRealValue(55), kRealValue(20)));
    }];
    
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImageView.mas_bottom);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kRealValue(KScreenWidth), kRealValue(40)));
    }];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
    [self reloadListData];
}


- (void)reloadListData{
    [self.titleView reloadViewWithTitles:self.titleArr image:nil];
    self.vcs = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.titleArr.count; i++) {
        Class className = NSClassFromString(self.contentVCS[i]);
        RootViewController *vc =  [[className alloc]init];
        [self.vcs addObject:vc];
    }
    
    [self.contentView reloadViewWithChildVcs:self.vcs parentVC:self];
}


- (LXScollTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] init];
        _titleView.normalTitleFont = kPingFangMedium(15);
        _titleView.selectedTitleFont = kPingFangMedium(16);
        _titleView.normalColor = KZSHColor929292;
        _titleView.selectedColor = KWhiteColor;
        _titleView.indicatorHeight = 0;
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
        _contentView = [[LXScrollContentView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = KClearColor;
        kWeakSelf(self);
        _contentView.scrollBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakself;
            strongSelf.titleView.selectedIndex = index;
        };
    }
    return _contentView;
}


@end
