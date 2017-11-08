//
//  ZSHActivityViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHActivityViewController.h"
#import "ZSHEnterTainmentCell.h"
#import "ZSHEntertainmentModel.h"

@interface ZSHActivityViewController ()

@property (nonatomic, strong)NSMutableArray           *dataArr;

@end

static NSString *ZSHEnterTainmentCellID = @"ZSHEnterTainmentCell";

@implementation ZSHActivityViewController

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
    self.title = @"活动中心";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHEnterTainmentCell class] forCellReuseIdentifier:ZSHEnterTainmentCellID];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
    lineView.backgroundColor = KZSHColor1D1D1D;
    [self.view addSubview:lineView];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(190);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHEnterTainmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHEnterTainmentCellID];
            cell.fromClassType = ZSHFromActivityVCToEnterTainmentCell;
            ZSHEntertainmentModel *model = self.dataArr[indexPath.row];
            [cell updateCellWithModel:model];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    return sectionModel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
