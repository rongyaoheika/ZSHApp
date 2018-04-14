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
#import "ZSHMultiInfoViewController+method.h"
static NSString *ListCell = @"listCellId";

@interface ZSHMultiInfoViewController ()<UIAlertViewDelegate>

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


@property (nonatomic, strong) ZSHCreateStoreGuideView   *guideView;
@property (nonatomic, strong) ZSHPickView               *pickView;
@property (nonatomic, strong) ZSHPickView               *storePickView; // 娱乐商家分类
@property (nonatomic, copy)   NSString                  *funStoreName;  // 娱乐商家名字
@property (nonatomic, copy)   NSString                  *addr;          // 门店地址
@property (nonatomic, copy)   NSString                  *provinceStr;   // 门店所在省
@property (nonatomic, copy)   NSString                  *cityStr;       // 门店所在区
@property (nonatomic, copy)   NSString                  *districtStr;   // 门店所在县



//上传图片（1，2，3）
@property (nonatomic, strong) NSMutableArray       *imagMArr;
@property (nonatomic, strong) NSMutableArray       *fileNameMArr;

//图片data数组
@property (nonatomic, strong) NSArray       *idImgDataArr;
@property (nonatomic, strong) NSArray       *storeImgDataArr;
@property (nonatomic, strong) NSArray       *licenseImgDataArr;

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
    if ((kFromClassTypeValue == FromCreateStoreVCToMultiInfoVC || kFromClassTypeValue == FromWeMediaVCToMultiInfoVC) && [self.paramDic[@"showGuide"]integerValue] ) {
        [ZSHBaseUIControl setAnimationWithHidden:NO view:self.guideView completedBlock:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.paramDic];
    [dic setObject:@(0) forKey:@"showGuide"];
    self.paramDic = dic;
}

