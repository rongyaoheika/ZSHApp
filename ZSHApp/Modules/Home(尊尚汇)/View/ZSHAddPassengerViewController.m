//
//  ZSHAddPassengerViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHAddPassengerViewController.h"
#import "ZSHTextFieldCellView.h"

static NSString *ZSHAddPassengerCellID = @"ZSHAddPassengerCellID";

@interface ZSHAddPassengerViewController ()

@property (nonatomic, strong) NSMutableArray *titleArr;


@end

@implementation ZSHAddPassengerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _titleArr = @[@"乘客姓名", @"乘客类型", @"证件类型", @"证件号码"];
}

- (void)createUI{
    self.title = @"添加新乘客";
    
    [self addNavigationItemWithTitles:@[@"保存"] isLeft:NO target:self action:@selector(saveAction) tags:@[@(1)]];
    
     
//    UILabel *nameLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"乘客姓名",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
//    [self.view addSubview:nameLabel];
//    
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.mas_equalTo(self.view).offset(kRealValue(KLeftMargin));
//        make.size.mas_equalTo(CGSizeMake(kRealValue(58), kRealValue(15)));
//    }];
//    
//    UITextField *nameTextField = [[UITextField alloc] init];
//    nameTextField.font = [UIFont systemFontOfSize:14.0];
//    nameTextField.placeholder = @"必填";
//    [nameTextField setValue:KZSHColor454545 forKeyPath:@"_placeholderLabel.textColor"];
//    [self.view addSubview:nameTextField];
//    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(nameLabel);
//        make.left.mas_equalTo(nameLabel).offset(kRealValue(19+56));
//        make.size.mas_equalTo(CGSizeMake(kRealValue(255), kRealValue(15)));
//    }];
//    
//    
//    UILabel *typeLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"乘客类型",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
//    [self.view addSubview:typeLabel];
//    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(nameLabel).offset(kRealValue(45));
//        make.left.mas_equalTo(nameLabel);
//        make.size.mas_equalTo(CGSizeMake(kRealValue(58), kRealValue(15)));
//    }];
//    
//    NSArray *typenameArr = @[@"成人票", @"学生票", @"儿童票"];
//    for (int i = 0; i < 3; i++) {
//        UIButton *btn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":typenameArr[i],@"font":kPingFangRegular(15)}];
//        btn.layer.borderWidth = 0.5;
//        btn.layer.borderColor = KZSHColor929292.CGColor;
//        [self.view addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.view).offset(kRealValue(57));
//            make.left.mas_equalTo(self.view).offset(kRealValue(90+i*80));
//            make.size.mas_equalTo(CGSizeMake(kRealValue(70), kRealValue(25)));
//        }];
//    }
//    
//    UILabel *IDTypeLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"证件类型",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
//    [self.view addSubview:IDTypeLabel];
//    [IDTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(typeLabel).offset(kRealValue(45));
//        make.left.mas_equalTo(typeLabel);
//        make.size.mas_equalTo(CGSizeMake(kRealValue(58), kRealValue(15)));
//    }];
//    
//    UILabel *IDLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"身份证",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
//    [self.view addSubview:IDLabel];
//    [IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(IDTypeLabel);
//        make.left.mas_equalTo(IDTypeLabel).offset(kRealValue(90));
//        make.size.mas_equalTo(CGSizeMake(kRealValue(43), kRealValue(15)));
//    }];
//    
//    
//    UIButton *IDSelectBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"withImage":@(YES),@"normalImage":@"mine_next"}];
//    [self.view addSubview:IDSelectBtn];
//    [IDSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(IDTypeLabel);
//        make.right.mas_equalTo(self.view).offset(kRealValue(-KLeftMargin));
//        make.size.mas_equalTo(CGSizeMake(kRealValue(9), kRealValue(14)));
//    }];
//    
//    
//    UILabel *IDNumLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"证件号码",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
//    [self.view addSubview:IDNumLabel];
//    [IDNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(IDTypeLabel).offset(kRealValue(45));
//        make.left.mas_equalTo(IDTypeLabel);
//        make.size.mas_equalTo(CGSizeMake(kRealValue(58), kRealValue(15)));
//    }];
//    
//    
//    UITextField *IDNumTextField = [[UITextField alloc] init];
//    IDNumTextField.font = [UIFont systemFontOfSize:14.0];
//    IDNumTextField.placeholder = @"必填";
//    [IDNumTextField setValue:KZSHColor454545 forKeyPath:@"_placeholderLabel.textColor"];
//    [self.view addSubview:IDNumTextField];
//    [IDNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(IDNumLabel);
//        make.left.mas_equalTo(IDNumLabel).offset(kRealValue(19+56));
//        make.size.mas_equalTo(CGSizeMake(kRealValue(255), kRealValue(15)));
//    }];
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight - KNavigationBarHeight);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHAddPassengerCellID];
    [self.tableView reloadData];
    
   [self initViewModel];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection{
    
    NSArray *placeHolderArr = @[@"必填", @"", @"身份证", @"必填", @"请选择", @"请选择", @"必填", @"请选择", @"请选择", @"请选择", @"请选择"];
    NSArray *textFieldTypeArr = @[@(ZSHTextFieldViewUser), @(ZSHTextFieldViewNone), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser), @(ZSHTextFieldViewUser)];
    NSArray *placeHolderColor = @[KZSHColor454545, KZSHColor454545, KZSHColor454545, KZSHColor454545, KZSHColor454545, KZSHColor454545, KZSHColor454545, KZSHColor454545, KZSHColor454545, KZSHColor454545, KZSHColor454545, KZSHColor454545, KZSHColor454545, KZSHColor454545, KZSHColor454545];
    NSArray *haveArrow = @[@(false), @(false), @(true), @(false), @(true), @(true), @(false), @(true), @(true), @(true), @(true)];
    
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < _titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(44);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHAddPassengerCellID forIndexPath:indexPath];
            
            NSDictionary *paramDic = @{@"leftTitle":_titleArr[indexPath.row],@"placeholder":placeHolderArr[indexPath.row],@"textFieldType":textFieldTypeArr[indexPath.row],KFromClassType:@(FromLoginVCToTextFieldCellView), @"placeholderTextColor":placeHolderColor[indexPath.row]};
            ZSHTextFieldCellView *textFieldView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(44)) paramDic:paramDic];
            [cell.contentView addSubview:textFieldView];
            [textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell.contentView);
            }];
            
            if ([haveArrow[indexPath.row] isEqual:@(true)]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            if (indexPath.row == 1) {
                NSArray *typenameArr = @[@"成人票", @"学生票", @"儿童票"];
                for (int i = 0; i < 3; i++) {
                    UIButton *btn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":typenameArr[i],@"font":kPingFangRegular(15)}];
                    btn.layer.borderWidth = 0.5;
                    btn.layer.borderColor = KZSHColor929292.CGColor;
                    btn.tag = 1116+i;
                    [btn addTapBlock:^(UIButton *btn) {
                        [self selectPassengerType:btn];
                    }];
                    [cell.contentView addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.contentView).offset(kRealValue(9));
                        make.left.mas_equalTo(cell.contentView).offset(kRealValue(90+i*80));
                        make.size.mas_equalTo(CGSizeMake(kRealValue(70), kRealValue(25)));
                    }];
                }
            }
            
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    return sectionModel;
}

#pragma action

- (void)selectPassengerType:(UIButton *)btn {
    if ((btn.tag - 1116) == 1) {
        _titleArr = @[@"乘客姓名", @"乘客类型", @"证件类型", @"证件号码", @"学校省份",@"学校名称", @"学号", @"学制", @"入学年份",@"优惠区间", @"至"];
    } else {
        _titleArr = @[@"乘客姓名", @"乘客类型", @"证件类型", @"证件号码"];
    }
    [self initViewModel];
    [self.tableView reloadData];
}

- (void)saveAction {
    
}

@end
