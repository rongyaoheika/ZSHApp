//
//  ZSHMusicPlayViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicPlayViewController.h"
#import "ZSHMusicLogic.h"

@interface ZSHMusicPlayViewController ()

@property (nonatomic, strong) ZSHMusicLogic   *musicLogic;

@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";

@implementation ZSHMusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self createUI];
    [self loadData];
}

- (void)loadData{
   
    [self requestData];
    [self initViewModel];
}


- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}



//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < 10; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(250);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
           
        };
    }
    
    return sectionModel;
}

- (void)requestData{
    kWeakSelf(self);
//    [_foodLogic loadFoodListDataWithParamDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
//        [weakself.tableView.mj_header endRefreshing];
//        [weakself.tableView.mj_footer endRefreshing];
//        _foodListArr = responseObject;
//        [weakself initViewModel];
//    } fail:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