- (void)loadData{
    _imagMArr = [[NSMutableArray alloc]init];
    _fileNameMArr = [[NSMutableArray alloc]init];
    _mineLogic = [[ZSHMineLogic alloc] init];
    _entryLogic = [[ZSHEntryLogic alloc]init];
    _storeDic = [[NSMutableDictionary alloc]init];
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
        // 美食，酒店（前两行） 称为门店，其他称为企业
        if ([self.paramDic[@"row"]integerValue]>1) {//企业
            if ([self.paramDic[@"row"]integerValue] == 9) {//娱乐商家
                self.titleArr = @[@"门店分类",@"门店名称", @"门店地址", @"详细地址", @"门店电话"];
                self.placeHolderArr = @[@"门店分类",@"若有分店，请具体到分店名", @"请选择", @"请输入", @"填写座机/手机，座机需加区号"];
                self.textFieldTypeArr = @[@(ZSHTextFieldSelect),@(ZSHTextFieldViewUser), @(ZSHTextFieldSelect), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewPhone)];
            } else {
                self.titleArr = @[@"企业名称", @"企业地址", @"详细地址", @"企业电话"];
                self.placeHolderArr = @[@"若有下属企业，请具体到具体企业名", @"请选择", @"请输入", @"填写座机/手机，座机需加区号"];
                self.textFieldTypeArr = @[@(ZSHTextFieldViewUser), @(ZSHTextFieldSelect), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewPhone)];
            }
        } else {//门店（美食商家，酒店商家）
            self.titleArr = @[@"门店名称", @"门店地址", @"详细地址", @"门店电话"];
            self.placeHolderArr = @[@"若有分店，请具体到分店名", @"请选择", @"请输入", @"填写座机/手机，座机需加区号"];
            self.textFieldTypeArr = @[@(ZSHTextFieldViewUser), @(ZSHTextFieldSelect), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewPhone)];
        }
        
    }else if (kFromClassTypeValue ==  FromVerifyVCToMultiInfoVC) {
        // 提交审核
        self.titleArr = @[@"上传身份证", @"经营者姓名", @"身份证号", @"店铺照片", @"营业执照",
                          @"注册号", @"执照名称", @"法人姓名",@"经营者手机", @"验证码"];
        self.textFieldTypeArr = @[
                                  @(ZSHTextFieldSelect), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldSelect),@(ZSHTextFieldSelect),
                                  @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser),@(ZSHTextFieldViewPhone), @(ZSHTextFieldViewCaptcha)];
        self.placeHolderArr = @[@"本人身份证照片", @"须与身份证姓名一致", @"请输入经营者身份证号码", @"请上传实体店铺照片",@"请上传营业执照照片", @"注册号或同一社会信用代码", @"营业执照名称这一行的内容", @"营业执照上法人或经营者姓名",@"用本人身份证办理的手机号", @"输入验证码"];
    } else if (kFromClassTypeValue ==  FromWeMediaVCToMultiInfoVC) { // 自媒体入驻
        self.titleArr = @[@"自媒体名称", @"地址信息", @"详细地址"];
        self.textFieldTypeArr = @[@(ZSHTextFieldViewUser), @(ZSHTextFieldSelect), @(ZSHTextFieldViewUser)];
        self.placeHolderArr = @[@"填写后不能更改", @"请选择", @"请输入"];
    } else if (kFromClassTypeValue ==  FromWeMediaVerifyVCToMultiInfoVC) { //
        self.titleArr = @[@"自媒体头像", @"姓名", @"身份证号", @"身份证照片", @"邮箱", @"经营者手机", @"验证码"];
        self.textFieldTypeArr = @[@(ZSHTextFieldViewNone), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldSelect), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewPhone), @(ZSHTextFieldViewCaptcha)];
        self.placeHolderArr = @[@"", @"须与身份证姓名一致", @"请输入经营者身份证号码", @"营业执照上法人或经营者姓名", @"请输入您的联系邮箱", @"用本人身份证办理的手机号", @"输入验证码"];
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
        [self.bottomBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (kFromClassTypeValue == FromUserPasswordVCToMultiInfoVC || kFromClassTypeValue == FromAccountVCToMultiInfoVC || kFromClassTypeValue == FromSetPasswordToMultiInfoVC || kFromClassTypeValue == FromCreateStoreVCToMultiInfoVC | kFromClassTypeValue == FromVerifyVCToMultiInfoVC ||kFromClassTypeValue ==  FromWeMediaVCToMultiInfoVC || kFromClassTypeValue ==  FromWeMediaVerifyVCToMultiInfoVC) {//添加底部按钮
        
        [self.view addSubview:self.bottomBtn];
        [self.bottomBtn setTitle:self.paramDic[@"bottomBtnTitle"] forState:UIControlStateNormal];
        [self.bottomBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight - KNavigationBarHeight - KBottomNavH);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ListCell];
    
    [self.tableView reloadData];
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
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCell forIndexPath:indexPath];
            
            if (![cell.contentView viewWithTag:2+indexPath.row]) {
                NSDictionary *paramDic = @{@"leftTitle":self.titleArr[indexPath.row],@"placeholder":self.placeHolderArr[indexPath.row],@"textFieldType":self.textFieldTypeArr[indexPath.row],KFromClassType:@(self.toViewType)};
                ZSHTextFieldCellView *textFieldView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-10, kRealValue(44)) paramDic:paramDic];
                textFieldView.tag = 2+indexPath.row;
                [weakself observeTextField:textFieldView];
                [cell.contentView addSubview:textFieldView];
            }
            
            if (kFromClassTypeValue ==  FromWeMediaVerifyVCToMultiInfoVC) {
                if (indexPath.row == 0) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(292, 8, 30, 30)];
                    headImageView.layer.cornerRadius = headImageView.frame.size.width/2;
                    headImageView.layer.masksToBounds = true;
                    [headImageView sd_setImageWithURL:[NSURL URLWithString:curUser.PORTRAIT]];
                    [cell addSubview:headImageView];
                } else if(indexPath.row == 3) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            } else if (kFromClassTypeValue ==  FromCreateStoreVCToMultiInfoVC || kFromClassTypeValue ==  FromWeMediaVCToMultiInfoVC) {
                if ([self.paramDic[@"row"]integerValue] == 9) { // 娱乐商家
                    if(indexPath.row == 0 ){// 门店分类
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        if (weakself.funStoreName) {
                            ZSHTextFieldCellView *textFieldView  = [cell.contentView viewWithTag:2+indexPath.row];
                            textFieldView.textField.text = weakself.funStoreName;
                            
                        }
                    }
                    
                    if(indexPath.row == 2){ //门店地址
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        if (weakself.addr) {
                            ZSHTextFieldCellView *textFieldView  = [cell.contentView viewWithTag:2+indexPath.row];
                            textFieldView.textField.text = weakself.addr;
                            _text2 = weakself.addr;
                            [_storeDic setValue:_text2 forKey:@"storeAddress"];
                        }
                    }
                } else  {
                    if(indexPath.row == 1){ //门店地址
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        if (weakself.addr) {
                            ZSHTextFieldCellView *textFieldView  = [cell.contentView viewWithTag:2+indexPath.row];
                            textFieldView.textField.text = weakself.addr;
                            _text2 = weakself.addr;
                             [_storeDic setValue:_text2 forKey:@"storeAddress"];
                        }
                    }
                }
            } else if (kFromClassTypeValue ==  FromVerifyVCToMultiInfoVC) {
                if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            
            
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            if (kFromClassTypeValue ==  FromCreateStoreVCToMultiInfoVC || kFromClassTypeValue ==  FromWeMediaVCToMultiInfoVC) {
                if ([self.paramDic[@"row"]integerValue] == 9) { // 娱乐商家
                    if(indexPath.row == 0){// 门店分类
                        NSArray *seatArr = @[@"KTV",@"酒吧",@"夜店"];
                        NSDictionary *nextParamDic = @{@"type":@(WindowDefault),@"midTitle":@"娱乐商家选择",@"dataArr":seatArr};
                        weakself.storePickView = [weakself createPickViewWithParamDic:nextParamDic];
                        [weakself.storePickView show:WindowDefault];
                        weakself.storePickView.saveChangeBlock = ^(NSString *text, NSInteger index, NSDictionary *dic) {
                            weakself.funStoreName = text;
                            [weakself.tableView reloadData];
                        };
                        
                    } else if (indexPath.row == 2){ //门店地址
                        [weakself popRegionPickView];
                    }
                } else  {
                    if(indexPath.row == 1){ //门店地址
                        [weakself popRegionPickView];
                    }
                }
            } else if (kFromClassTypeValue ==  FromVerifyVCToMultiInfoVC) {
                ZSHBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                ZSHTextFieldCellView *textFieldView  = [cell.contentView viewWithTag:2+indexPath.row];
                ZSHUploadIDCardController *uploadIDCardVC = nil;
                if (indexPath.row == 0 ) { //身份证图片
                    uploadIDCardVC = [[ZSHUploadIDCardController alloc] initWithParamDic:@{KFromClassType:@(FromIDCardVCToUploadPhotoVC),@"imgPath":@"id"}];
                    [self.navigationController pushViewController:uploadIDCardVC animated:true];
                    uploadIDCardVC.viewWillDisAppearBlock = ^(BOOL isFinished,UIImage *positiveImg, UIImage *negativeImg, UIImage *thirdImg,NSString *positiveImgPath,NSString *negativeImgPath,NSString *thirdImgPath) {
                        textFieldView.textField.text = isFinished?@"待审核":@"待完善";
                        _imageText1 = textFieldView.textField.text;
                        if (isFinished) {
                            if ( [_imagMArr count]>0) {//防止键盘弹出顺序错乱多次点入
                                [_imagMArr removeObjectAtIndex:0];
                            }
                            if ( [_fileNameMArr count]>0) {
                                [_fileNameMArr removeObjectAtIndex:0];
                            }
                            
                            NSArray *idImgMArr = @[positiveImg,negativeImg];
                            [_imagMArr addObject:idImgMArr];
                            
                            NSArray *idImgPathArr = @[positiveImgPath,negativeImgPath];
                            [_fileNameMArr addObject:idImgPathArr];
                            
                        }
                        
                    };
                    
                } else if (indexPath.row == 3) {//店铺图片
                    uploadIDCardVC = [[ZSHUploadIDCardController alloc] initWithParamDic:@{KFromClassType:@(FromStoreVCToUploadPhotoVC),@"imgPath":@"store"}];
                    [self.navigationController pushViewController:uploadIDCardVC animated:true];
                    uploadIDCardVC.viewWillDisAppearBlock = ^(BOOL isFinished,UIImage *positiveImg, UIImage *negativeImg, UIImage *thirdImg,NSString *positiveImgPath,NSString *negativeImgPath,NSString *thirdImgPath) {
                        textFieldView.textField.text = isFinished?@"待审核":@"待完善";
                        _imageText2 = textFieldView.textField.text;
                        if (isFinished) {
                            
                            if ( [_imagMArr count]>1) {
                                [_imagMArr removeObjectAtIndex:1];
                            }
                            if ( [_fileNameMArr count]>1) {
                                [_fileNameMArr removeObjectAtIndex:1];
                            }
                            NSArray *storeImgArr = @[positiveImg,negativeImg,thirdImg];
                            [_imagMArr addObject:storeImgArr];
                            
                            NSArray *storeImgPathArr = @[positiveImgPath,negativeImgPath,thirdImgPath];
                            [_fileNameMArr addObject:storeImgPathArr];
                        }
                        
                    };
                    
                } else if (indexPath.row == 4) {//营业执照图片
                    uploadIDCardVC = [[ZSHUploadIDCardController alloc] initWithParamDic:@{KFromClassType:@(FromLicenseVCToUploadPhotoVC),@"imgPath":@"license"}];
                    [self.navigationController pushViewController:uploadIDCardVC animated:true];
                    uploadIDCardVC.viewWillDisAppearBlock = ^(BOOL isFinished,UIImage *positiveImg, UIImage *negativeImg, UIImage *thirdImg,NSString *positiveImgPath,NSString *negativeImgPath,NSString *thirdImgPath) {
                        textFieldView.textField.text = isFinished?@"待审核":@"待完善";
                        _imageText3 = textFieldView.textField.text;
                        if (isFinished) {
                            if ( [_imagMArr count]>2) {
                                [_imagMArr removeObjectAtIndex:2];
                            }
                            if ( [_fileNameMArr count]>2) {
                                [_fileNameMArr removeObjectAtIndex:2];
                            }
                            
                            NSArray *lisenceImgArr = @[positiveImg];
                            [_imagMArr addObject:lisenceImgArr];
                            
                            NSArray *lisenceImgPathArr = @[positiveImgPath];
                            [_fileNameMArr addObject:lisenceImgPathArr];
                        }
                        
                    };
                }
                
            } else if (kFromClassTypeValue ==  FromWeMediaVerifyVCToMultiInfoVC) {
                if (indexPath.row == 3) {
                    ZSHUploadIDCardController *uploadIDCardVC = [[ZSHUploadIDCardController alloc] initWithParamDic:@{KFromClassType:@(FromIDCardVCToUploadPhotoVC)}];
                    [self.navigationController pushViewController:uploadIDCardVC animated:true];
                }
            }
        };
    }
    return sectionModel;
}

