//
//  ZSHDiscussViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHDiscussViewController.h"
#import "ZSHDiscussCell.h"

static NSString *ZSHDiscussCellID = @"ZSHDiscussCellID";

@interface ZSHDiscussViewController ()

@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation ZSHDiscussViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
    
    //设置cell的估计高度
    self.tableView.estimatedRowHeight = 100;
}

- (void)createUI{
    self.title = @"回复/评论";
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, kScreenWidth, kScreenHeight - KNavigationBarHeight);
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHDiscussCell class] forCellReuseIdentifier:ZSHDiscussCellID];
    
    
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection{
    self.titleArr = @[@"爱跳舞的小丑回复了你：不错", @"假面骑士回复了你：很不错，期待更好的作品", @"Miss_王回复了你：期待！！", @"忘记时间的钟回复了你：棒！"];
    NSArray *date = @[@"10天前", @"20天前", @"20天前", @"20天前"];
    NSArray *content = @[@"like_image_1", @"like_image_2", @"like_image_3", @"like_image_4"];
    NSArray *imageArr = @[@"weibo_head_image",@"fans_image_1", @"fans_image_2", @"fans_image_3"];
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<self.titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = UITableViewAutomaticDimension;
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHDiscussCellID forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"headImage":imageArr[i],@"nickname":self.titleArr[i],@"date":date[i],@"content":content[i]};
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    return sectionModel;
}


@end
