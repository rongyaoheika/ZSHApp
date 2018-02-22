//
//  ZSHFinishShowViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFinishShowViewController.h"
#import "ZSHBottomBlurPopView.h"

@interface ZSHFinishShowViewController ()

@property (nonatomic, strong)  ZSHBottomBlurPopView     *bottomBlurPopView;

@end

@implementation ZSHFinishShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
}

- (void)createUI{
    self.view.backgroundColor = [UIColor redColor];
    self.isShowLiftBack = false;
    self.isHidenNaviBar = true;
    
    UIButton *listButton = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"贡献榜  5678",@"titleColor":KBlackColor,@"font":kPingFangRegular(10),@"backgroundColor":KZSHColorD8D8D8}];
    listButton.layer.cornerRadius = 10;
    listButton.hidden = YES;
    [self.view addSubview:listButton];
    [listButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(72.5));
        make.right.mas_equalTo(self.view).offset(kRealValue(-KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(75), kRealValue(21)));
    }];
    
    
    UILabel *finishLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"直播结束",@"font":kPingFangRegular(26),@"textColor":KWhiteColor,@"textAlignment":@(NSTextAlignmentCenter)}];
    [self.view addSubview:finishLabel];
    [finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(200));
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kRealValue(110), kRealValue(38)));
    }];
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"23097人看过"];
    [str addAttributes:@{NSFontAttributeName:kGeorgia(16),
                         NSForegroundColorAttributeName:KZSHColorFF2068} range:NSMakeRange(0, 5)];
    UILabel *timesLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"23097人看过",@"font":kPingFangRegular(11),@"textColor":KWhiteColor,@"textAlignment":@(NSTextAlignmentCenter)}];
    [timesLabel setAttributedText:str];
    [self.view addSubview:timesLabel];
    [timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(finishLabel.mas_bottom).offset(kRealValue(10));
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kRealValue(110), kRealValue(19)));
    }];
    
    
    UIButton *backBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"返回大厅",@"titleColor":KZSHColorFF2068,@"font":kPingFangRegular(17)}];
    [backBtn addTarget:self action:@selector(closeLiveRoom) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.cornerRadius = 18;
    backBtn.layer.borderColor = KZSHColorFF2068.CGColor;
    backBtn.layer.borderWidth = 1.0;
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timesLabel.mas_bottom).offset(kRealValue(50));
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kRealValue(166), kRealValue(36)));
    }];

    
//    [self.view addSubview:[self createAnchorView]];
//    [self.view addSubview:[self createFooterView]];
}