//监听textField输入值
- (void)observeTextField:(ZSHTextFieldCellView*)textFieldView{
    kWeakSelf(self);
    textFieldView.textFieldChanged = ^(NSString *str, NSInteger index) {
        if (kFromClassTypeValue == FromUserInfoNickNameVCToMultiInfoVC || kFromClassTypeValue == FromUserInfoResumeVCToMultiInfoVC){
            weakself.changedData = str;
        } else if(kFromClassTypeValue == FromVerifyVCToMultiInfoVC){
            if (index == 3) {
                weakself.text1 = str;
            } else if (index == 4) {
                weakself.text2 = str;
            } else if (index == 7) {
                weakself.text3 = str;
            } else if (index == 8) {
                weakself.text4 = str;
            } else if (index == 9) {
                weakself.text5 = str;
            } else if (index == 10) {
                weakself.text6 = str;
            }
        } else if (kFromClassTypeValue ==  FromCreateStoreVCToMultiInfoVC ){//创建门店
            if ([self.paramDic[@"row"]integerValue] == 9) {//娱乐商家（增加一行“门店分类”）：
                if (index == 3) {//门店名称
                    weakself.text1 = str;
                } else if (index == 4) {
                    weakself.text2 = str;
                } else if (index == 5) {
                    weakself.text3 = str;
                } else if (index == 6) {
                    weakself.text4 = str;
                } else if (index == 7) {
                    weakself.text5 = str;
                }
            } else {//其他商家
                switch (index) {
                    case 2:{//门店名称
                        [_storeDic setValue:str forKey:@"storeName"];
                        break;
                    }
                   
                    case 4:{//门店详细地址
                        [_storeDic setValue:str forKey:@"storeDetailAddress"];
                        break;
                    }
                    case 5:{//门店电话
                        [_storeDic setValue:str forKey:@"storePhone"];
                        break;
                    }
                        
                    default:
                        break;
                }
                
            }
        }
    };
}

