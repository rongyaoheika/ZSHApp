//
//  ZSHFollowViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFollowViewController.h"
#import "ZSHFollowCell.h"

static NSString *ZSHLiveFollowCellID = @"ZSHLiveFollowCellID";

@interface ZSHFollowViewController ()

@property (nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation ZSHFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    switch ([self.paramDic[@"fromClassType"] integerValue]) {
        case FromHorseVCToFollowVC:
            self.title = @"我的关注";
            break;
        case FromShipVCToFollowVC:
            self.title = @"我的粉丝";
            break;
        default:
            break;
    }
    
    [self initViewModel];
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHFollowCell class] forCellReuseIdentifier:ZSHLiveFollowCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    self.dataArr = @[
                     @{@"imageName":@"list_user_1",@"nickname":@"爱跳舞的小丑",@"value":@"28492"},
                     @{@"imageName":@"list_user_2",@"nickname":@"假面骑士",@"value":@"2892"},
                     @{@"imageName":@"list_user_3",@"nickname":@"Miss_王",@"value":@"28492"},
                     @{@"imageName":@"list_user_4",@"nickname":@"忘记时间的钟",@"value":@"250689"},
                     ];
    
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(59);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHLiveFollowCellID forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"imageName":self.dataArr[i][@"imageName"],@"nickname":self.dataArr[i][@"nickname"],@"value":self.dataArr[i][@"value"],@"index":@(i)};
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    
    return sectionModel;
}

@end