//头部UI
- (UIView *)createAnchorView{
    UIView *anchorView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, KScreenWidth, kRealValue(60))];
    //    anchorView.userInteractionEnabled = YES;
    [self.view addSubview:anchorView];
    
    UIImageView *anchorHeadImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"live_room_head1"]];
    anchorHeadImageView.layer.cornerRadius = kRealValue(35)/2;
    [anchorView addSubview:anchorHeadImageView];
    [anchorHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(anchorView).offset(kRealValue(18));
        make.centerY.mas_equalTo(anchorView);
        make.width.and.height.mas_equalTo(kRealValue(35));
    }];
    
    NSDictionary *nameLabelDic = @{@"text":@"B-Bro",@"font":kPingFangRegular(12),@"textColor":KWhiteColor};
    UILabel *nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [anchorView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(anchorHeadImageView.mas_right).offset(kRealValue(8));
        make.top.mas_equalTo(anchorHeadImageView);
        make.width.mas_equalTo(KScreenWidth*0.3);
        make.height.mas_equalTo(kRealValue(20));
    }];
    
    NSDictionary *numLabelDic = @{@"text":@"283075",@"font":kGeorgia(8),@"textColor":KWhiteColor};
    UILabel *numLabel = [ZSHBaseUIControl createLabelWithParamDic:numLabelDic];
    [anchorView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.width.mas_equalTo(nameLabel);
        make.height.mas_equalTo(kRealValue(18));
    }];
    
    
    UIButton *personBtn = [[UIButton alloc]init];
    
    [personBtn addTarget:self action:@selector(personInfo) forControlEvents:UIControlEventTouchUpInside];
    [anchorView addSubview:personBtn];
    [personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(anchorView).offset(kRealValue(18));
        make.centerY.mas_equalTo(anchorView);
        make.width.mas_equalTo(kRealValue(75));
        make.height.mas_equalTo(kRealValue(35));
    }];
    
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeLiveRoom) forControlEvents:UIControlEventTouchUpInside];
    [anchorView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(anchorView);
        make.width.and.height.mas_equalTo(kRealValue(35));
        make.centerY.mas_equalTo(anchorView);
    }];
    
    NSArray *audienceImageArr = @[@"live_room_head5",@"live_room_head4",@"live_room_head3",@"live_room_head2"];
    CGFloat spacing = (KScreenWidth*0.6 - (audienceImageArr.count+1)*kRealValue(35))/(audienceImageArr.count-1);
    for (int i = 0; i < audienceImageArr.count; i++) {
        UIImageView *headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:audienceImageArr[i]]];
        headImageView.layer.cornerRadius = kRealValue(35)/2;
        [anchorView addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(closeBtn.mas_left).offset(- (kRealValue(10) + i*(spacing+kRealValue(35))));
            make.centerY.mas_equalTo(anchorView);
            make.width.and.height.mas_equalTo(kRealValue(35));
        }];
    }
    return anchorView;
}

- (UIView *)createFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - kRealValue(49) , KScreenWidth, KBottomNavH)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"0C0C0C"];
    
    UIImage *chatImage = [UIImage imageNamed:@"live_room_chat"];
    UIButton *chatBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [footerView addSubview:chatBtn];
    [chatBtn setBackgroundImage:chatImage forState:UIControlStateNormal];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView).offset(KLeftMargin);
        make.centerY.mas_equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(32), kRealValue(32)));
    }];
    
    NSArray *imageArr = @[@"live_room_gift",@"live_room_love",@"live_room_share"];
    for (int i = 0; i<imageArr.count; i++) {
        UIImage *btnImage = [UIImage imageNamed:imageArr[i]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        btn.tag = 11179+i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn];
        [btn setImage:btnImage forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(footerView).offset(-(15 + i*(btnImage.size.width + kRealValue(10))));
            make.centerY.mas_equalTo(footerView);
            make.width.mas_equalTo(btnImage.size.width);
            make.height.mas_equalTo(btnImage.size.height);
        }];
    }
    return footerView;
}

- (void)closeLiveRoom{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)btnAction:(UIButton *)btn{
    switch (btn.tag - 11179) {
        case 0:
        case 1:{
            RLog(@"点击按钮tag==%ld",btn.tag);
            break;
        }
        case 2:{//分享
            if (![self.view viewWithTag:100]) {
                 [self.view addSubview:self.bottomBlurPopView];
            }
           
        }
        default:
            break;
    }
}

//点击主播头像
- (void)personInfo {
    NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromPersonInfoVCToBottomBlurPopView)};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    [ZSHBaseUIControl setAnimationWithHidden:NO view:bottomBlurPopView completedBlock:nil];
}

- (ZSHBottomBlurPopView *)bottomBlurPopView{
    if (!_bottomBlurPopView) {
        _bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:@{KFromClassType:@(ZSHFromShareVCToToBottomBlurPopView)}];
        _bottomBlurPopView.tag = 100;
        _bottomBlurPopView.blurRadius = 20;
        _bottomBlurPopView.dynamic = NO;
        _bottomBlurPopView.tintColor = KClearColor;
        _bottomBlurPopView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [_bottomBlurPopView setBlurEnabled:NO];
    }
    return _bottomBlurPopView;
}


@end
