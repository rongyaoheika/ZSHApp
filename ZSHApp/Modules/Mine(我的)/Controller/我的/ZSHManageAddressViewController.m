//
//  ZSHManageAddressViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHManageAddressViewController.h"
#import "ZSHBaseCell.h"
#import "ZSHPickView.h"
#import "FXBlurView.h"
#import "ZSHTextFieldCellView.h"
#import "ZSHMineLogic.h"

@interface ZSHManageAddressViewController ()

@property (nonatomic, strong) NSArray                   *titleArr;
@property (nonatomic, strong) ZSHPickView               *pickView;
@property (nonatomic, strong) NSArray                   *vcArr;
@property (nonatomic, strong) ZSHMineLogic              *mineLogic;
@end

@implementation ZSHManageAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    self.titleArr = @[@"收货人",@"联系电话",@"所在地区",@"详细地址"];
    self.vcArr = @[@"ZSHManageAddressListViewController",@""];
    _mineLogic = [[ZSHMineLogic alloc] init];
    if (self.paramDic[@"AddrModel"]) {
        _mineLogic.addNewAddr = self.paramDic[@"AddrModel"];
    } else {
        _mineLogic.addNewAddr = [[ZSHAddrModel alloc] init];
    }
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight-KBottomNavH);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self initViewModel];
    [self.tableView reloadData];
}

- (void)createUI{
    self.title = @"收货地址管理";
    [self addNavigationItemWithTitles:@[@"保存"] isLeft:NO target:self action:@selector(saveAction) tags:@[@(1)]];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    NSArray *textFieldTypeArr = @[@(ZSHTextFieldViewUser),@(ZSHTextFieldViewUser),@(ZSHTextFieldViewNone),@(ZSHTextFieldViewUser)];
    
    for (int i = 0; i<self.titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(44);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
            if (!cell) {
                cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleValue2
                                          reuseIdentifier:@"cellId"];
            }
            cell.backgroundColor = KClearColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDictionary *paramDic = @{@"leftTitle":weakself.titleArr[indexPath.row],@"placeholder":@"",@"textFieldType":textFieldTypeArr[indexPath.row],KFromClassType:@(FromAirTicketDetailVCToTextFieldCellView)};
            
            ZSHTextFieldCellView *textFieldCellView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(44)) paramDic:paramDic];
            textFieldCellView.tag = indexPath.row;
            textFieldCellView.textFieldChanged = ^(NSString *text, NSInteger index) {
                if (index == 0) {
                    _mineLogic.addNewAddr.CONSIGNEE = text;
                } else if (index == 1) {
                    _mineLogic.addNewAddr.ADRPHONE = text;
                } else if (index == 3) {
                    _mineLogic.addNewAddr.ADDRESS = text;
                }
            };
            if (indexPath.row == 0) {
                textFieldCellView.textField.text = _mineLogic.addNewAddr.CONSIGNEE;
            } else if (indexPath.row == 1) {
                textFieldCellView.textField.text = _mineLogic.addNewAddr.ADRPHONE;
            } else if (indexPath.row ==2) {
                cell.detailTextLabel.text = _mineLogic.addNewAddr.ADDRESS;
            } else if (indexPath.row ==3) {
                textFieldCellView.textField.text = _mineLogic.addNewAddr.ADDRESS;
            }
            
            [cell.contentView addSubview:textFieldCellView];
            [textFieldCellView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell.contentView);
            }];
            
            if (indexPath.row == 2) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = _mineLogic.addNewAddr.PROVINCE;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            }
            
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            if (indexPath.row == 2 ) {
                weakself.pickView = [weakself createPickViewWithType:WindowRegion];
                weakself.pickView.saveChangeBlock = ^(NSString *text, NSInteger index) {
                    _mineLogic.addNewAddr.PROVINCE = text;
                    [tableView reloadData];
                };
                [weakself.pickView show:WindowRegion];
            } else if (indexPath.row == 0){

            }
            
        };
    }
    
    return sectionModel;
}


#pragma pickView
-(ZSHPickView *)createPickViewWithType:(NSUInteger)type{
    
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
- (void)saveAction{
    if ([SafeStr(_mineLogic.addNewAddr.PROVINCE) isEqualToString:@""] || [SafeStr(_mineLogic.addNewAddr.ADRPHONE) isEqualToString:@""] || [SafeStr(_mineLogic.addNewAddr.ADDRESS) isEqualToString:@""] || [SafeStr(_mineLogic.addNewAddr.CONSIGNEE)  isEqualToString:@""])
        return;
    
    
    kWeakSelf(self);
    _mineLogic.addNewAddr.HONOURUSER_ID = HONOURUSER_IDValue;
    
    if (self.paramDic[@"AddrModel"]) {
        [_mineLogic requestUserEdiShipAdrWithModel:_mineLogic.addNewAddr success:^(id response) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakself.navigationController popViewControllerAnimated:true];
            }];
            [ac addAction:cancelAction];
            [weakself presentViewController:ac animated:YES completion:nil];
        }];
    } else {
        [_mineLogic requestShipAddShipAdr:^(id response) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
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
