//
//  ZSHCardViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCardViewController.h"
#import "ZSHGuideView.h"
#import "ZSHCardBtnListView.h"
#import "ZSHCardQuotaView.h"
#import "ZSHCardSubHeadView.h"
#import "ZSHTextFieldCellView.h"
#import "ZSHSelectCardNumCell.h"
#import "ZSHCardCustomizedCell.h"
#import "ZSHCardPayCell.h"
#import "ZSHCardCommitBottomView.h"
#import "ZSHLoginLogic.h"
#import "ZSHRegisterModel.h"
#import "ZSHCardImgModel.h"


static NSInteger numCellIndex;
static NSInteger customizedCellIndex;
static NSInteger cardSelectIndex;
@interface ZSHCardViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray            *imageArr;
@property (nonatomic, strong) NSArray            *pushVCsArr;
@property (nonatomic, strong) NSArray            *paramArr;
@property (nonatomic, assign) CGFloat            *headHeight;
@property (nonatomic, strong) NSMutableArray     *selectedArr;          //标记是否展开
@property (nonatomic, strong) ZSHRegisterModel   *registerModel;
@property (nonatomic, strong) ZSHLoginLogic      *loginLogic;
@property (nonatomic, strong) ZSHCardImgModel    *cardImgModel;
@property (nonatomic, assign) NSInteger          typeID;

@property (nonatomic, strong) NSArray            *sectionParmaDicArr;
@property (nonatomic, assign) NSInteger          cardBtnTag;

//收货地址
@property (nonatomic, strong) NSArray            *addressArr;
@property (nonatomic, strong) NSArray            *addressParamArr;
@property (nonatomic, strong) NSArray            *addressTypeArr;

@end

static NSString *ZSHAddressViewID = @"ZSHAddressView";
@implementation ZSHCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _loginLogic = [[ZSHLoginLogic alloc] init];
    _registerModel = [[ZSHRegisterModel alloc] init];
    self.imageArr = @[@"glory_card_big",@"glory_card_big",@"glory_card_big"];
    
    [self requestData:0];
    cardSelectIndex = 0;
    numCellIndex = 0;
    customizedCellIndex = 0;
    _selectedArr = [NSMutableArray arrayWithObjects:@(false),@(false),@(false),@(false),@(false),@(false),@(false), nil];
    _addressArr = @[@"姓名",@"手机号码",@"重复手机号码",@"省市区",@"详细地址"];
    _addressParamArr = @[@"REALNAME", @"PHONE", @"Repeat", @"PROVINCE",@"ADDRESS"];
    _addressTypeArr =  @[@(ZSHTextFieldViewUser),@(ZSHTextFieldViewPhone),@(ZSHTextFieldViewPhone),@(ZSHTextFieldViewUser),@(ZSHTextFieldViewUser)];
    _sectionParmaDicArr = @[
                            @{KFromClassType:@(FromCustomizedCellToCardSubHeadView),@"title":@"收货地址",@"btnTitle":@"* 未选",@"tag":@(13)},
                            @{KFromClassType:@(FromCustomizedCellToCardSubHeadView),@"title":@"选择卡号",@"btnTitle":@"* 随机",@"tag":@(14)},
                            @{KFromClassType:@(FromCustomizedCellToCardSubHeadView),@"title":@"功能定制",@"btnTitle":@"* 定制",@"tag":@(15)},
                            @{KFromClassType:@(FromCustomizedCellToCardSubHeadView),@"title":@"支付方式",@"btnTitle":@"* 微信",@"tag":@(16)}
                            ];
    
    [self.tableView reloadData];
}

- (void)createUI{
    self.title = @"尊尚汇黑卡在线办理";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, KBottomTabH, 0));
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHAddressViewID];
    
    ZSHCardCommitBottomView *bottomView = [[ZSHCardCommitBottomView alloc]initWithFrame:CGRectMake(0, KScreenHeight - KBottomTabH, KScreenWidth, KBottomTabH)];
    kWeakSelf(self);
    [bottomView.rightBtn addTapBlock:^(UIButton *btn) {
        [weakself userRegister:bottomView.rightBtn];
    }];
    [self.view addSubview:bottomView];
}