#pragma pickView
- (ZSHPickView *)createPickViewWithType:(NSUInteger)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citys.plist" ofType:@""];
    NSDictionary *areaDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSMutableArray *provinces = [NSMutableArray array];
    NSMutableArray *citys = [NSMutableArray array];
    NSMutableArray *districts = [NSMutableArray array];
    
    [areaDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [provinces addObject:key];
    }];
    
    [[areaDic objectForKey:provinces[0]][0] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [citys addObject:key];
    }];
    
    NSDictionary *arr = [areaDic objectForKey:provinces[0]][0];
    districts = [arr objectForKey:citys[0]];
    
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

- (void)nextBtnAction:(UIButton *)nextBtn{
    kWeakSelf(self);
    switch (kFromClassTypeValue) {
        case FromUserPasswordVCToMultiInfoVC:{
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
            break;
        }
        case FromAccountVCToMultiInfoVC:{
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
            break;
        }
        case FromSetPasswordToMultiInfoVC:{
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
            break;
        }
        case FromUserInfoPhoneVCToMultiInfoVC:{
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
            break;
        }
        case FromCreateStoreVCToMultiInfoVC:{//确认创建
            if ([self createStoreAction]) {
                NSString *categoryId = self.funStoreName?self.funStoreName:self.paramDic[@"categoryId"];
                NSDictionary *paramDic = @{KFromClassType:@(FromVerifyVCToMultiInfoVC),@"title":@"提交资质",
                                           @"bottomBtnTitle":@"提交审核",@"categoryId":categoryId,                                      @"storeName":_storeDic[@"storeName"],@"provinceName":self.provinceStr,@"cityName":self.cityStr,@"districtName":self.districtStr?self.districtStr:@"",@"address":_storeDic[@"storeAddress"],@"detailAddress":_storeDic[@"storeDetailAddress"],@"phoneStr":_storeDic[@"storePhone"],
                                           };
                ZSHMultiInfoViewController *multiInfoVC = [[ZSHMultiInfoViewController alloc] initWithParamDic:paramDic];
                [self.navigationController pushViewController:multiInfoVC animated:YES];
            }
            break;
        }
        case FromVerifyVCToMultiInfoVC:{//门店提交审核
            if ([self submitCheckAction]) {
                
                NSString *categoryId = self.funStoreName?self.funStoreName:self.paramDic[@"categoryId"];
                HCLocationManager *locationManager = [HCLocationManager sharedManager];
                [locationManager getLatiAndLongiWithCity:self.paramDic[@"address"] compelete:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
                    NSDictionary *paramDic = @{@"CATEGORY_ID":categoryId,@"APPLYFOR_NAME":self.paramDic[@"storeName"],
                                               @"APPLYFOR_PROVINCE":self.paramDic[@"provinceName"],@"APPLYFOR_CITY":self.paramDic[@"cityName"],
                                               @"APPLY_COUNTY":self.paramDic[@"districtName"],@"APPLYFOR_ADDRESS":self.paramDic[@"detailAddress"],
                                               @"APPLYFOR_LONGITUDE":@(longitude),@"APPLYFOR_LATITUDE":@(latitude),
                                               @"APPLYFOR_TEL":self.paramDic[@"phoneStr"], @"APPLYFOR_PRICE":@"99",
                                               @"APPLY_OPERRATE":self.text1,@"APPLYFOR_IDCARD":self.text2,
                                               @"APPLYFOR_CHARTERNUM":self.text3,@"APPLYFOR_CHARTERNAME":self.text4,
                                               @"APPLYFOR_LEGALPERSON":self.text5,@"APPLYFOR_PHONE":self.text6,
                                               @"HONOURUSER_ID":HONOURUSER_IDValue
                                               };
                    [self submitActionWithBtn:nextBtn paramDic:paramDic names:@[@"APPLYFOR_IDCARDIMAGE",@"APPLYFOR_IMAGES",@"APPLYFOR_CHARTERIMAGE"] images:_imagMArr fileNames:_fileNameMArr];
                    //5s之后可重复点击提交审核按钮
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        nextBtn.enabled = YES;
                    });
                }];
                
            }
            
            break;
        }
        case FromWeMediaVCToMultiInfoVC:{//提交审核
            ZSHMultiInfoViewController *multiInfoVC = [[ZSHMultiInfoViewController alloc] initWithParamDic:@{KFromClassType:@(FromWeMediaVerifyVCToMultiInfoVC),@"title":@"提交资质", @"bottomBtnTitle":@"提交审核"}];
            [self.navigationController pushViewController:multiInfoVC animated:YES];
            break;
        }
        default:
            break;
    }
}

