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
#import "ZSHPickView.h"
#import "ZSHEntertainmentDisViewController.h"

@interface ZSHEntertainmentDetailViewController ()

@property (nonatomic, strong) ZSHPickView                       *pickView;
@property (nonatomic, strong) ZSHEntertainmentHeadView          *headView;

@end

static NSString *ZSHeadCellID = @"ZSHeadCell";
static NSString *ZSListCellID = @"ZSListCell";
static NSString *ZSHEntertainmentDetailCellID = @"ZSHEntertainmentDetailCell";
@implementation ZSHEntertainmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
}

- (void)createUI{
    self.title = @"吃喝玩乐";
    
    [self addNavigationItemWithTitles:@[@"去发布"] isLeft:NO target:self action:@selector(distributeAction) tags:@[@(1)]];
    
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
    [self.bottomBtn setTitle:@"约TA" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(contactAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
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
            if (indexPath.row == 4) {
                weakself.pickView = [weakself createPickViewWithType:WindowTogether];
                [weakself.pickView show:WindowTogether];
            } else if(indexPath.row == 1||indexPath.row == 2){
                weakself.pickView = [weakself createPickViewWithType:WindowBirthDay];
                [weakself.pickView show:WindowBirthDay];
            } 
           
        };
    }
    
    //详细要求
    cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    cellModel.height = kRealValue(60);
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHEntertainmentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHEntertainmentDetailCellID];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
        return cell;
    };
    
    return sectionModel;
}

#pragma action
- (void)contactAction{
    
}

- (void)distributeAction{
    ZSHEntertainmentDisViewController *disVC = [[ZSHEntertainmentDisViewController alloc]init];
    [self.navigationController pushViewController:disVC animated:YES];
}

#pragma getter
- (ZSHEntertainmentHeadView *)headView{
    if (!_headView) {
        _headView = [[ZSHEntertainmentHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(60)) paramDic:nil];
    }
    return _headView;
}

-(ZSHPickView *)createPickViewWithType:(NSUInteger)type{
    ZSHPickView *pickView = [[ZSHPickView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) type:type];
    pickView.controller = self;
    return pickView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
