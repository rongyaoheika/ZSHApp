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
#import "ZSHUploadIDCardController.h"
#import "ZSHCreateStoreGuideView.h"
#import "ZSHPickView.h"


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

@property (nonatomic, strong) ZSHCreateStoreGuideView   *guideView;
@property (nonatomic, strong) ZSHPickView               *pickView;
@property (nonatomic, copy)   NSString                  *addr;  // 门店地址
@end


@implementation ZSHMultiInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (kFromClassTypeValue == FromCreateStoreVCToMultiInfoVC && [self.paramDic[@"showGuide"]integerValue] ) {
        //创建门店引导
        [ZSHBaseUIControl setAnimationWithHidden:NO view:self.guideView completedBlock:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    self.paramDic = nil;
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
    }else if (kFromClassTypeValue == FromSetPasswordToMultiInfoVC) {
        //重置密码
        self.titleArr = @[@"新密码", @"确认密码"];
        self.textFieldTypeArr = @[@(ZSHTextFieldViewPwd), @(ZSHTextFieldViewPwd), @(ZSHTextFieldViewPwd)];
        self.placeHolderArr = @[@"请输入新密码", @"再次输入新密码"];
        self.toViewType = FromSetPasswordToMultiInfoVC;
    }else if (kFromClassTypeValue ==  FromCreateStoreVCToMultiInfoVC) {
        // 创建门店
        if ([self.paramDic[@"row"]integerValue]>1) {
            self.titleArr = @[@"企业名称", @"企业地址", @"详细地址", @"企业电话"];
            self.placeHolderArr = @[@"若有下属企业，请具体到具体企业名", @"请选择", @"请输入", @"填写座机/手机，座机需加区号"];
        } else {
            self.titleArr = @[@"门店名称", @"门店地址", @"详细地址", @"门店电话"];
            self.placeHolderArr = @[@"若有分店，请具体到分店名", @"请选择", @"请输入", @"填写座机/手机，座机需加区号"];
        }
         self.textFieldTypeArr = @[@(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser)];

//        self.titleArr = @[@"门店名称", @"门店地址", @"详细地址", @"门店电话"];
//        self.textFieldTypeArr = @[@(ZSHTextFieldViewUser), @(ZSHTextFieldViewNone), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser)];
//        self.placeHolderArr = @[@"若有分店，请具体到分店名", @"", @"请输入", @"填写座机/手机，座机需加区号"];

    }else if (kFromClassTypeValue ==  FromVerifyVCToMultiInfoVC) {
        // 提交审核
        self.titleArr = @[@"上传身份证", @"经营者姓名", @"身份证号", @"店铺照片", @"营业执照",
                          @"注册号", @"执照名称", @"法人姓名",@"经营者手机", @"经营者手机"];
        self.textFieldTypeArr = @[
    @(ZSHTextFieldSelect), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldSelect),@(ZSHTextFieldSelect),
    @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser),@(ZSHTextFieldViewUser), @(ZSHTextFieldViewCaptcha)];
        self.placeHolderArr = @[@"本人身份证照片", @"须与身份证姓名一致", @"请输入经营者身份证号码", @"请上传实体店铺照片",@"请上传营业执照照片", @"注册号或同一社会信用代码", @"营业执照名称这一行的内容", @"营业执照上法人或经营者姓名",@"用本人身份证办理的手机号", @"输入验证码"];
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
        
    } else if (kFromClassTypeValue == FromUserPasswordVCToMultiInfoVC || kFromClassTypeValue == FromAccountVCToMultiInfoVC || kFromClassTypeValue == FromSetPasswordToMultiInfoVC || kFromClassTypeValue == FromCreateStoreVCToMultiInfoVC | kFromClassTypeValue == FromVerifyVCToMultiInfoVC) {
        
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
    
    [self.tableView reloadData];
    
   
}

- (UIView *)createTableHeadView {
    UIView *backgroundView = [[UIView alloc] init];
    UILabel *addLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"龙兴莱曼海景度假酒店"}];
    addLabel.frame = CGRectMake(15, 17.5, 200, 16);
    UILabel *detailLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"天涯区三亚湾路128号", @"font":kPingFangMedium(12)}];
    detailLabel.frame = CGRectMake(15, 46.5, 2000, 16);
    [backgroundView addSubview:addLabel];
    [backgroundView addSubview:detailLabel];
    return backgroundView;
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    if (kFromClassTypeValue == FromVerifyVCToMultiInfoVC) {
        self.tableView.tableHeaderView = [self createTableHeadView];
    }
    [self.tableView reloadData];
}

