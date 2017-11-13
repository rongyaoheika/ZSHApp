//
//  ZSHUserInfoViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHUserInfoViewController.h"
#import "ZSHSimpleCellView.h"
#import "ZSHMultiInfoViewController.h"

@interface ZSHUserInfoViewController ()

@property (nonatomic, strong) NSArray            *pushVCsArr;
@property (nonatomic, strong) NSArray            *paramArr;
@property (nonatomic, strong) NSArray            *titleArr;
@property (nonatomic, strong) NSArray            *detailTitleArr;

@end
static NSString *ZSHBaseCellID = @"ZSHBaseCell";

@implementation ZSHUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.titleArr = @[@[@"头像",@"昵称",@"姓名",@"性别",@"生日",@"卡号",@"地区",@"个性签名"],
                      @[@"身份证号",@"手机号",@"QQ号码",@"微信",@"新浪微博",@"支付宝"]
                      ];
    self.detailTitleArr = @[@[@"UIImage",@"萌",@"江萌",@"女",@"1990年1月1日",@"86868686",@"北京市东城区",@"你是我最重要的决定"],
                            @[@"130625********1456",@"18888888888",@"",@"未绑定",@"",@""]];
    
    self.pushVCsArr = @[
    @[@"ZSHTitleContentViewController",@"ZSHMultiInfoViewController",@"",@"ZSHAirPlaneViewController",@"",@"",@"",@""],
       @[@"",@"ZSHMultiInfoViewController",@"ZSHMultiInfoViewController",@"",@"",@""]
];
    
    self.paramArr = @[
                      @[@{},@{KFromClassType:@(FromUserInfoNickNameVCToMultiInfoVC),@"title":@"修改昵称",@"rightNaviTitle":@"保存",@"bottomBtnTitle":@"下一步"},@{},@{},@{},@{},@{},@{}],
  @[@{},@{KFromClassType:@(FromUserInfoPhoneVCToMultiInfoVC),@"title":@"更改手机号码",@"bottomBtnTitle":@"提交"},@{KFromClassType:@(FromUserInfoQQVCToMultiInfoVC),@"title":@"绑定QQ帐号",@"rightNaviTitle":@"授权"},@{},@{},@{}]];
    
    [self initViewModel];
}

- (void)createUI{
    self.title = @"个人资料";
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, kScreenWidth, kScreenHeight - KNavigationBarHeight);
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeFirstSection]];
     [self.tableViewModel.sectionModelArray addObject:[self storeSecondSection]];
}

//第一组
- (ZSHBaseTableViewSectionModel*)storeFirstSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<[self.titleArr[0] count]; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = (i==0? kRealValue(55):kRealValue(43));
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            
            NSDictionary *nextParamDic = @{@"leftTitle":weakself.titleArr[0][indexPath.row],@"rightTitle":weakself.detailTitleArr[0][indexPath.row],@"row":@(indexPath.row)};
            ZSHSimpleCellView *cellView = [[ZSHSimpleCellView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(43)) paramDic:nextParamDic];
            [cell.contentView addSubview:cellView];
            [cellView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell);
            }];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            Class className = NSClassFromString(self.pushVCsArr[0][indexPath.row]);
            RootViewController *vc = [[className alloc]initWithParamDic:weakself.paramArr[0][indexPath.row]];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    return sectionModel;
}

//第二组
- (ZSHBaseTableViewSectionModel*)storeSecondSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(30);

    sectionModel.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(30))];
    sectionModel.headerView.backgroundColor = [UIColor colorWithHexString:@"141414"];
    NSDictionary *headTitleLabelDic = @{@"text":@"以下为非公开信息",@"font":kPingFangRegular(11)};
    UILabel *headLabel =  [ZSHBaseUIControl createLabelWithParamDic:headTitleLabelDic];
    headLabel.frame = CGRectMake(kRealValue(15), 0, kScreenWidth - 2*kRealValue(30), kRealValue(30));
    [sectionModel.headerView addSubview:headLabel];
    
    for (int i = 0; i<[self.titleArr[1] count]; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(43);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            
            NSDictionary *nextParamDic = @{@"leftTitle":weakself.titleArr[1][indexPath.row],@"rightTitle":weakself.detailTitleArr[1][indexPath.row],@"row":@(indexPath.row)};
            ZSHSimpleCellView *cellView = [[ZSHSimpleCellView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(43)) paramDic:nextParamDic];
            [cell.contentView addSubview:cellView];
            [cellView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell);
            }];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            Class className = NSClassFromString(self.pushVCsArr[1][indexPath.row]);
            RootViewController *vc = [[className alloc]initWithParamDic:weakself.paramArr[1][indexPath.row]];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
