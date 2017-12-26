//
//  ZSHEntertainmentViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEntertainmentViewController.h"
#import "ZSHEnterTainmentCell.h"
#import "ZSHEntertainmentModel.h"
#import "ZSHEntertainmentDetailViewController.h"
#import "ZSHEntertainmentDisViewController.h"
#import "ZSHTogetherLogic.h"
#import "ZSHGuideView.h"

@interface ZSHEntertainmentViewController ()

@property (nonatomic, strong) ZSHGuideView         *guideView;
@property (nonatomic, strong) NSMutableArray       *dataArr;
@property (nonatomic, strong) ZSHTogetherLogic     *togetherLogic;

@end

static NSString *ZSHEnterTainmentCellID = @"ZSHEnterTainmentCell";
@implementation ZSHEntertainmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
    [self requestData];
    
}

- (void)createUI{
    self.title = self.paramDic[@"Title"];
    
    [self addNavigationItemWithTitles:@[@"去发布"] isLeft:NO target:self action:@selector(distributeAction) tags:@[@(1)]];

    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHEnterTainmentCell class] forCellReuseIdentifier:ZSHEnterTainmentCellID];
    self.tableView.tableHeaderView = self.guideView;

}

- (ZSHGuideView *)guideView {
    if(!_guideView) {
        NSDictionary *nextParamDic = @{KFromClassType:@(FromTogetherToGuideView),@"pageViewHeight":@(kRealValue(175)),@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false)};
        _guideView = [[ZSHGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(175)) paramDic:nextParamDic];
    }
    return _guideView;
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
    for (int i = 0; i<_togetherLogic.entertainModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        
    
        ZSHEntertainmentModel *model = _togetherLogic.entertainModelArr[i];

        if (model.CONVERGEIMGS.count) {
            cellModel.height = kRealValue(250);
        } else {
            cellModel.height = kRealValue(155);
        }
       
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHEnterTainmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHEnterTainmentCellID];
            ZSHEntertainmentModel *model = weakself.togetherLogic.entertainModelArr[indexPath.row];
            if (indexPath.row == _togetherLogic.entertainModelArr.count-1) {
                
            }
            [cell updateCellWithModel:model];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHEntertainmentDetailViewController *enterTainMentDetailVC = [[ZSHEntertainmentDetailViewController alloc]initWithParamDic:@{@"CONVERGEDETAIL_ID":weakself.togetherLogic.entertainModelArr[indexPath.row].CONVERGEDETAIL_ID}];
            [weakself.navigationController pushViewController:enterTainMentDetailVC animated:YES];
        };
    }
    return sectionModel;
}


- (void)headerRereshing{
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.tableView.mj_header endRefreshing];
    });
}

- (void)footerRereshing{
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.tableView.mj_footer endRefreshing];
    });
}

#pragma action
- (void)distributeAction{
    ZSHEntertainmentDisViewController *disVC = [[ZSHEntertainmentDisViewController alloc]initWithParamDic:@{@"CONVERGE_ID":self.paramDic[@"CONVERGE_ID"]}];
    [self.navigationController pushViewController:disVC animated:YES];
}

- (void)requestData {
    kWeakSelf(self);
    _togetherLogic = [[ZSHTogetherLogic alloc] init];
    [_togetherLogic requestPartyListWithDic:@{@"CONVERGE_ID":self.paramDic[@"CONVERGE_ID"], @"HONOURUSER_ID":@"", @"STATUS":@""} success:^(id response) {
        [weakself initViewModel];
        [weakself.guideView updateViewWithParamDic:@{@"dataArr":response}];
    }];
}

@end
