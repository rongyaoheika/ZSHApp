//
//  ZSHLiveRoomViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveRoomViewController.h"
#import "ZSHBottomBlurPopView.h"
#import "ZSHPersonalCenterViewController.h"


@interface ZSHLiveRoomViewController ()

@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHLiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
}

- (void)createUI{
    
    self.isShowLiftBack = false;
    self.isHidenNaviBar = true;

    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"live_room_bg"]];
    image.frame = self.view.bounds;
    [self.view addSubview:image];
    
    [self.view addSubview:[self createAnchorView]];
    [self.view addSubview:[self createFooterView]];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(KScreenHeight - kRealValue(150));
        make.bottom.mas_equalTo(self.view).offset(-(kRealValue(49)+ kRealValue(18)));
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
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
    
    
    // 头像点击Button
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
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeLiveRoom) forControlEvents:UIControlEventTouchUpInside];
    [anchorView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(anchorView).offset(-kRealValue(18));
        make.width.and.height.mas_equalTo(kRealValue(13.7));
        make.centerY.mas_equalTo(anchorView);
    }];
    
    NSArray *audienceImageArr = @[@"live_room_head5",@"live_room_head4",@"live_room_head3",@"live_room_head2"];
    CGFloat spacing = (KScreenWidth*0.6 - (audienceImageArr.count+1)*kRealValue(35))/(audienceImageArr.count-1);
    for (int i = 0; i < audienceImageArr.count; i++) {
        UIImageView *headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:audienceImageArr[i]]];
        headImageView.layer.cornerRadius = kRealValue(35)/2;
        [anchorView addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(closeBtn.mas_left).offset(- (kRealValue(20) + i*(spacing+kRealValue(35))));
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

- (void)btnAction:(UIButton *)btn {
    if ((btn.tag -11179) == 2) {
        [self.view addSubview:[self createBottomBlurPopViewWith:ZSHFromShareVCToToBottomBlurPopView]];
    }
}


- (void)closeLiveRoom{
    [self backBtnClicked];
}

- (void)personInfo {
    NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromPersonInfoVCToBottomBlurPopView)};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    [ZSHBaseUIControl setAnimationWithHidden:NO view:bottomBlurPopView completedBlock:nil];
}


@end