- (ZSHBaseTableViewSectionModel*)storeListSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    if (kFromClassTypeValue == FromVerifyVCToMultiInfoVC) {
        sectionModel.headerHeight = 80;
    }
    for (int i = 0; i<self.titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(44);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
            if (!cell) {
                cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleValue2
                                          reuseIdentifier:@"cellId"];
            }
            if (kFromClassTypeValue ==  FromCreateStoreVCToMultiInfoVC) {
                if (indexPath.row == 1) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    if (weakself.addr) {
                        cell.detailTextLabel.text = weakself.addr;
                    }
                }
            } else if (kFromClassTypeValue ==  FromVerifyVCToMultiInfoVC) {
                if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }

            NSDictionary *paramDic = @{@"leftTitle":self.titleArr[indexPath.row],@"placeholder":self.placeHolderArr[indexPath.row],@"textFieldType":self.textFieldTypeArr[indexPath.row],KFromClassType:@(self.toViewType)};
            ZSHTextFieldCellView *textFieldView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-10, kRealValue(44)) paramDic:paramDic];
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
            
            if (kFromClassTypeValue ==  FromCreateStoreVCToMultiInfoVC) {
                if (indexPath.row == 1) {
                }
            }
            
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            if (kFromClassTypeValue ==  FromCreateStoreVCToMultiInfoVC) {
                if (indexPath.row == 1) {// 地区选择
                    weakself.pickView = [weakself createPickViewWithType:WindowRegion];
                    weakself.pickView.saveChangeBlock = ^(NSString *text, NSInteger index) {
                        weakself.addr = text;
                        [tableView reloadData];
                    };
                    [weakself.pickView show:WindowRegion];
                }
            } else if (kFromClassTypeValue ==  FromVerifyVCToMultiInfoVC) {
                if (indexPath.row == 0 ) { // 上传身份证
                    ZSHUploadIDCardController *uploadIDCardVC = [[ZSHUploadIDCardController alloc] init];
                    [self.navigationController pushViewController:uploadIDCardVC animated:true];
                }
            }
        };
    }
    return sectionModel;
}
#pragma pickView
- (ZSHPickView *)createPickViewWithType:(NSUInteger)type{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:@""];
    
    NSArray *areaArr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *provinces = [NSMutableArray array];
    for (NSDictionary *dic in areaArr) {
        [provinces addObject:dic[@"state"]];
    }
    
    NSMutableArray *citys = [NSMutableArray array];
    NSMutableArray *districts = [NSMutableArray array];
    for (NSDictionary *dic in areaArr) {
        if ([dic[@"state"] isEqualToString:@"北京"]) {
            for (NSDictionary *city in dic[@"cities"]) {
                [citys addObject:city[@"city"]];
                if ([city[@"city"] isEqualToString:citys[0]]) {
                    if (city[@"areas"]) {
                        districts = city[@"areas"];
                    }
                }
            }
            break;
        }
        
    }
    
    
    NSMutableArray *regionArr = [NSMutableArray arrayWithObjects:provinces, citys, districts, nil];
    NSDictionary *nextParamDic = @{@"type":@(type),@"midTitle":@"城市区域选择",@"dataArr":regionArr};
    
    _pickView = [[ZSHPickView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) paramDic:nextParamDic];
    _pickView.controller = self;
    
    return _pickView;
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
            [_mineLogic requestUserUpdPasswordWithDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue, @"PASSWORD":[ZSHBaseFunction md5StringFromString:_text2], @"OLDPASSWORD":[ZSHBaseFunction md5StringFromString:_text1]} success:^(id response) {
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
            [_mineLogic requestUserUpdPasswordWithDic:@{@"HONOURUSER_ID":self.paramDic[@"HONOURUSER_ID"], @"PASSWORD":[ZSHBaseFunction md5StringFromString:_text2], @"OLDPASSWORD":@""} success:^(id response) {
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
    } else if (kFromClassTypeValue == FromCreateStoreVCToMultiInfoVC) {//创建门店
        ZSHMultiInfoViewController *multiInfoVC = [[ZSHMultiInfoViewController alloc] initWithParamDic:@{KFromClassType:@(FromVerifyVCToMultiInfoVC),@"title":@"提交资质", @"bottomBtnTitle":@"提交审核"}];
        [self.navigationController pushViewController:multiInfoVC animated:YES];
    }
}

- (ZSHCreateStoreGuideView *)guideView{
    if (!_guideView) {
        _guideView = [[ZSHCreateStoreGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) paramDic:@{@"row":self.paramDic[@"row"]}];
        _guideView.tag = 3;
        
        
    }
    return _guideView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
