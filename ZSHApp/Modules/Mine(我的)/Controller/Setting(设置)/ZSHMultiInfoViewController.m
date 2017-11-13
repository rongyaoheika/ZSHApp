//
//  ZSHMultiInfoViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/9/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMultiInfoViewController.h"
#import "ZSHTextFieldCellView.h"

@interface ZSHMultiInfoViewController ()

@property (nonatomic, assign) ZSHToTextFieldCellView   toViewType;
@property (nonatomic, strong) UIButton           *agreeButton;
@property (nonatomic, strong) UIButton           *resetPwdBtn;
@property (nonatomic, strong) NSArray            *titleArr;
@property (nonatomic, strong) NSArray            *placeHolderArr;
@property (nonatomic, strong) NSArray            *textFieldTypeArr;
@property (nonatomic, assign) CGFloat            bottomBtnTop;
@property (nonatomic, assign) CGFloat            agreeBtnTop;
@property (nonatomic, assign) CGFloat            agreeBtnHeight;

@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHMultiInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{

    if (kFromClassTypeValue == FromAccountVCToMultiInfoVC) {
        //密码-找回登录密码
        self.titleArr = @[@"当前帐号",@"身份证号",@"手机号",@"验证码"];
        self.textFieldTypeArr = @[@(ZSHTextFieldViewPhone),@(ZSHTextFieldViewID),@(ZSHTextFieldViewPhone),@(ZSHTextFieldViewCaptcha)];
        self.placeHolderArr = @[@"",@"",@"",@""];
        self.toViewType = FromMultiInfoAccountVCToTextFieldCellView;

    } else if (kFromClassTypeValue == FromChangePwdVCToMultiInfoVC){
        //设置-个人资料-银行卡2
        self.titleArr = @[@"卡类型",@"手机号",@"验证码"];
        self.textFieldTypeArr = @[@(ZSHTextFieldViewUser),@(ZSHTextFieldViewPhone),@(ZSHTextFieldViewCaptcha)];
        self.placeHolderArr = @[@"中国银行储蓄卡",@"6216615002674782",@"688686"];

    } else if (kFromClassTypeValue == FromUserInfoPhoneVCToMultiInfoVC){
        
        //手机-修改手机号
        self.titleArr = @[@"当前手机号",@"新手机号",@"验证码"];
        self.textFieldTypeArr = @[@(ZSHTextFieldViewPhone),@(ZSHTextFieldViewPhone),@(ZSHTextFieldViewCaptcha)];
        self.placeHolderArr = @[@"18688888888",@"请输入新手机号",@"15677853333",@"请输入验证码"];
         self.toViewType = FromMultiPhoneVCToTextFieldCellView;
    } else if (kFromClassTypeValue == FromUserInfoNickNameVCToMultiInfoVC){
        
        //昵称-修改昵称
        self.titleArr = @[@""];
        self.textFieldTypeArr = @[@(ZSHTextFieldViewUser)];
        self.placeHolderArr = @[@"请输入您的昵称"];
        self.toViewType = FromMultiInfoNickNameVCToTextFieldCellView;
    } else if (kFromClassTypeValue == FromUserInfoQQVCToMultiInfoVC){
        
        //QQ号码-绑定
        self.titleArr = @[@"QQ帐号",@"密码"];
        self.textFieldTypeArr = @[@(ZSHTextFieldViewUser),@(ZSHTextFieldViewPwd)];
        self.placeHolderArr = @[@"12345678",@"请输入密码"];
        self.toViewType = FromMultiInfoQQVCToTextFieldCellView;
    }
    [self initViewModel];
}

- (void)createUI{
    self.title = self.paramDic[@"title"];
   
    if (kFromClassTypeValue == FromUserInfoNickNameVCToMultiInfoVC) {//修改昵称
         [self addNavigationItemWithTitles:@[self.paramDic[@"rightNaviTitle"]] isLeft:NO target:self action:@selector(rightNaviBtnAction:) tags:@[@(kFromClassTypeValue)]];
        
        [self.view addSubview:self.bottomBtn];
        [self.bottomBtn setTitle:self.paramDic[@"bottomBtnTitle"] forState:UIControlStateNormal];
        [self.bottomBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    } else if (kFromClassTypeValue == FromUserInfoQQVCToMultiInfoVC){//QQ授权
       [self addNavigationItemWithTitles:@[self.paramDic[@"rightNaviTitle"]] isLeft:NO target:self action:@selector(rightNaviBtnAction:) tags:@[@(kFromClassTypeValue)]];
        
    } else if (kFromClassTypeValue == FromUserInfoPhoneVCToMultiInfoVC){//更改手机号
        [self.view addSubview:self.bottomBtn];
        [self.bottomBtn setTitle:self.paramDic[@"bottomBtnTitle"] forState:UIControlStateNormal];
        [self.bottomBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight - KNavigationBarHeight);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
    [self.tableView reloadData];

}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection{
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<self.titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(44);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            
            NSDictionary *paramDic = @{@"leftTitle":self.titleArr[indexPath.row],@"placeholder":self.placeHolderArr[indexPath.row],@"textFieldType":self.textFieldTypeArr[indexPath.row],KFromClassType:@(self.toViewType)};
            ZSHTextFieldCellView *textFieldView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(44)) paramDic:paramDic];
            [cell.contentView addSubview:textFieldView];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    return sectionModel;
}

#pragma action

- (void)rightNaviBtnAction:(UIButton *)btn{
    
}

- (void)nextBtnAction{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
