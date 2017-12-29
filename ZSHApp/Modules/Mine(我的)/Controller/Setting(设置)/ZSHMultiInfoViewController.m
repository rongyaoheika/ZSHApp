//
//  ZSHMultiInfoViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/9/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMultiInfoViewController.h"
#import "ZSHTextFieldCellView.h"
#import "ZSHMineLogic.h"

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
@property (nonatomic, strong) ZSHMineLogic       *mineLogic;
@property (nonatomic, copy)   NSString           *changedData;

@property (nonatomic, copy) NSString *text1;    // 第一行的内容
@property (nonatomic, copy) NSString *text2;    // 第二行的内容
@property (nonatomic, copy) NSString *text3;
@property (nonatomic, copy) NSString *text4;
@property (nonatomic, copy) NSString *text5;
@property (nonatomic, copy) NSString *text6;


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
    _mineLogic = [[ZSHMineLogic alloc] init];
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
        self.placeHolderArr = @[@"请输入当前手机号",@"请输入新手机号",@"请输入验证码"];
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
    }else if (kFromClassTypeValue ==  FromUserInfoResumeVCToMultiInfoVC) {
        //个人简介
        self.titleArr = @[@""];
        self.textFieldTypeArr = @[@(ZSHTextFieldViewUser)];
        self.placeHolderArr = @[@"请输入您的个人签名"];
        self.toViewType = FromUserInfoResumeVCToMultiInfoVC;
    }else if (kFromClassTypeValue ==  FromUserPasswordVCToMultiInfoVC) {
        //修改登录密码
        self.titleArr = @[@"当前密码",@"新密码", @"新密码"];
        self.textFieldTypeArr = @[@(ZSHTextFieldViewPwd), @(ZSHTextFieldViewPwd), @(ZSHTextFieldViewPwd)];
        self.placeHolderArr = @[@"", @"", @""];
        self.toViewType = FromUserPasswordVCToMultiInfoVC;
    }else if (kFromClassTypeValue ==  FromSetPasswordToMultiInfoVC) {
        //重置密码
        self.titleArr = @[@"新密码", @"确认密码"];
        self.textFieldTypeArr = @[@(ZSHTextFieldViewPwd), @(ZSHTextFieldViewPwd), @(ZSHTextFieldViewPwd)];
        self.placeHolderArr = @[@"请输入新密码", @"再次输入新密码"];
        self.toViewType = FromSetPasswordToMultiInfoVC;
    }
    [self initViewModel];
}

- (void)createUI{
    self.title = self.paramDic[@"title"];
   
    if (kFromClassTypeValue == FromUserInfoNickNameVCToMultiInfoVC || kFromClassTypeValue == FromUserInfoResumeVCToMultiInfoVC) {//修改昵称
         [self addNavigationItemWithTitles:@[self.paramDic[@"rightNaviTitle"]] isLeft:NO target:self action:@selector(rightNaviBtnAction:) tags:@[@(kFromClassTypeValue)]];
        

    } else if (kFromClassTypeValue == FromUserInfoQQVCToMultiInfoVC){//QQ授权
       [self addNavigationItemWithTitles:@[self.paramDic[@"rightNaviTitle"]] isLeft:NO target:self action:@selector(rightNaviBtnAction:) tags:@[@(kFromClassTypeValue)]];
        
    } else if (kFromClassTypeValue == FromUserInfoPhoneVCToMultiInfoVC){//更改手机号
        [self.view addSubview:self.bottomBtn];
        [self.bottomBtn setTitle:self.paramDic[@"bottomBtnTitle"] forState:UIControlStateNormal];
        [self.bottomBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (kFromClassTypeValue == FromUserPasswordVCToMultiInfoVC || kFromClassTypeValue == FromAccountVCToMultiInfoVC || kFromClassTypeValue == FromSetPasswordToMultiInfoVC) {
        
        [self.view addSubview:self.bottomBtn];
        [self.bottomBtn setTitle:self.paramDic[@"bottomBtnTitle"] forState:UIControlStateNormal];
        [self.bottomBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight - KNavigationBarHeight - KBottomNavH);
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
    [self.tableView reloadData];
}

- (ZSHBaseTableViewSectionModel*)storeListSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<self.titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(44);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
//            if (![cell.contentView viewWithTag:2]) {
                NSDictionary *paramDic = @{@"leftTitle":self.titleArr[indexPath.row],@"placeholder":self.placeHolderArr[indexPath.row],@"textFieldType":self.textFieldTypeArr[indexPath.row],KFromClassType:@(self.toViewType)};
                ZSHTextFieldCellView *textFieldView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(44)) paramDic:paramDic];
                textFieldView.tag = 2+indexPath.row;
                textFieldView.textFieldChanged = ^(NSString *str, NSInteger index) {
                    if (kFromClassTypeValue == FromUserInfoNickNameVCToMultiInfoVC || kFromClassTypeValue == FromUserInfoResumeVCToMultiInfoVC){
                        weakself.changedData = str;
                    } else {
                        if (index == 2) {
                            weakself.text1 = str;
                        } else if (index == 3) {
                            weakself.text2 = str;
                        } else if (index == 4) {
                            weakself.text3 = str;
                        } else if (index == 5) {
                            weakself.text4 = str;
                        } else if (index == 6) {
                            weakself.text5 = str;
                        } else if (index == 7) {
                            weakself.text6 = str;
                        }
                    }
                };
                [cell.contentView addSubview:textFieldView];
//            }
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    return sectionModel;
}

