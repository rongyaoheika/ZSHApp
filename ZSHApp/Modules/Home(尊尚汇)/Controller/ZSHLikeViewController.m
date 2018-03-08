//
//  ZSHLikeViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLikeViewController.h"
#import "ZSHLikeCell.h"

static NSString *ZSHZSHLikeCellID = @"ZSHZSHLikeCellID";

@interface ZSHLikeViewController ()

@end

@implementation ZSHLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{

    [self initViewModel];
    self.tableView.estimatedRowHeight = 100;
}

- (void)createUI{
    self.title = @"喜欢";
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, kScreenWidth, kScreenHeight - KNavigationBarHeight);
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHLikeCell class] forCellReuseIdentifier:ZSHZSHLikeCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection{
    NSArray *titleArr = @[@"爱跳舞的小丑喜欢了你的作品：可爱不", @"假面骑士喜欢了你的作品：......", @"Miss_王喜欢了你的作品:不知道说啥", @"忘记时间的钟喜欢了你的作品：好"];
    NSArray *date = @[@"10天前", @"20天前", @"20天前", @"1月前"];
    NSArray *content = @[@"like_image_1", @"like_image_2", @"like_image_3", @"like_image_4"];
    NSArray *imageArr = @[@"weibo_head_image",@"fans_image_1", @"fans_image_2", @"fans_image_3"];
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = UITableViewAutomaticDimension;
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHZSHLikeCellID forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"headImage":imageArr[i],@"nickname":titleArr[i],@"date":date[i],@"content":content[i]};
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    return sectionModel;
}

@end
