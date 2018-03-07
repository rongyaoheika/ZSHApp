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
#import "ZSHWeiboViewController.h"
#import "ZSHVideoViewController.h"
#import "ZSHPersonalDetailViewController.h"
#import "ZSHLiveLogic.h"
@interface ZSHPersonalCenterViewController ()
//头部UI
@property (nonatomic, strong) UIImageView                    *headImageView;
@property (nonatomic, strong) UILabel                        *nicknameLabel;
@property (nonatomic, strong) UILabel                        *briefLabel;
@property (nonatomic, strong) UILabel                        *followLabel;
@property (nonatomic, strong) UIButton                        *liveBtn;

@property (nonatomic, strong) LXScrollContentView            *contentView;
@property (nonatomic, strong) LXScollTitleView               *titleView;
@property (nonatomic, strong) NSMutableArray                 *vcs;
@property (nonatomic, strong) NSArray                        *titleArr;
@property (nonatomic, assign) CGFloat                        titleWidth;
@property (nonatomic, strong) NSArray                        *titleWidthArr;
@property (nonatomic, strong) NSArray<NSString *>            *contentVCS;
@property (nonatomic, strong) NSArray<NSDictionary *>        *paramArr;
@property (nonatomic, strong) ZSHLiveLogic                   *liveLogic;
@end

@implementation ZSHPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
    [self requestData];
}

- (void)loadData{
   
    self.titleArr = @[@"黑微博",@"小视频",@"资料"];
    self.titleWidth = kScreenWidth/[self.titleArr count];
//    self.titleWidthArr = @[@(kRealValue(75)),@(KScreenWidth - kRealValue(150)), @(kRealValue(75))];
    self.contentVCS = @[@"ZSHWeiboViewController",@"ZSHVideoViewController",@"ZSHPersonalDetailViewController"];
    self.paramArr = @[@{KFromClassType:@(FromPersonalVCToWeiboVC)},@{KFromClassType:@(FromPersonalVCToVideoVC)},@{KFromClassType:@(FromPersonalVCToPersonalDetailVC)}];
   
}

- (void)requestData{
    _liveLogic = [[ZSHLiveLogic alloc]init];
    [_liveLogic requestLiveUserTopDataWithDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id response) {
    
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:response[@"PORTRAIT"]]];
        _nicknameLabel.text = response[@"NICKNAME"];
        _briefLabel.text = response[@"SIGNNAME"];
        _followLabel.text = [NSString stringWithFormat:@"关注 %@ | 粉丝 %@",[response[@"focus"]stringValue] ,[response[@"fans"]stringValue]];
    }];
}

- (void)createUI{
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_center_1"]];
    [self.view addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, kRealValue(200)));
    }];
    _headImageView = headImageView;

    UILabel *nicknameLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"姜小白",@"font":kPingFangMedium(15),@"textColor":KWhiteColor}];
    [self.view addSubview:nicknameLabel];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(95));
        make.left.mas_equalTo(self.view).offset(kRealValue(15));
        make.size.mas_equalTo(CGSizeMake(KScreenWidth*0.7, kRealValue(17)));
    }];
    _nicknameLabel = nicknameLabel;
    
    UILabel *briefLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"你还没填写个人说明",@"font":kPingFangRegular(12),@"textColor":KWhiteColor}];
    [self.view addSubview:briefLabel];
    [briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nicknameLabel);
        make.top.mas_equalTo(nicknameLabel).offset(kRealValue(25));
        make.size.mas_equalTo(CGSizeMake(KScreenWidth*0.7, kRealValue(17)));
    }];
    _briefLabel = briefLabel;
    
    UILabel *followLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"关注 42 | 粉丝 6.3万",@"font":kPingFangRegular(12),@"textColor":KWhiteColor}];
    [self.view addSubview:followLabel];
    [followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(briefLabel);
        make.top.mas_equalTo(briefLabel).offset(kRealValue(24));
        make.size.mas_equalTo(CGSizeMake(KScreenWidth*0.7, kRealValue(13)));
    }];
    _followLabel = followLabel;
    
    
    UIButton *liveBtn = [ZSHBaseUIControl  createBtnWithParamDic:@{@"title":@"直播中",@"titleColor":KBlackColor,@"font":kPingFangRegular(11),@"normalImage":@"personal_center_2"} target:self action:nil];
    liveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:liveBtn];
    [liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(120));
        make.right.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kRealValue(55), kRealValue(20)));
    }];
    _liveBtn = liveBtn;
    
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
    [self.titleView reloadViewWithTitles:self.titleArr];
    self.vcs = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.titleArr.count; i++) {
        Class className = NSClassFromString(self.contentVCS[i]);
        RootViewController *vc = [[className alloc] initWithParamDic:self.paramArr[i]];
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
