//
//  ZSHLeftFindViewController.m
//  ZSHApp
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHLeftFindViewController.h"
#import "ZSHLeftFindCell.h"

@interface ZSHLeftFindViewController ()

@property (nonatomic, strong) NSArray                  *foodListArr;

@end

static NSString *ZSHLeftFindCellID = @"ZSHLeftFindCell";
@implementation ZSHLeftFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUI];
    [self loadData];
    
}

- (void)loadData{
    _foodListArr = @[@{@"imageName":@"find_image_1",@"title":@"中国年饮中国茶，清静雅和福禄康逸",@"price":@"¥299"},
                     @{@"imageName":@"find_image_2",@"title":@"点燃岁末派对 需要一款格调更高的酒",@"price":@"¥699"},
                     @{@"imageName":@"find_image_3",@"title":@"男人的格调生活",@"price":@"¥279"},
                     @{@"imageName":@"find_image_4",@"title":@"专属定制磁力触感手表",@"price":@"¥10000"}];
    
//    [self requestData];
    [self initViewModel];
}

- (void)createUI{
    self.title = @"发现";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, KBottomHeight, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHLeftFindCell class] forCellReuseIdentifier:ZSHLeftFindCellID];
}



- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < _foodListArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(200);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHLeftFindCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHLeftFindCellID forIndexPath:indexPath];
            [cell updateCellWithParamDic:_foodListArr[indexPath.row]];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {

        };
    }
    
    return sectionModel;
}

- (void)requestData{
   
    
    
}


-(void)headerRereshing{
    [self requestData];
}


-(void)footerRereshing{
    [self.tableView.mj_footer endRefreshing];
}


@end
