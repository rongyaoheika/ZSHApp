//
//  ZSHHotelPayViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelPayViewController.h"
#import "ZSHHotelPayHeadCell.h"

#import "ZSHHotelModel.h"
#import "ZSHHotelModel.h"
#import "ZSHPayView.h"
#import <AlipaySDK/AlipaySDK.h>

@interface ZSHHotelPayViewController ()

@property (nonatomic, strong) ZSHPayView             *payView;
@property (nonatomic, copy)   NSString               *priceStr;
@property (nonatomic, assign) NSInteger              selectedCellRow;
@property (nonatomic, strong) NSArray                *cellParamArr;

@end

static NSString *ZSHHotelPayHeadCellID = @"ZSHHotelPayHeadCell";
static NSString *ZSHBasePriceCellID = @"ZSHBasePriceCell";

@implementation ZSHHotelPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    NSDictionary *paramDic = self.paramDic[@"listDic"];
   
    switch ([self.paramDic[@"shopType"]integerValue]) {
        case ZSHFoodShopType:{
             _priceStr = [NSString stringWithFormat:@"订单金额¥%@",paramDic[@"FOODDETPRICE"]];
            break;
        }
        case ZSHHotelShopType:{
            _priceStr = [NSString stringWithFormat:@"订单金额¥%@",paramDic[@"HOTELDETPRICE"]];
            break;
        }
        case ZSHKTVShopType:{
            _priceStr = [NSString stringWithFormat:@"订单金额¥%@",paramDic[@"KTVDETPRICE"]];
            break;
        }
        case ZSHBarShopType:{
            _priceStr = [NSString stringWithFormat:@"订单金额¥%@",paramDic[@"BARDETPRICE"]];
            break;
        }
        case ZSHShipType:{
            _priceStr = [NSString stringWithFormat:@"订单金额¥%@",self.paramDic[@"requestDic"][@"YACHTPRICE"]];
            
            break;
        }
        default:
            break;
    }
   
    [self initViewModel];
    
    
}

- (void)createUI{
    self.title = @"订单支付";
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight-KBottomNavH);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHHotelPayHeadCell class] forCellReuseIdentifier:ZSHHotelPayHeadCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBasePriceCellID];
    [self.tableView reloadData];
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storePriceSection]];
    
    kWeakSelf(self);
    NSDictionary *nextParamDic = @{@"title":@"支付方式"};
    _payView = [[ZSHPayView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(40)) paramDic:nextParamDic];
    [self.tableViewModel.sectionModelArray addObject:[_payView storePaySection]];
    _payView.rightBtnBlcok = ^(UIButton *btn) {
        [weakself rightBtnAction:btn];
    };
}

//head
- (ZSHBaseTableViewSectionModel*)storeHeadSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(150);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelPayHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelPayHeadCellID forIndexPath:indexPath];
        cell.showCellType = ZSHNormalType;
        cell.shopType = [weakself.paramDic[@"shopType"]integerValue];
        [cell updateCellWithParamDic:weakself.paramDic];

        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
    };
    return sectionModel;
}

//价格
- (ZSHBaseTableViewSectionModel*)storePriceSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(40);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHBasePriceCellID];
        cell.textLabel.text = _priceStr;
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
    };
    return sectionModel;
}

#pragma action
- (void)payBtnAction{
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:self.paramDic[@"orderStr"] fromScheme:kAppScheme_Alipay callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        if ([resultDic[@"resultStatus"]isEqualToString:@"9000"]) {
            UIAlertView *payResultAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [payResultAlert show];
        }
    }];
    
}

- (void)rightBtnAction:(UIButton *)rightBtn{
    ZSHBaseCell * cell = (ZSHBaseCell *)[[rightBtn superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    // 记录下当前的IndexPath.row
    _payView.selectedCellRow = path.row;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:path.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
