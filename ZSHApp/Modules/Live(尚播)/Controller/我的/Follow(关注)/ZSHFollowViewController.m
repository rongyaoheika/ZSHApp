//
//  ZSHFollowViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFollowViewController.h"
#import "ZSHFollowCell.h"
#import "ZSHLiveLogic.h"
#import "ZSHFriendListModel.h"

static NSString *ZSHLiveFollowCellID = @"ZSHLiveFollowCellID";

@interface ZSHFollowViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ZSHLiveLogic   *liveLogic;
@property (nonatomic, strong) NSArray<ZSHFriendListModel *>   *friendListModelArr;
@end

@implementation ZSHFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    _liveLogic = [[ZSHLiveLogic alloc] init];
    
    switch ([self.paramDic[KFromClassType] integerValue]) {
        case FromFocusVCToFollowVC:
            self.title = @"我的关注";
            break;
        case FromFansVCToFollowVC:
            self.title = @"我的粉丝";
            break;
        default:
            break;
    }
    
    [self initViewModel];
    [self requestData];
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHFollowCell class] forCellReuseIdentifier:ZSHLiveFollowCellID];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    for (int i = 0; i < _friendListModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(59);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHLiveFollowCellID forIndexPath:indexPath];
            [cell updateCellWithModel:_friendListModelArr[indexPath.row]];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    
    return sectionModel;
}


- (void)requestData {
    kWeakSelf(self);
    switch ([self.paramDic[KFromClassType] integerValue]) {
        case FromFocusVCToFollowVC:{
            [_liveLogic requestFocusList:^(NSArray *friendListModelArr) {
                _friendListModelArr = friendListModelArr;
                [weakself initViewModel];
            }];
            break;
        }
        case FromFansVCToFollowVC:{
            [_liveLogic requestFansList:^(NSArray *friendListModelArr) {
                _friendListModelArr = friendListModelArr;
                [weakself initViewModel];
            }];
            break;
        }
        default:
            break;
    }
    

}


@end