#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0://卡轮播图
        case 1://卡button集合
        case 2://本周剩余名额
        case 4://选择卡号
        case 5://功能定制
        case 6:{//支付方式
            return 1;
            break;
        }
        case 3:{//收货地址
            return _addressArr.count;
            break;
        }
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return kRealValue(240);
            break;
        }
            
        case 1:{
            if ([_selectedArr[indexPath.section]boolValue]) {//展开
                switch (_cardBtnTag) {
                    case 2://12星座卡
                        return kRealValue(175) + kRealValue(90);
                        break;
                    case 3://周易五行卡
                        return kRealValue(90) + kRealValue(90);
                        break;
                        
                    default:
                        return kRealValue(90);
                        break;
                }
            } else {
                return kRealValue(90);
            }
            
            break;
        }
        case 2:{
            return kRealValue(66);
            break;
        }
        case 3:{
            if ([_selectedArr[indexPath.section]boolValue]) {
                return kRealValue(35);
            }
            break;
        }
        case 4:{
            if ([_selectedArr[indexPath.section]boolValue]) {
                if (numCellIndex == 0) {
                    return kRealValue(120);
                } else {
                    return kRealValue(1200);
                }
            }
            
            break;
        }
        case 5:{
            if ([_selectedArr[indexPath.section]boolValue]) {
                if (customizedCellIndex == 0) {
                    return  kRealValue(380);
                } else if(customizedCellIndex == 1) {
                    return kRealValue(300);
                } else if(customizedCellIndex == 2){
                    return kRealValue(70);
                }
                
            }
            
            break;
        }
            
        case 6:{
            if ([_selectedArr[indexPath.section]boolValue]) {
                return kRealValue(74);
            }
            
            break;
        }
            
        default:
            break;
    }
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return kRealValue(10);
            break;
        }
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 3:
        case 4:
        case 5:
        case 6:{
            return kRealValue(35);
            break;
        }
            
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    kWeakSelf(self);
    switch (section) {
        case 3:
        case 4:
        case 5:
        case 6:{
            ZSHCardSubHeadView *cardSubView = [[ZSHCardSubHeadView alloc]initWithFrame:CGRectMake(kRealValue(15), 0, kScreenWidth-2*kRealValue(15), kRealValue(35)) paramDic:_sectionParmaDicArr[section-3]];
            cardSubView.backgroundColor = KZSHColor141414;
            cardSubView.rightBtnActionBlock = ^(NSInteger tag) {
                if (![_selectedArr[section]boolValue]) {//合并 - 展开
                    
                    [_selectedArr replaceObjectAtIndex:section withObject:@(YES)];
                    [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
                } else { //展开 - 合并
                    
                    [_selectedArr replaceObjectAtIndex:section withObject:@(false)];
                    [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
                }
            };
            return cardSubView;
        }
            break;
            
        default:
            break;
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(10))];
        return footerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    switch (indexPath.section) {
        case 0:{
            ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            if (![cell viewWithTag:9]){
                NSDictionary *nextParamDic = @{KFromClassType:@(FromCardVCToGuideView),@"dataArr":self.imageArr,@"pageViewHeight":@(kRealValue(195)),@"min_scale":@(0.8),@"withRatio":@(1.18),@"pageImage":@"page_press",@"currentPageImage":@"page_normal",@"infinite":@(true)};
                ZSHGuideView *midView = [[ZSHGuideView alloc]initWithFrame:CGRectZero paramDic:nextParamDic];
                midView.tag = 9;
                [cell.contentView addSubview:midView];
                [midView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.contentView).offset(KLeftMargin);
                    make.centerX.mas_equalTo(cell.contentView);
                    make.width.mas_equalTo(cell.contentView);
                    make.bottom.mas_equalTo(cell.contentView);
                }];
            }
            ZSHGuideView *midView = [cell viewWithTag:9];
            if (weakself.cardImgModel.CARDIMGS.count) {
                [midView updateViewWithModel:weakself.cardImgModel];
            }
            return cell;
        }
            
            break;
            
        case 1:{
            ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            if (![cell viewWithTag:2]){
                
                //              NSArray *titleArr = @[@"至尊会籍卡",@"荣耀会籍卡",@"名人联名卡",@"经典会籍卡",@"12星座卡",@"周易五行卡"];
                NSArray *titleArr = @[@"荣耀黑卡",@"名人联名卡",@"12星座卡",@"周易五行卡"];
                NSDictionary *paramDic = @{@"titleArr":titleArr,@"normalImage":@"card_long_normal",@"selectedImage":@"card_long_press",@"btnTag":@(cardSelectIndex)};
                ZSHCardBtnListView *listView = [[ZSHCardBtnListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(90)) paramDic:paramDic];
                listView.tag = 2;
                [cell.contentView addSubview:listView];
                
                //点击同一个btn
                listView.clickSameBtn = ^(UIButton *tempBtn){
                    cardSelectIndex = tempBtn.tag - 1;
                    if (tempBtn.selected) {
                        
                        [_selectedArr replaceObjectAtIndex:indexPath.section withObject:@(YES)];
                        [weakself.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                    } else {
                        
                        [_selectedArr replaceObjectAtIndex:indexPath.section withObject:@(false)];
                        [weakself.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                    }
                };
                
                //点击不同的btn-展开
                listView.btnClickBlock = ^(UIButton *btn) {
                    cardSelectIndex = btn.tag - 1;
                    _cardBtnTag = btn.tag-1;
                    //TODO:可能存在问题
                    [weakself requestData:_cardBtnTag];
                    [_selectedArr replaceObjectAtIndex:indexPath.section withObject:@(YES)];
                    [weakself.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                };
            }
            
            
            if ([_selectedArr[indexPath.section]boolValue])  {//展开
                NSArray *titleArr = nil;
                NSDictionary *nextParamDic = nil;
                if (_cardBtnTag == 2) {
                    titleArr = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
                    nextParamDic = @{@"titleArr":titleArr,@"normalColor":KZSHColor929292,@"selectedColor":KZSHColor1A1A1A,@"tag":@(2)};
                    [weakself requestDetailData:0];
                } else if (_cardBtnTag == 3){
                    titleArr = @[@"金",@"木",@"水",@"火",@"土"];
                    nextParamDic = @{@"titleArr":titleArr,@"normalColor":KZSHColor929292,@"selectedColor":KZSHColor1A1A1A,@"tag":@(3)};
                    [weakself requestDetailData:0];
                }
                
               
                    ZSHCardBtnListView *listView = [[ZSHCardBtnListView alloc]initWithFrame:CGRectMake(0, kRealValue(90), kScreenWidth,0) paramDic:nextParamDic];
                    listView.tag = 3;
                    [cell.contentView addSubview:listView];
                    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.mas_equalTo(cell.contentView).insets(UIEdgeInsetsMake(kRealValue(90), 0, 0, 0));
                    }];
                    listView.btnClickBlock = ^(UIButton *btn) {
                        [weakself requestDetailData:btn.tag-1];
                    };
                }
                
            
            
            return cell;
        }
            
            break;
            
        case 2:{
            ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            ZSHCardQuotaView  *cardQuotaView = [[ZSHCardQuotaView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
            [cell.contentView addSubview:cardQuotaView];
            return cell;
        }
            break;
            
        case 3:{
            if ([_selectedArr[indexPath.section]boolValue]) {
                ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHAddressViewID forIndexPath:indexPath];
                if (![cell.contentView viewWithTag:2]) {
                    NSDictionary *initParamDic = @{@"placeholder":_addressArr[indexPath.row],@"textFieldType":_addressTypeArr[indexPath.row],KFromClassType:@(FromCardVCToTextFieldCellView),@"placeholderTextColor":KZSHColor454545};
                    ZSHTextFieldCellView *textFieldView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectZero paramDic:initParamDic];
                    textFieldView.tag = 2;
                    textFieldView.textFieldChanged = ^(NSString *text,NSInteger tag) {
                        [[NSUserDefaults standardUserDefaults] setObject:text forKey:_addressParamArr[indexPath.row]];
                    };
                    [cell.contentView addSubview:textFieldView];
                    [textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell).offset(kRealValue(KLeftMargin));
                        make.right.mas_equalTo(cell).offset(-kRealValue(KLeftMargin));
                        make.height.mas_equalTo(cell);
                        make.top.mas_equalTo(cell);
                    }];
                }
                return cell;
            }
        }
            
        case 4:{
            if ([_selectedArr[indexPath.section]boolValue]) {
                ZSHSelectCardNumCell *cell = [[ZSHSelectCardNumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                cell.selectIndex = numCellIndex;
                cell.cellHeightBlock = ^(NSInteger index) {
                    numCellIndex = index;
                    [weakself.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                };
                return cell;
            }
        }
            break;
            
        case 5:{
            if ([_selectedArr[indexPath.section]boolValue]) {
                ZSHCardCustomizedCell *cell = [[ZSHCardCustomizedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                cell.selectIndex = customizedCellIndex;
                cell.cellHeightBlock = ^(NSInteger selectIndex) {
                    customizedCellIndex = selectIndex;
                    [weakself.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                };
                return cell;
            }
        }
            break;
            
        case 6:{
            if ([_selectedArr[indexPath.section]boolValue]) {
                ZSHCardPayCell *cell = [[ZSHCardPayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                return cell;
            }
        }
            break;
            
        default:
            break;
    }
    
    return [UITableViewCell new];
}


- (void)textFieldWithText:(UITextField *)textfield {
    
}


- (void)requestData:(NSInteger)index {
    //荣耀黑卡，周易五星卡
    NSArray *type = @[@"390200265979646133", @"390201795059646464"];
    NSString *cardTypeID = nil;
    if (index<2) {
        cardTypeID = type[index];
    } else {
        _typeID = index;
        return;
    }
    
//    NSArray *type = @[@"390181853778149376", @"390200265979646133", @"390201795059646464", @"390201950420860928"];
//    NSString *cardTypeID = nil;
//    if (index<4) {
//        cardTypeID = type[index];
//    } else {
//        _typeID = index;
//        return;
//    }
    
    kWeakSelf(self);
    [_loginLogic requestCardImgsWithDic:@{@"CARDTYPE_ID":cardTypeID} success:^(id response) {
        weakself.cardImgModel = [ZSHCardImgModel mj_objectWithKeyValues:response[@"pd"]];
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)requestDetailData:(NSInteger)index {
    NSArray *constellation = @[@"390202047296700416", @"390202895984754688", @"390202951949352960", @"390202999533731840",
                               @"390203316828635136", @"390203446780755968", @"390203482788855808", @"390203541202927616",
                               @"390203583108218880", @"390203751593410560", @"390203784837464064", @"390203822426816512"];
    NSArray *fiveLine = @[@"390202180738482176", @"390202468161552384", @"390202526550458368", @"390202622746820608", @"390202686642847744"];
    
    NSString *cardTypeID = nil;
    if (_typeID == 2) { // 12星座
        cardTypeID = constellation[index];
    }  else { //周易五行卡
        cardTypeID = fiveLine[index];
    }
    kWeakSelf(self);
    [_loginLogic requestCardImgsWithDic:@{@"CARDTYPE_ID":cardTypeID} success:^(id response) {
        weakself.cardImgModel = [ZSHCardImgModel mj_objectWithKeyValues:response[@"pd"]];
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)userRegister:(UIButton *)registerBtn {
    NSString *cardNo = SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CARDNO"]);
    NSString *phone = SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"]);
    NSString *realName = SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"REALNAME"]);
    NSString *province = SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"PROVINCE"]);
    NSString *address = SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"ADDRESS"]);
    NSString *custom = SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM"]);
    NSString *customContent = NSStringFormat(@"%@%@", SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CardCustom112311"]),SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CardCustom112312"]));
    
    NSString *message = nil;
    if ([cardNo isEqualToString:@""]) {
        message = @"请选择号码";
    } else if ([phone isEqualToString:@""]) {
        message = @"请填写手机号码";
    } else if ([realName isEqualToString:@""]) {
        message = @"请填写姓名";
    } else if ([province isEqualToString:@""]) {
        message = @"请填写省份";
    } else if ([address isEqualToString:@""]) {
        message = @"请填写地址";
    } else if ([custom isEqualToString:@""]) {
        message = @"请选择功能定制";
    } else if ([customContent isEqualToString:@""]) {
        message = @"请填写定制内容";
    }
    
    if(message) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [ac addAction:cancelAction];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    
    //    if (![cardNo isEqual:@""] && ![phone isEqual:@""] && ![realName isEqual:@""] && ![province isEqual:@""] && ![address isEqual:@""] && ![custom isEqual:@""] && ![customContent isEqual:@""]) {
    
    [_loginLogic userRegisterWithDic:@{@"CARDNO":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CARDNO"]),
                                       @"PHONE":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"]),
                                       @"REALNAME":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"REALNAME"]),
                                       @"PROVINCE":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"PROVINCE"]),
                                       @"ADDRESS":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"ADDRESS"]),
                                       @"CUSTOM":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM"]),
                                       @"CUSTOMCONTENT":NSStringFormat(@"%@%@", SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CardCustom112311"]),SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CardCustom112312"]))
                                       } btn:registerBtn];
    
    _loginLogic.loginSuccess = ^(id response) {
        RLog(@"请求成功：返回数据&%@",response);
        if ([response[@"result"]isEqualToString:@"01"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提交审核成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
        //10s之后可重复点击提交审核按钮
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            registerBtn.enabled = YES;
        });
    };
    
}


- (void)headViewAction{
    
}

@end
