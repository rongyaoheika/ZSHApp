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

@interface ZSHEntertainmentViewController ()

@property (nonatomic, strong)NSMutableArray           *dataArr;

@end

static NSString *ZSHEnterTainmentCellID = @"ZSHEnterTainmentCell";
@implementation ZSHEntertainmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
   
    NSArray *baseDataArr = @[
                             @{@"avatarPicture":@"weibo_head_image",@"name":@"完成全部任务",@"gender":@(0),@"distance":@(1.7),@"age":@(19),@"constellation":@"摩羯座",@"title":@"麦乐迪KTV嗨起来 ",@"detailImage":@"entertainment_image_1",@"beginTime":@"2017年10月1日",@"endTime":@"2017年10月8日",@"personCount":@"一对一",@"mode":@"AA互动趴"},
                              @{@"avatarPicture":@"weibo_head_image",@"name":@"完成全部任务",@"gender":@(1),@"distance":@(2.7),@"age":@(29),@"constellation":@"金牛座",@"title":@"麦乐迪KTV嗨起来 ",@"detailImage":@"entertainment_image_1",@"beginTime":@"2017年10月1日",@"endTime":@"2017年10月8日",@"personCount":@"一对一",@"mode":@"AA互动趴"}
                             ];
    self.dataArr = [ZSHEntertainmentModel mj_objectArrayWithKeyValuesArray:baseDataArr];
     [self initViewModel];
}

- (void)createUI{
    self.title = @"吃喝玩乐";
    [self addNavigationItemWithTitles:@[@"去发布"] isLeft:NO target:self action:@selector(distributeAction) tags:@[@(1)]];
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHEnterTainmentCell class] forCellReuseIdentifier:ZSHEnterTainmentCellID];
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
    for (int i = 0; i<self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(250);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHEnterTainmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHEnterTainmentCellID];
            ZSHEntertainmentModel *model = self.dataArr[indexPath.row];
            [cell updateCellWithModel:model];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHEntertainmentDetailViewController *enterTainMentDetailVC = [[ZSHEntertainmentDetailViewController alloc]init];
            [weakself.navigationController pushViewController:enterTainMentDetailVC animated:YES];
        };
    }
    return sectionModel;
}

#pragma action
- (void)distributeAction{
   
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
