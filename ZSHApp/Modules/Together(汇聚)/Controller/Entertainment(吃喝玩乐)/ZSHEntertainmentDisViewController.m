//
//  ZSHEntertainmentDisViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEntertainmentDisViewController.h"
#import "ZSHDetailDemandViewController.h"
#import "ZSHBottomBlurPopView.h"
#import "ZSHPickView.h"
#import "ZSHTogetherLogic.h"

@interface ZSHEntertainmentDisViewController ()

@property (nonatomic, strong) NSArray                   *pushVCsArr;
@property (nonatomic, strong) NSArray                   *paramArr;
@property (nonatomic, strong) NSArray                   *titleArr;
@property (nonatomic, strong) NSMutableArray            *detailTitleArr;
@property (nonatomic, strong) ZSHBottomBlurPopView      *bottomBlurPopView;
@property (nonatomic, strong) ZSHPickView               *pickView;
@property (nonatomic, strong) ZSHTogetherLogic          *togetherLogic;

@end
static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHEntertainmentDisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _togetherLogic = [[ZSHTogetherLogic alloc] init];
    self.titleArr = @[@"开始时间",@"结束时间",@"期望价格",@"方式",@"人数要求",@"性别要求",@"年龄要求",@"详细要求"];
    self.detailTitleArr = [NSMutableArray arrayWithArray:@[@"2017-10-1",@"2017-10-7",@"0-1000",@"AA互动趴",@"一对一",@"不限",@"18-30岁",@" "]];
    [self initViewModel];
}

- (void)createUI{
    self.title = @"吃喝玩乐";
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, kScreenWidth, kScreenHeight - KNavigationBarHeight);
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"发布" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(distributeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<self.titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(40);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
             ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ZSHBaseCellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = weakself.titleArr[i];
            cell.textLabel.font = kPingFangRegular(14);
            cell.detailTextLabel.text = weakself.detailTitleArr[i];
            cell.detailTextLabel.font = kPingFangRegular(14);
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            if(indexPath.row == 0||indexPath.row == 1){//开始，结束时间
                NSDictionary *nextParamDic = @{@"type":@(WindowBirthDay),@"midTitle":@"生日"};
                weakself.pickView = [weakself createPickViewWithParamDic:nextParamDic];
                weakself.pickView.tag = indexPath.row;
                weakself.pickView.saveChangeBlock = ^(NSString *text,NSInteger tag) {
                    if (tag == 0) {
                        _togetherLogic.enterDisModel.STARTTIME = text;
                        
                    } else {
                        _togetherLogic.enterDisModel.ENDTIME = text;
                    }
                    weakself.detailTitleArr[indexPath.row] = text;
                    [weakself.tableView reloadData];
                };
                [weakself.pickView show:WindowBirthDay];
            } else if (indexPath.row == 2) {//期望价格
                NSMutableArray *priceMArr = [[NSMutableArray alloc]init];
                for (int i = 0; i<=1000; i+=100) {
                    NSString *priceSingle = [NSString stringWithFormat:@"%d",i];
                    [priceMArr addObject:priceSingle];
                }
                NSDictionary *nextParamDic = @{@"type":@(WindowPrice),@"midTitle":@"期望价格",@"dataArr":priceMArr};
                weakself.pickView = [weakself createPickViewWithParamDic:nextParamDic];
                [weakself.pickView show:WindowPrice];
                weakself.pickView.saveChangeBlock= ^(NSString *text,NSInteger tag) {
//                  _togetherLogic.enterDisModel.PRICEMIN
//                  _togetherLogic.enterDisModel.PRICEMAX
                    weakself.detailTitleArr[indexPath.row] = text;
                };
            } else if (indexPath.row == 3) {//方式
                NSArray *togetherArr = @[@"不限",@"给力邀约",@"AA互动趴"];
                NSDictionary *nextParamDic = @{@"type":@(WindowTogether),@"midTitle":@"方式选择",@"dataArr":togetherArr};
                weakself.pickView = [weakself createPickViewWithParamDic:nextParamDic];
                [weakself.pickView show:WindowTogether];
            } else if (indexPath.row == 6){//年龄要求
                ZSHBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                weakself.bottomBlurPopView = [weakself createBottomBlurPopViewWith:ZSHFromAirplaneAgeVCToBottomBlurPopView];
                [kAppDelegate.window addSubview:self.bottomBlurPopView];
                weakself.bottomBlurPopView.confirmOrderBlock = ^(NSDictionary *paramDic) {
                    cell.detailTextLabel.text = paramDic[@"ageRange"];
                };
            } else if (indexPath.row == 7) {//详细要求
                ZSHDetailDemandViewController *hotelDetailVC = [[ZSHDetailDemandViewController alloc] init];
                [weakself.navigationController pushViewController:hotelDetailVC animated:YES];
            }
        };
    }
    return sectionModel;
}

#pragma action
- (void)distributeAction{
    
}

#pragma getter
- (ZSHBottomBlurPopView *)createBottomBlurPopViewWith:(ZSHFromVCToBottomBlurPopView)fromClassType{
    NSDictionary *nextParamDic = @{KFromClassType:@(fromClassType),@"typeText":@"年龄选择"};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    bottomBlurPopView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [bottomBlurPopView setBlurEnabled:NO];
    return bottomBlurPopView;
}

- (ZSHPickView *)createPickViewWithParamDic:(NSDictionary *)paramDic{
    ZSHPickView *pickView = [[ZSHPickView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) paramDic:paramDic];
    pickView.controller = self;
    return pickView;
}

- (void)requestData {
    
    NSDictionary *dic = @{@"STARTTIME":@"",
                          @"ENDTIME":@"",
                          @"PRICEMIN":@"",
                          @"PRICEMAX":@"",
                          @"CONVERGETYPE":@"",
                          @"CONVERGEPER":@"",
                          @"CONVERGESEX":@"",
                          @"AGEMIN":@"",
                          @"AGEMAX":@"",
                          @"CONVERGEDET":@"",
                          @"CONVERGETITLE":@"",
                          @"HONOURUSER_ID":@""};

    [_togetherLogic requestAddDetailParty:dic success:^(id response) {
        
    }];
}


@end
