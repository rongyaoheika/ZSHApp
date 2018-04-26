//
//  ZSHMakeMoneyViewController.m
//  RLJKApp
//
//  Created by zhaoweiwei on 2017/9/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMakeMoneyViewController.h"

@interface ZSHMakeMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray   *dataArr;
@property (nonatomic,strong)UIButton  *shareBtn;
@property (nonatomic,strong)UILabel   *invitesLabel;
@property (nonatomic,strong)UIView    *cellView;
@property (nonatomic,strong)ZSHBottomBlurPopView   *bottomBlurPopView;

@end

@implementation ZSHMakeMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.dataArr = @[@[@"2017年1月1日",@"2017年1月1日",@"2017年1月1日",@"2017年1月1日",@"2017年1月1日"],
                     @[@"获得佣金30元",@"获得佣金30元",@"获得佣金30元",@"获得佣金30元",@"获得佣金30元"]];
}

- (void)createUI{
    self.title = @"分享收益";
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"money_bg"]];
    bgImage.frame = self.view.bounds;
    [self.view addSubview:bgImage];
    
    UIImageView *titleImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"money_title"]];
    titleImage.frame = CGRectMake(kRealValue(20), KNavigationBarHeight + kRealValue(53), kScreenWidth - 2*kRealValue(20), kRealValue(44));
    [self.view addSubview:titleImage];
    
    [self.view addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(209));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(kRealValue(190));
        make.height.mas_equalTo(kRealValue(44));
    }];
    
    [self.view addSubview:self.invitesLabel];
    [self.invitesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.top.mas_equalTo(self.shareBtn.mas_bottom).offset(kRealValue(20));
        make.height.mas_equalTo(kRealValue(15));
    }];
    
    [self createTableViewContentView];
}

#pragma delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[0]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRealValue(30);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = KClearColor;
    UIView *cellView = [self createCellViewWithLeftStr:self.dataArr[0][indexPath.row] rightStr:self.dataArr[1][indexPath.row]];
    [cell.contentView addSubview:cellView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


#pragma getter
- (UIButton *)shareBtn{
    if (!_shareBtn) {
        NSDictionary *shareBtnParam = @{@"title":@"立即分享",@"titleColor":[UIColor colorWithHexString:@"B15308"],@"font":kPingFangSemibold(20),@"backgroundColor":[UIColor colorWithHexString:@"FFDA31"]};
        _shareBtn = [ZSHBaseUIControl  createBtnWithParamDic:shareBtnParam target:self action:@selector(shareAction)];
        _shareBtn.layer.cornerRadius = 10.0;
    }
    return _shareBtn;
}

- (UILabel *)invitesLabel{
    if (!_invitesLabel) {
        NSDictionary *invitesLabelDic = @{@"text":@"成功邀请5人",@"font":kPingFangRegular(12),@"textAlignment":@(NSTextAlignmentCenter)};
        _invitesLabel = [ZSHBaseUIControl createLabelWithParamDic:invitesLabelDic];
    }
    return _invitesLabel;
}

- (void)createTableViewContentView{
    UIImage *image = [UIImage imageNamed:@"mine_tb_bg"];
    UIView *tableViewContentView = [[UIView alloc]init];
    [self.view addSubview:tableViewContentView];
    [tableViewContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.invitesLabel.mas_bottom).offset(kRealValue(40));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    RLog(@"图片的宽高为%f%f",image.size.width,image.size.height);
    [tableViewContentView insertSubview:imgView atIndex:0];
    
    [tableViewContentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(tableViewContentView).insets(UIEdgeInsetsMake(kRealValue(65), kRealValue(30), kRealValue(40), kRealValue(30)));
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

- (UIView *)createCellViewWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr{
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kRealValue(230), kRealValue(30))];
    NSDictionary *leftLabelDic = @{@"text":leftStr,@"font":kPingFangRegular(15),@"textColor":KZSHColorA61CE7,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *leftDateLabel = [ZSHBaseUIControl createLabelWithParamDic:leftLabelDic];
    leftDateLabel.frame = CGRectMake(0, 0, kRealValue(230)/2, kRealValue(30));
    [cellView addSubview:leftDateLabel];

    NSDictionary *rightLabelDic = @{@"text":rightStr,@"font":kPingFangRegular(15),@"textColor":KZSHColorA61CE7,@"textAlignment":@(NSTextAlignmentRight)};
    UILabel *rightCountLabel = [ZSHBaseUIControl createLabelWithParamDic:rightLabelDic];
    rightCountLabel.frame = CGRectMake(kRealValue(230)/2, 0, kRealValue(230)/2, kRealValue(30));
    [cellView addSubview:rightCountLabel];
    return cellView;
}

#pragma action
- (void)shareAction{
    [self.view addSubview:[self createBottomBlurPopViewWith:ZSHFromShareVCToToBottomBlurPopView]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