//弹出门店地址pickView
- (void)popRegionPickView{
    kWeakSelf(self);
    weakself.pickView = [weakself createPickViewWithType:WindowRegion];
    weakself.pickView.saveChangeBlock = ^(NSString *text, NSInteger index, NSDictionary *dic) {
        weakself.addr = text;
        weakself.provinceStr = dic[@"provinceStr"];
        weakself.cityStr = dic[@"cityStr"];
        weakself.districtStr = dic[@"districtStr"];
        [weakself.tableView reloadData];
    };
    [weakself.pickView show:WindowRegion];
}

//创建门店引导
- (ZSHCreateStoreGuideView *)guideView{
    if (!_guideView) {
        _guideView = [[ZSHCreateStoreGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) paramDic:@{@"row":self.paramDic[@"row"]}];
        _guideView.tag = 3;
    }
    return _guideView;
}

-(ZSHPickView *)createPickViewWithParamDic:(NSDictionary *)paramDic{
    ZSHPickView *pickView = [[ZSHPickView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) paramDic:paramDic];
    pickView.controller = self;
    return pickView;
}

//门店-提交审核
- (UIView *)createTableHeadView {
    UIView *backgroundView = [[UIView alloc] init];
    UILabel *addLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":self.paramDic[@"storeName"]}];
    addLabel.frame = CGRectMake(15, 17.5, 200, 16);
    UILabel *detailLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":[NSString stringWithFormat:@"%@%@",self.paramDic[@"address"],self.paramDic[@"detailAddress"]], @"font":kPingFangMedium(12)}];
    detailLabel.frame = CGRectMake(15, 46.5, 2000, 16);
    [backgroundView addSubview:addLabel];
    [backgroundView addSubview:detailLabel];
    return backgroundView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
