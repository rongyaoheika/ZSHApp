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

@interface ZSHCardViewController ()

@property (nonatomic, strong) NSArray            *imageArr;
@property (nonatomic, strong) NSArray            *pushVCsArr;
@property (nonatomic, strong) NSArray            *paramArr;
@property (nonatomic, assign) CGFloat            *headHeight;
@property (nonatomic, strong) NSMutableArray     *selectedArr;




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
    self.imageArr = @[@"glory_card_big",@"glory_card_big",@"glory_card_big"];
    _selectedArr = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    [self initViewModel];
}

- (void)createUI{
    self.title = @"尊尚汇黑卡在线办理";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, KBottomNavH, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHAddressViewID];
    [self.tableView reloadData];
    
    ZSHCardCommitBottomView *bottomView = [[ZSHCardCommitBottomView alloc]initWithFrame:CGRectMake(0, KScreenHeight - KBottomNavH - KBottomHeight, KScreenWidth, KBottomNavH)];
    kWeakSelf(self);
    [bottomView.rightBtn addTapBlock:^(UIButton *btn) {
        [weakself userRegister];
    }];
    [self.view addSubview:bottomView];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeBtnListSectionWithTag:1]];
    [self.tableViewModel.sectionModelArray addObject:[self storeQuotaSection]];

    // 第3，4，5, 6组
    NSArray *sectionParmaDicArr = @[@{KFromClassType:@(FromCustomizedCellToCardSubHeadView),@"title":@"收货地址",@"btnTitle":@"* 未选",@"tag":@(13)},
          @{KFromClassType:@(FromCustomizedCellToCardSubHeadView),@"title":@"选择卡号",@"btnTitle":@"* 随机",@"tag":@(14)},
          @{KFromClassType:@(FromCustomizedCellToCardSubHeadView),@"title":@"功能定制",@"btnTitle":@"* 定制",@"tag":@(15)},
          @{KFromClassType:@(FromCustomizedCellToCardSubHeadView),@"title":@"支付方式",@"btnTitle":@"* 微信",@"tag":@(16)}];
    for (NSDictionary *paramDic in sectionParmaDicArr) {
        ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
        sectionModel.headerHeight = kRealValue(35);
        sectionModel.headerView = [self createHeadViewWithParamDic:paramDic];
        [self.tableViewModel.sectionModelArray addObject:sectionModel];
    }
}

//第0组：
- (ZSHBaseTableViewSectionModel*)storeHeadSection{
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.footerHeight = kRealValue(10);
    sectionModel.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(10))];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(240);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        NSDictionary *nextParamDic = @{KFromClassType:@(FromCardVCToGuideView),@"dataArr":self.imageArr,@"pageViewHeight":@(kRealValue(195)),@"min_scale":@(0.8),@"withRatio":@(1.18),@"pageImage":@"page_press",@"currentPageImage":@"page_normal",@"infinite":@(true)};
        ZSHGuideView *midView = [[ZSHGuideView alloc]initWithFrame:CGRectZero paramDic:nextParamDic];
        [cell.contentView addSubview:midView];
        [midView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell).offset(KLeftMargin);
            make.centerX.mas_equalTo(cell);
            make.width.mas_equalTo(cell);
            make.bottom.mas_equalTo(cell);
        }];
        return cell;
    };
    return sectionModel;
}

//第1组：btn列表
- (ZSHBaseTableViewSectionModel*)storeBtnListSectionWithTag:(NSInteger)tag{
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(95);
    NSArray *titleArr = @[@"至尊会籍卡",@"荣耀会籍卡",@"名人联名卡",@"经典会籍卡",@"12星座卡",@"周易五行卡"];
    NSDictionary *nextParamDic = @{@"titleArr":titleArr,@"normalImage":@"card_normal",@"selectedImage":@"card_press"};
    sectionModel.headerView = [self createBtnListViewWithParamDic:nextParamDic];
    
    return sectionModel;
}

//第2组：本周剩余名额
- (ZSHBaseTableViewSectionModel*)storeQuotaSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(66);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        ZSHCardQuotaView  *cardQuotaView = [[ZSHCardQuotaView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(66))];
        [cell.contentView addSubview:cardQuotaView];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    return sectionModel;
}

