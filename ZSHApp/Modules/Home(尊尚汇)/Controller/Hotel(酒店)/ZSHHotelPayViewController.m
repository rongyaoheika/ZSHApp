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
#import "WXApi.h"
#import "ZSHConfirmOrderLogic.h"

@interface ZSHHotelPayViewController ()

@property (nonatomic, strong) ZSHPayView             *payView;
@property (nonatomic, copy)   NSString               *priceStr;
@property (nonatomic, assign) NSInteger              selectedCellRow;
@property (nonatomic, strong) NSArray                *cellParamArr;
@property (nonatomic, strong) ZSHConfirmOrderLogic   *orderLogic;
@property (nonatomic, copy)   NSString               *payType;
@property (nonatomic, strong) NSDictionary           *wechatOrderDic;
@property (nonatomic, strong) NSDictionary           *alipayOrderDic;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aliPayCallBack:) name:kAliPayCallBack object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayCallBack:) name:kWXPayCallBack object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)loadData{
    _payType = @"支付宝";
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
    _orderLogic = [[ZSHConfirmOrderLogic alloc]init];
    NSMutableDictionary *confirmOderDic = self.paramDic[@"confirmOderDic"];
    [confirmOderDic setValue:_payType forKey:@"PAYTYPE"];
    switch (kFromClassTypeValue) {
        case ZSHConfirmOrderToBottomBlurPopView:{
        [_orderLogic requestStoreConfirmOrderWithParamDic:confirmOderDic Success:^(id responseObject) {
            RLog(@"确认订单数据==%@",responseObject);
            [self doPayWith:responseObject];
        } fail:nil];
            break;
        }
        case ZSHSubscribeVCToBottomBlurPopView:{
        [_orderLogic requestHighConfirmOrderWithParamDic:confirmOderDic Success:^(id responseObject) {
            RLog(@"高级特权订单==%@",responseObject);
            [self doPayWith:responseObject];
           
        } fail:nil];
            break;
        }
            
        default:
            break;
    }
}

//调用第三方支付
- (void)doPayWith:(NSDictionary *)responseObject{
    if ([responseObject[@"PAYTYPE"] isEqualToString:@"微信"]) {//微信支付
        _wechatOrderDic = responseObject;
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = responseObject[@"orderStr"][@"partnerId"];
        request.prepayId= responseObject[@"orderStr"][@"prepayId"];
        request.package = responseObject[@"orderStr"][@"package"];
        request.nonceStr= responseObject[@"orderStr"][@"nonceStr"];
        request.sign = responseObject[@"orderStr"][@"sign"];
        NSString *stamp =  responseObject[@"orderStr"][@"timeStamp"];
        request.timeStamp = stamp.intValue;
        [WXApi sendReq:request];
    } else if ([responseObject[@"PAYTYPE"] isEqualToString:@"支付宝"]){//支付宝支付
        _alipayOrderDic = responseObject;
        [[AlipaySDK defaultService] payOrder:responseObject[@"orderStr"] fromScheme:kAppScheme_Alipay callback:nil];
    }
    
}

//弹窗提示支付结果
- (void)showPayResultAlertWithDic:(NSDictionary *)dic{
    [_orderLogic requestPayInfoWithParamDic:@{@"ORDERNUMBER":dic[@"ORDERNUMBER"]} Success:^(id responseObject) {
        UIAlertView *payResultAlert = [[UIAlertView alloc]initWithTitle:@"支付结果" message:responseObject[@"pd"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [payResultAlert show];        
    } fail:nil];
}

//微信支付回调
- (void)wxPayCallBack:(NSNotification *)noti{
    [self showPayResultAlertWithDic:_wechatOrderDic];
}

//支付宝回调
- (void)aliPayCallBack:(NSNotification *)noti{
    [self showPayResultAlertWithDic:_alipayOrderDic];
}


- (void)rightBtnAction:(UIButton *)rightBtn{
    ZSHBaseCell * cell = (ZSHBaseCell *)[[rightBtn superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    // 记录下当前的IndexPath.row
    _payView.selectedCellRow = path.row;
    if (_payView.selectedCellRow == 1) {
        _payType = @"微信";
    } else if(_payView.selectedCellRow == 2){
        _payType = @"支付宝";
    }
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:path.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
