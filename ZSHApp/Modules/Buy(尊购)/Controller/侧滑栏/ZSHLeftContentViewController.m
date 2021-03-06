//
//  ZSHLeftContentViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLeftContentViewController.h"
#import "ZSHGoodsMineViewController.h"
#import "RXLSideSlipViewController.h"
#import "ZSHTitleContentViewController.h"
#import "LZCartViewController.h"
#import "ZSHPersonalTailorViewController.h"
#import "ZSHGoodsViewController.h"
#import "RootWebViewController.h"

typedef NS_ENUM(NSInteger, MemberType) {
    MemberTypeEmployee,
    MemberTypeManager,
};
static NSString *ZSHBaseHeadListCellID = @"ZSHBaseHeadListCell";
static NSString *ZSHBaseBottomListCellID = @"ZSHBaseBottomListCell";
@interface ZSHLeftContentViewController ()

@property (nonatomic,assign) MemberType type;
@property (nonatomic,strong) NSArray    *titleArr;
@property (nonatomic,strong) NSArray    *vcArr;
@property (nonatomic,strong) NSArray    *paramDicArr;

@end

@implementation ZSHLeftContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUI];
    [self loadData];
}

- (void)loadData{
    self.titleArr = @[@"",
                      @"商品分类",
                      @"发现",
                      @"购物车",
                      @"炫购",
                      @"私人订制",
                      @"分享赚钱"];
    self.vcArr = @[
                   @"",
                   @"ZSHGoodsViewController",
                   @"ZSHLeftFindViewController",
//                   @"LZCartViewController",
                   @"RootWebViewController",
                   @"ZSHCollectViewController",
                   @"ZSHPersonalTailorViewController",
                   @"ZSHMakeMoneyViewController"];
    self.paramDicArr = @[@{},
                         @{},
                         @{},
                         @{@"url":ZSHLeftShopCartH5},
                         @{},
                         @{},
                         @{}];
    
    
   
    
    [self initViewModel];
   
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight-KBottomNavH);
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseHeadListCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseBottomListCellID];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
    
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<self.titleArr.count; i++) {
        if (i==0) {
            ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
            [sectionModel.cellModelArray addObject:cellModel];
            cellModel.height = kRealValue(150);
            cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
                ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseHeadListCellID forIndexPath:indexPath];
                [cell.contentView addSubview:[weakself createFirstCellView]];
                return cell;
            };
        } else {
            ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
            [sectionModel.cellModelArray addObject:cellModel];
            cellModel.height = kRealValue(55);
            cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
                ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseBottomListCellID forIndexPath:indexPath];
                if (![cell.contentView viewWithTag:2]) {
                    NSDictionary *textLabelDic = @{@"text":self.titleArr[indexPath.row],@"font": kPingFangRegular(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
                    UILabel *textLabel = [ZSHBaseUIControl createLabelWithParamDic:textLabelDic];
                    textLabel.tag = 2;
                    [cell.contentView addSubview:textLabel];
                    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell).offset(kRealValue(30));
                        make.height.mas_equalTo(kRealValue(15));
                        make.centerY.mas_equalTo(cell);
                        make.right.mas_equalTo(cell).offset(-kRealValue(15));
                    }];
                }
               
                return cell;
            };
            
            cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
                RootViewController *vc = nil;
                if (indexPath.row == 3) {//购物车
                    NSString *urlStr = NSStringFormat(@"%@?HONOURUSER_ID=%@",ZSHLeftShopCartH5,HONOURUSER_IDValue);
                    vc =  [[RootWebViewController alloc] initWithParamDic:@{@"url":urlStr}];
                } else {
                    Class className = NSClassFromString(self.vcArr[indexPath.row]);
                    vc = [[className alloc]initWithParamDic:self.paramDicArr[indexPath.row]];
                }
                MainTabBarController *tab = (MainTabBarController *)self.sideSlipVC.contentViewController;
                RootNavigationController *mainNavi = (RootNavigationController *)tab.selectedViewController;
                [mainNavi pushViewController:vc animated:YES];
                 [self.sideSlipVC hideMenuViewController];
            };
        }
    }
    
    return sectionModel;
}

- (UIView *)createFirstCellView{
    UIView *headCellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(150))];
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kRealValue(30), kRealValue(45), kRealValue(50), kRealValue(50))];
    headImageView.layer.cornerRadius = kRealValue(50)/2;
    headImageView.layer.masksToBounds = YES;
    headImageView.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:curUser.PORTRAIT]];
    [headCellView addSubview:headImageView];
    
    NSDictionary *loginBtnDic = @{@"title":@"",@"font":kPingFangMedium(17)};
    UIButton *loginBtn = [ZSHBaseUIControl  createBtnWithParamDic:loginBtnDic target:self action:nil];
    [loginBtn setTitle:curUser.NICKNAME forState:UIControlStateNormal];
    [headCellView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImageView.mas_bottom).offset(kRealValue(15));
        make.height.mas_equalTo(kRealValue(45));
        make.centerX.mas_equalTo(headImageView);
        make.width.mas_equalTo(kRealValue(90));
    }];
    return headCellView;
}

- (void)distributeAction{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
