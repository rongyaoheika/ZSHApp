//
//  ZSHShopCommentViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHShopCommentViewController.h"
#import "CWStarRateView.h"
#import "ZSHShopCommentLogic.h"
#import "ZSHShopCommentModel.h"
#import "ZSHShopCommentCell.h"
#import "ZSHCommentViewController.h"

@interface ZSHShopCommentViewController ()

@property (nonatomic, copy)   NSString              *shopId;
@property (nonatomic,strong)  UIView                *headView;
@property (nonatomic, strong) ZSHShopCommentLogic   *commentLogic;
@property (nonatomic, strong) NSArray               *commentArr;

@end

static NSString *ZSHShopCommentCellID = @"ZSHShopCommentCell";
@implementation ZSHShopCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)createUI{
    self.title = @"用户评价";
    [self addNavigationItemWithTitles:@[@"去发布"] isLeft:NO target:self action:@selector(commentAction) tags:@[@(1)]];
    
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHShopCommentCell class] forCellReuseIdentifier:ZSHShopCommentCellID];
}

- (void)loadData{
    self.shopId = self.paramDic[@"shopId"];
    [self requestData];
    [self initViewModel];
}

- (void)requestData{
    kWeakSelf(self);
    _commentLogic = [[ZSHShopCommentLogic alloc]init];
    NSDictionary *requestParamDic = @{@"SORTHOTEL_ID":self.shopId};
    [_commentLogic requestShopCommentListDataWithParamDic:requestParamDic];
    _commentLogic.requestDataCompleted = ^(NSArray *commentArr){
        weakself.commentArr = commentArr;
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        [weakself initViewModel];
    };
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<self.commentArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        kWeakSelf(cellModel);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHShopCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHShopCommentCellID];
            ZSHShopCommentModel *commentModel = self.commentArr[indexPath.row];
            [cell updateCellWithModel:commentModel];
            weakcellModel.height = commentModel.cellHeight;
            if (i == self.commentArr.count-1) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
            return cell;
        };
    }
    
    return sectionModel;
}


#pragma getter
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0,KNavigationBarHeight, kScreenWidth,kRealValue(80))];
        
        NSDictionary *scoreLabelDic = @{@"text":@"4.9",@"font":kPingFangMedium(24),@"textColor":KZSHColorF29E19};
        UILabel *scoreLabel = [ZSHBaseUIControl createLabelWithParamDic:scoreLabelDic];
        scoreLabel.tag = 1;
        [_headView addSubview:scoreLabel];
        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headView).offset(kRealValue(95));
            make.centerY.mas_equalTo(_headView);
            make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(18)));
        }];
        
        CWStarRateView *starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0,0, kRealValue(134), kRealValue(20)) numberOfStars:5];
        starView.tag = 2;
        starView.scorePercent = 0.40;
        starView.allowIncompleteStar = YES;
        starView.hasAnimation = YES;
        starView.allowUserTap = YES;
        [_headView addSubview:starView];
        [starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_headView);
            make.centerY.mas_equalTo(_headView);
            make.left.mas_equalTo(scoreLabel.mas_right).offset(KLeftMargin);
            make.height.mas_equalTo(kRealValue(20));
        }];
    }
    return _headView;
}

- (void)commentAction{
    NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromShopCommentVCToCommentVC)};
    ZSHCommentViewController *goCommentVC = [[ZSHCommentViewController alloc]initWithParamDic:nextParamDic];
    [self.navigationController pushViewController:goCommentVC animated:YES];
}

-(void)headerRereshing{
    [self requestData];
}

-(void)footerRereshing{
    [self.tableView.mj_footer endRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