#pragma action

- (void)rightNaviBtnAction:(UIButton *)btn{
    kWeakSelf(self);
    if (kFromClassTypeValue == FromUserInfoNickNameVCToMultiInfoVC){
        [_mineLogic requestUserInfoWithDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue, @"NICKNAME":_changedData} success:^(id response) {
            if (weakself.saveBlock) {
                weakself.saveBlock(weakself.changedData, weakself.index);
            }
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakself.navigationController popViewControllerAnimated:true];
            }];
            [ac addAction:cancelAction];
            [weakself presentViewController:ac animated:YES completion:nil];
        }];
    }else if (kFromClassTypeValue == FromUserInfoResumeVCToMultiInfoVC){
        [_mineLogic requestUserInfoWithDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue, @"SIGNNAME":_changedData} success:^(id response) {
            if (weakself.saveBlock) {
                weakself.saveBlock(weakself.changedData, weakself.index);
            }
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakself.navigationController popViewControllerAnimated:true];
            }];
            [ac addAction:cancelAction];
            [weakself presentViewController:ac animated:YES completion:nil];
        }];
    }
}

- (void)nextBtnAction{
    kWeakSelf(self);
    if (kFromClassTypeValue == FromUserPasswordVCToMultiInfoVC) {
        if ([_text2 isEqualToString:_text3]) {
            [_mineLogic requestUserUpdPasswordWithDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue, @"PASSWORD":_text2, @"OLDPASSWORD":_text1} success:^(id response) {
                NSString *message = @"";
                if ([response[@"result"] isEqualToString:@"01"]) {// 成功
                    message = @"修改成功";
                } else if ([response[@"result"] isEqualToString:@"06"]) { // 失败
                    message = @"原密码错误";
                }
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
                [ac addAction:cancelAction];
                [weakself presentViewController:ac animated:YES completion:nil];
            }];
        } else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入密码不一致" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:cancelAction];
            [weakself presentViewController:ac animated:YES completion:nil];
        }
    } else if(kFromClassTypeValue == FromAccountVCToMultiInfoVC) {
        NSDictionary *dic = nil;
        
#ifdef DEBUG
        dic = @{@"CARDNO":@"10",@"PHONE":@"13512345678",@"USERIDCARD":@"123456"};
#else
        dic = @{@"CARDNO":_text1,@"PHONE":_text3,@"USERIDCARD":_text2};
#endif
        
        [_mineLogic requestForgetUser:dic success:^(id response) {
            ZSHMultiInfoViewController *multiInfoVC = [[ZSHMultiInfoViewController alloc] initWithParamDic:@{KFromClassType:@(FromSetPasswordToMultiInfoVC),@"title":@"重置密码", @"bottomBtnTitle":@"完成",@"HONOURUSER_ID":response[@"pd"][@"HONOURUSER_ID"]}];
            [weakself.navigationController pushViewController:multiInfoVC animated:YES];
        }];
    } else if (kFromClassTypeValue == FromSetPasswordToMultiInfoVC) {
        if ([_text1 isEqualToString:_text2]) {
            [_mineLogic requestUserUpdPasswordWithDic:@{@"HONOURUSER_ID":self.paramDic[@"HONOURUSER_ID"], @"PASSWORD":_text2, @"OLDPASSWORD":@""} success:^(id response) {
                NSString *message = @"";
                if ([response[@"result"] isEqualToString:@"01"]) {// 成功
                    message = @"修改成功";
                } else {
                    message = @"修改失败";
                }
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [weakself.navigationController popToViewController:[weakself.navigationController.viewControllers objectAtIndex:1] animated:true];
                }];
                [ac addAction:cancelAction];
                [weakself presentViewController:ac animated:YES completion:nil];
            }];
        } else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入密码不一致" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:cancelAction];
            [weakself presentViewController:ac animated:YES completion:nil];
        }
    } else if (kFromClassTypeValue == FromUserInfoPhoneVCToMultiInfoVC) {
        [_mineLogic requestUserPhone:@{@"HONOURUSER_ID":HONOURUSER_IDValue, @"PHONE":_text2} success:^(id response) {
            NSString *message = @"";
            if ([response[@"result"] isEqualToString:@"01"]) {// 成功
                if (weakself.saveBlock) {
                    weakself.saveBlock(weakself.text2, weakself.index);
                }
                message = @"修改成功";
            } else {
                message = @"修改失败";
            }
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakself.navigationController popViewControllerAnimated:true];
            }];
            [ac addAction:cancelAction];
            [weakself presentViewController:ac animated:YES completion:nil];
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