//刷新btnList
- (ZSHCardBtnListView *)createBtnListViewWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    ZSHCardBtnListView *listView = [[ZSHCardBtnListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(90)) paramDic:paramDic];
    listView.tag = 2;
    [listView selectedByIndex:5];
    listView.btnClickBlock = ^(UIButton *btn) {
        NSInteger realSection = 1;
        NSInteger btnTag = btn.tag - 1;
        if ([_selectedArr[realSection] isEqualToString:@"0"]) {
            
            [_selectedArr replaceObjectAtIndex:realSection withObject:@"1"];
            [weakself updateBtnListSectionModelWithSectionTag:realSection btnTag:btnTag];
            [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:realSection] withRowAnimation:UITableViewRowAnimationFade];
            
        } else {
            
            [_selectedArr replaceObjectAtIndex:realSection withObject:@"0"];
            [weakself updateBtnListSectionModelWithSectionTag:realSection btnTag:btnTag];
            [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:realSection] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
    return listView;
}

//刷新其它组
- (ZSHCardSubHeadView *)createHeadViewWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    ZSHCardSubHeadView *cardSubView = [[ZSHCardSubHeadView alloc]initWithFrame:CGRectMake(kRealValue(15), 0, kScreenWidth-2*kRealValue(15), kRealValue(35)) paramDic:paramDic];
    cardSubView.backgroundColor = KZSHColor141414;
     
    cardSubView.rightBtnActionBlock = ^(NSInteger tag) {
        NSInteger realSection = tag - 10;
        if ([_selectedArr[realSection] isEqualToString:@"0"]) {
            
            [_selectedArr replaceObjectAtIndex:realSection withObject:@"1"];
            [weakself updateAddressSectionModelWithTag:realSection];
            [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:realSection] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [_selectedArr replaceObjectAtIndex:realSection withObject:@"0"];
            [weakself updateAddressSectionModelWithTag:realSection];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:realSection] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
    return cardSubView;
}

//刷新button列表
- (void)updateBtnListSectionModelWithSectionTag:(NSInteger)tag btnTag:(NSInteger)btnTag{
     ZSHBaseTableViewSectionModel *sectionModel = self.tableViewModel.sectionModelArray[tag];
    if ([_selectedArr[tag] isEqualToString:@"1"])  {
        NSArray *titleArr = nil;
        NSDictionary *nextParamDic = nil;
        CGFloat cellHeight = 0;
        if (btnTag == 4) {
            titleArr = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
            nextParamDic = @{@"titleArr":titleArr,@"normalImage":@"card_normal",@"selectedImage":@"card_layer_press",@"tag":@(2)};
            cellHeight = kRealValue(175);
        } else if (btnTag == 5){
            titleArr = @[@"金",@"木",@"水",@"火",@"土"];
            nextParamDic = @{@"titleArr":titleArr,@"normalImage":@"card_normal",@"selectedImage":@"card_layer_press",@"tag":@(3)};
            cellHeight = kRealValue(90);
        }
        
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = cellHeight;
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                ZSHCardBtnListView *listView = [[ZSHCardBtnListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,cellHeight) paramDic:nextParamDic];
            [cell.contentView addSubview:listView];
            return cell;
        };
      
    } else {
        ZSHBaseTableViewSectionModel *sectionModel = self.tableViewModel.sectionModelArray[tag];
        [sectionModel.cellModelArray removeAllObjects];
        
    }
}

