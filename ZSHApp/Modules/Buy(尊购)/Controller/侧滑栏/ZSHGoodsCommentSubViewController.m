//
//  ZSHGoodsCommentSubViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsCommentSubViewController.h"
#import "ZSHWeiBoCell.h"
#import "ZSHWeiBoCellModel.h"
@interface ZSHGoodsCommentSubViewController ()

@property (nonatomic,strong)NSArray             *dataArr;
@property (nonatomic,strong)ZSHWeiBoCellModel   *commentModel;

@end

@implementation ZSHGoodsCommentSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    NSDictionary *paramDic = @{@"avatarPicture":@"weibo_head_image",
                               @"name":@"柯南也要为我哭泣",
                               @"detailText":@"#之前就来过这里，环境很不错，作为我来讲对这种牛排其实是一点都不感冒[撇嘴]，朋友的盛情邀请实在是不好意思拒绝，索性就来瞧瞧，不来不知道，吃过之后给我留下不错的印象，这次来也是带几个朋友来，给他们各种吹嘘这里的好东西多好之类的！！还好吃过之后大家都没有失望的表情。。。总之以后回多多光临的，页希望大家来哦"};
    self.commentModel = [ZSHWeiBoCellModel mj_objectWithKeyValues:paramDic];
    [self initViewModel];
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHWeiBoCell class] forCellReuseIdentifier:NSStringFromClass([ZSHWeiBoCell class])];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    kWeakSelf(self);
    for (int i = 0; i<2; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        kWeakSelf(cellModel);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHWeiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZSHWeiBoCell class])];
            NSDictionary *ndextParamDic = @{KFromClassType:@(ZSHGoodsCommentSubVCToWeiBoCell)};
            [cell updateCellWithParamDic:ndextParamDic];
           
            [cell updateCellWithModel:weakself.commentModel];
             weakcellModel.height = [ZSHWeiBoCell getCellHeightWithModel:weakself.commentModel];
            return cell;
        };
    }
    
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
