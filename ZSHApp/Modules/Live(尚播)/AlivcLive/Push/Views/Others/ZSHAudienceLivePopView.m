//
//  ZSHAudienceLivePopView.m
//  ZSHApp
//
//  Created by mac on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHAudienceLivePopView.h"
#import "ZSHBottomBlurPopView.h"
@interface ZSHAudienceLivePopView ()

@property (nonatomic, strong) UIView                         *topView;
@property (nonatomic, strong) ZSHBaseTableViewModel          *tableViewModel;
@property (nonatomic, strong) UITableView                    *subTab;
@property (nonatomic, strong) UIView                         *bottomView;


@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";

@implementation ZSHAudienceLivePopView

- (void)setup{
    [self setupLiveTopViews];
    [self setupLiveChatTabView];
    [self setupLiveBottomViews];
}

- (void)setupLiveTopViews{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, kRealValue(60))];
    [self addSubview: self.topView];
    
    UIImageView *anchorHeadImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"live_room_head1"]];
    anchorHeadImageView.layer.cornerRadius = kRealValue(35)/2;
    [self.topView addSubview:anchorHeadImageView];
    [anchorHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView).offset(kRealValue(18));
        make.centerY.mas_equalTo(self.topView);
        make.width.and.height.mas_equalTo(kRealValue(35));
    }];
    
    NSDictionary *nameLabelDic = @{@"text":@"B-Bro",@"font":kPingFangRegular(12),@"textColor":KWhiteColor};
    UILabel *nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [self.topView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(anchorHeadImageView.mas_right).offset(kRealValue(8));
        make.top.mas_equalTo(anchorHeadImageView);
        make.width.mas_equalTo(KScreenWidth*0.3);
        make.height.mas_equalTo(kRealValue(20));
    }];
    
    NSDictionary *numLabelDic = @{@"text":@"283075",@"font":kGeorgia(8),@"textColor":KWhiteColor};
    UILabel *numLabel = [ZSHBaseUIControl createLabelWithParamDic:numLabelDic];
    [self.topView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.width.mas_equalTo(nameLabel);
        make.height.mas_equalTo(kRealValue(18));
    }];
    
    
    // 头像点击Button
    UIButton *personBtn = [[UIButton alloc]init];
    [personBtn addTarget:self action:@selector(personInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:personBtn];
    [personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView).offset(kRealValue(18));
        make.centerY.mas_equalTo(self.topView);
        make.width.mas_equalTo(kRealValue(75));
        make.height.mas_equalTo(kRealValue(35));
    }];
    
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView).offset(-kRealValue(18));
        make.width.and.height.mas_equalTo(kRealValue(25));
        make.centerY.mas_equalTo(self.topView);
    }];
    
    NSArray *audienceImageArr = @[@"live_room_head5",@"live_room_head4",@"live_room_head3",@"live_room_head2"];
    CGFloat spacing = (KScreenWidth*0.6 - (audienceImageArr.count+1)*kRealValue(35))/(audienceImageArr.count-1);
    for (int i = 0; i < audienceImageArr.count; i++) {
        UIImageView *headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:audienceImageArr[i]]];
        headImageView.layer.cornerRadius = kRealValue(35)/2;
        [self.topView addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(closeBtn.mas_left).offset(- (kRealValue(20) + i*(spacing+kRealValue(35))));
            make.centerY.mas_equalTo(self.topView);
            make.width.and.height.mas_equalTo(kRealValue(35));
        }];
    }
    
}

- (void)setupLiveChatTabView{
    self.tableViewModel = [[ZSHBaseTableViewModel alloc] init];
    self.subTab = [ZSHBaseUIControl createTableView];
    self.subTab.backgroundColor = KClearColor;
    [self addSubview: self.subTab];
    self.subTab.delegate = self.tableViewModel;
    self.subTab.dataSource = self.tableViewModel;
    [self.subTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealValue(150));
        make.bottom.mas_equalTo(self).offset(-(kRealValue(49)+ kRealValue(18)));
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
    [self initViewModel];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.subTab reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < 3; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(44);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            cell.textLabel.text = @"李志：三月的艳遇飘摇的南方";
            cell.textLabel.textColor = KWhiteColor;
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    
    return sectionModel;
}

- (void)setupLiveBottomViews{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,  CGRectGetHeight(self.frame) -KBottomTabH , CGRectGetWidth(self.frame), KBottomNavH)];
    [self addSubview: self.bottomView];
    
    UIImage *chatImage = [UIImage imageNamed:@"live_room_chat"];
    UIButton *chatBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.bottomView addSubview:chatBtn];
    [chatBtn setBackgroundImage:chatImage forState:UIControlStateNormal];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomView).offset(KLeftMargin);
        make.centerY.mas_equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(32), kRealValue(32)));
    }];
    
    NSArray *imageArr = @[@"live_room_gift",@"live_room_love",@"live_room_share"];
    for (int i = 0; i<imageArr.count; i++) {
        UIImage *btnImage = [UIImage imageNamed:imageArr[i]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        btn.tag = 11179+i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:btn];
        [btn setImage:btnImage forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bottomView).offset(-(15 + i*(btnImage.size.width + kRealValue(10))));
            make.centerY.mas_equalTo(self.bottomView);
            make.width.mas_equalTo(btnImage.size.width);
            make.height.mas_equalTo(btnImage.size.height);
        }];
    }
}

- (void)btnAction:(UIButton *)btn {
    if ((btn.tag -11179) == 2) {
        [self addSubview:[self createBottomBlurPopViewWith:ZSHFromShareVCToToBottomBlurPopView]];
    }
}

//直播action
- (ZSHBottomBlurPopView *)createBottomBlurPopViewWith:(ZSHFromVCToBottomBlurPopView)fromClassType{
    NSDictionary *nextParamDic = @{KFromClassType:@(fromClassType)};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    bottomBlurPopView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [bottomBlurPopView setBlurEnabled:NO];
    return bottomBlurPopView;
}

- (void)personInfo {
    NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromPersonInfoVCToBottomBlurPopView)};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    [ZSHBaseUIControl setAnimationWithHidden:NO view:bottomBlurPopView completedBlock:nil];
}

- (void)backButtonAction:(UIButton *)btn{
    
    if (self.dissmissViewBlock) {
        self.dissmissViewBlock(btn);
    }
}

@end
