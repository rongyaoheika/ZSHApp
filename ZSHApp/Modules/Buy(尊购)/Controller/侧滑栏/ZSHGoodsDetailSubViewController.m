//
//  ZSHGoodsDetailSubViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsDetailSubViewController.h"
#import "ZSHGoodsDetailSubCell.h"
#import "ZSHGoodsDetailModel.h"

@interface ZSHGoodsDetailSubViewController ()

@property (nonatomic, strong)NSMutableArray           *dataArr;

@end

static NSString *ZSHGoodsDetailSubCellID = @"ZSHGoodsDetailSubCell";
@implementation ZSHGoodsDetailSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    NSArray *baseDataArr = @[
                             @{@"detailPicture":@"good_detail_1",@"detailText":@"古驰-1921年创立于意大利佛罗伦萨，是全球卓越的奢华精品品牌之一。以其卓越的品质和精湛的意大利工艺闻名于世，旗下精品包括皮件、鞋履、香氛、珠宝和腕表"},
                             @{@"detailPicture":@"good_detail_2",@"detailText":@""},
                             @{@"detailPicture":@"good_detail_3",@"detailText":@""}
                             ];
    self.dataArr = [ZSHGoodsDetailModel mj_objectArrayWithKeyValuesArray:baseDataArr];
    [self initViewModel];
}

- (void)createUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHGoodsDetailSubCell class] forCellReuseIdentifier:ZSHGoodsDetailSubCellID];
    [self.tableView reloadData];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];

    for (int i = 0; i<self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        kWeakSelf(cellModel);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            RLog(@"indexPath.row == %ld",indexPath.row);
            ZSHGoodsDetailSubCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHGoodsDetailSubCellID forIndexPath:indexPath];
            ZSHGoodsDetailModel *model = weakself.dataArr[indexPath.row];
            [cell updateCellWithModel:model];
            weakcellModel.height = model.cellHeight;
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            RLog(@"点击了");
        };
    }
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
