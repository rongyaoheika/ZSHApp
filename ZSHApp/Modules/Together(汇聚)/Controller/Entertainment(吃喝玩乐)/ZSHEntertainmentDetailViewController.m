//
//  ZSHEntertainmentDetailViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEntertainmentDetailViewController.h"
#import "ZSHEntertainmentHeadView.h"
#import "ZSHEntertainmentDetailCell.h"
#import "ZSHTogetherLogic.h"

@interface ZSHEntertainmentDetailViewController ()

@property (nonatomic, strong) ZSHEntertainmentHeadView          *headView;
@property (nonatomic, strong) ZSHTogetherLogic                  *togetherLogic;

@end

static NSString *ZSHeadCellID = @"ZSHeadCell";
static NSString *ZSListCellID = @"ZSListCell";
static NSString *ZSHEntertainmentDetailCellID = @"ZSHEntertainmentDetailCell";
@implementation ZSHEntertainmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _togetherLogic = [[ZSHTogetherLogic alloc] init];
    
    [self initViewModel];
    [self requestData];
}

- (void)createUI{
    self.title = @"吃喝玩乐";
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, kScreenHeight - KNavigationBarHeight - KBottomNavH);
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHeadCellID];
    [self.tableView registerClass:[ZSHEntertainmentDetailCell class] forCellReuseIdentifier:ZSHEntertainmentDetailCellID];
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"加入" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(contactAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    kWeakSelf(self);
    //头部cell
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    cellModel.height = kRealValue(60);
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHeadCellID];
        [cell.contentView addSubview:self.headView];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
    };
    
    //中间cell
    NSArray *titleArr = @[@"开始时间",@"结束时间",@"期望价格",@"方式",@"人数要求",@"性别要求",@"年龄要求"];
    NSArray *valueArr = @[@"2017-10-1",@"2017-10-7",@"0-1000",@"AA互动趴",@"一对一",@"不限",@"18-30岁"];
    if (_togetherLogic.enterDisModel.STARTTIME.length) {
        ZSHEnterDisModel *model= _togetherLogic.enterDisModel;
        NSString *sex = @"";
        if ([model.CONVERGESEX  isEqualToString:@"0"]) {
            sex = @"女";
        }else if ([model.CONVERGESEX  isEqualToString:@"1"]) {
            sex = @"男";
        } else if ([model.CONVERGESEX  isEqualToString:@"2"]) {
            sex = @"不限";
        }
        valueArr = @[model.STARTTIME,model.ENDTIME,NSStringFormat(@"%@-%@",model.PRICEMIN,model.PRICEMAX) ,model.CONVERGETYPE
                              ,model.CONVERGEPER, sex,NSStringFormat(@"%@-%@",model.AGEMIN,model.AGEMAX)];
    }
    for (int i = 0; i<titleArr.count; i++) {
        cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(40);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
            if (!cell) {
                cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:@"cellid"];
            }

            cell.textLabel.text = titleArr[i];
            cell.detailTextLabel.text = valueArr[i];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
           
        };
    }
    
    //详细要求
    cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    cellModel.height = kRealValue(60);
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHEntertainmentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHEntertainmentDetailCellID];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
        if (weakself.togetherLogic.enterDisModel.CONVERGEDET.length) {
            [cell updateCellWithModel:weakself.togetherLogic.enterDisModel];
        }
        return cell;
    };
    
    return sectionModel;
}

#pragma action
- (void)contactAction{
    [_togetherLogic requestAddOtherPartyWithConvergeDetailID:self.paramDic[@"CONVERGEDETAIL_ID"] success:^(id response) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:cancelAction];
        [self presentViewController:ac animated:YES completion:nil];
    }];
}

#pragma getter
- (ZSHEntertainmentHeadView *)headView{
    if (!_headView) {
        _headView = [[ZSHEntertainmentHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(60)) paramDic:nil];
    }
    return _headView;
}

- (void)requestData {
    kWeakSelf(self);
    
    [_togetherLogic requestPartyListWithConvergeDetailID:self.paramDic[@"CONVERGEDETAIL_ID"] success:^(id response) {
        [weakself initViewModel];
    }];
}

@end