- (void)updateAddressSectionModelWithTag:(NSInteger)tag{
    switch (tag) {
        case 3:{
            NSArray *addressArr = @[@"姓名",@"手机号码",@"重复手机号码",@"省市区",@"详细地址"];
            NSArray *parameterArr = @[@"REALNAME", @"PHONE", @"Repeat", @"PROVINCE",@"ADDRESS"];
            NSArray *textTypeArr =  @[@(ZSHTextFieldViewUser),@(ZSHTextFieldViewPhone),@(ZSHTextFieldViewPhone),@(ZSHTextFieldViewUser),@(ZSHTextFieldViewUser)];
            ZSHBaseTableViewSectionModel *sectionModel = self.tableViewModel.sectionModelArray[tag];
            if ([_selectedArr[tag] isEqualToString:@"1"])  {
                for (NSString *str in addressArr) {
                    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
                    [sectionModel.cellModelArray addObject:cellModel];
                    cellModel.height = kRealValue(35);
                    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
                        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHAddressViewID forIndexPath:indexPath];
                        if (![cell.contentView viewWithTag:2]) {
                            NSDictionary *initParamDic = @{@"placeholder":str,@"textFieldType":textTypeArr[indexPath.row],KFromClassType:@(FromCardVCToTextFieldCellView),@"placeholderTextColor":KZSHColor454545};
                            ZSHTextFieldCellView *textFieldView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectZero paramDic:initParamDic];
                            textFieldView.textFieldChanged = ^(NSString *text,NSInteger tag) {
                                [[NSUserDefaults standardUserDefaults] setObject:text forKey:parameterArr[indexPath.row]];
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
                    };
                }
            } else {
                ZSHBaseTableViewSectionModel *sectionModel = self.tableViewModel.sectionModelArray[tag];
                [sectionModel.cellModelArray removeAllObjects];
            }
            
            break;
        }
            
        case 4:{
            ZSHBaseTableViewSectionModel *sectionModel = self.tableViewModel.sectionModelArray[tag];
            if ([_selectedArr[tag] isEqualToString:@"1"])  {
                    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
                    [sectionModel.cellModelArray addObject:cellModel];
//                     kWeakSelf(cellModel);
                    cellModel.height = kRealValue(1420);
                    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
                        ZSHSelectCardNumCell *cell = [[ZSHSelectCardNumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
//                        [cell selectedByIndex:1];
//                        weakcellModel.height = [cell rowHeightWithCellModel:nil];
                        return cell;
                    };
            } else {
                ZSHBaseTableViewSectionModel *sectionModel = self.tableViewModel.sectionModelArray[tag];
                [sectionModel.cellModelArray removeAllObjects];
            }
            
            break;
        }
        case 5:{
            ZSHBaseTableViewSectionModel *sectionModel = self.tableViewModel.sectionModelArray[tag];
            if ([_selectedArr[tag] isEqualToString:@"1"])  {
                ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
                [sectionModel.cellModelArray addObject:cellModel];
                cellModel.height = kRealValue(423);
                cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
                    ZSHCardCustomizedCell *cell = [[ZSHCardCustomizedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                    return cell;
                };
            } else {
                ZSHBaseTableViewSectionModel *sectionModel = self.tableViewModel.sectionModelArray[tag];
                [sectionModel.cellModelArray removeAllObjects];
            }
            
            break;
        }
        case 6:{
            ZSHBaseTableViewSectionModel *sectionModel = self.tableViewModel.sectionModelArray[tag];
            if ([_selectedArr[tag] isEqualToString:@"1"])  {
                ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
                [sectionModel.cellModelArray addObject:cellModel];
                cellModel.height = kRealValue(74);
                cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
                    ZSHCardPayCell *cell = [[ZSHCardPayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                    return cell;
                };
            } else {
                ZSHBaseTableViewSectionModel *sectionModel = self.tableViewModel.sectionModelArray[tag];
                [sectionModel.cellModelArray removeAllObjects];
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (void)textFieldWithText:(UITextField *)textfield {
    
}

- (void)userRegister {
    NSString *cardNo = SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CARDNO"]);
    NSString *phone = SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"]);
    NSString *realName = SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"REALNAME"]);
    NSString *province = SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"PROVINCE"]);
    NSString *address = SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"ADDRESS"]);
    NSString *custom = SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM"]);
    NSString *customContent = NSStringFormat(@"%@%@", SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CardCustom112311"]),SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CardCustom112312"]));
    
    RLog(@"987%@", @{@"CARDNO":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CARDNO"]),
                @"PHONE":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"]),
                @"REALNAME":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"REALNAME"]),
                @"PROVINCE":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"PROVINCE"]),
                @"ADDRESS":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"ADDRESS"]),
                @"CUSTOM":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM"]),
                @"CUSTOMCONTENT":NSStringFormat(@"%@%@", SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CardCustom112311"]),SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CardCustom112312"]))});
    if (![cardNo isEqual:@""] && ![phone isEqual:@""] && ![realName isEqual:@""] && ![province isEqual:@""] && ![address isEqual:@""] && ![custom isEqual:@""] && ![customContent isEqual:@""]) {
        ZSHLoginLogic *loginLogic = [[ZSHLoginLogic alloc] init];
        [loginLogic userRegisterWithDic:@{@"CARDNO":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CARDNO"]),
                                          @"PHONE":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"]),
                                          @"REALNAME":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"REALNAME"]),
                                          @"PROVINCE":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"PROVINCE"]),
                                          @"ADDRESS":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"ADDRESS"]),
                                          @"CUSTOM":SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM"]),
                                          @"CUSTOMCONTENT":NSStringFormat(@"%@%@", SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CardCustom112311"]),SafeStr([[NSUserDefaults standardUserDefaults] objectForKey:@"CardCustom112312"]))
                                          }];
        
        loginLogic.loginSuccess = ^(id response) {
            RLog(@"请求成功：返回数据&%@",response);
        };
    }
    

}

@end
