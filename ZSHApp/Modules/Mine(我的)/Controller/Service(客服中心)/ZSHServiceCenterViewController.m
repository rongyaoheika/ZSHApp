//
//  ZSHServiceCenterViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHServiceCenterViewController.h"

@interface ZSHServiceCenterViewController ()

@property (nonatomic, strong) NSArray            *titleArr;
@property (nonatomic, strong) NSArray            *imageArr;

@end


static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHServiceCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createUI];
}

- (void)loadData{
    switch (kFromVCType) {
        case ZSHFromMineServiceVCToServiceCenterVC:{
            self.titleArr = @[@"客服1",@"客服2",@"客服3",@"客服4"];
            self.imageArr = @[@"mine_service",@"mine_service",@"mine_service",@"mine_service"];
            break;
        }
        case ZSHFromMineFriendVCToServiceCenterVC:{
            self.titleArr = @[@"爱跳舞的小丑",@"爱跳舞的小丑",@"爱跳舞的小丑",@"爱跳舞的小丑"];
            self.imageArr = @[@"weibo_head_image",@"weibo_head_image",@"weibo_head_image",@"weibo_head_image"];
            break;
        }
            
            
            
        default:
            break;
    }
    
    [self initViewModel];
}

- (void)createUI{
    self.title = self.paramDic[@"title"];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, kScreenWidth, kScreenHeight - KNavigationBarHeight);
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<self.titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(60);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:weakself.imageArr[indexPath.row]];
            cell.textLabel.text = weakself.titleArr[indexPath.row];
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
