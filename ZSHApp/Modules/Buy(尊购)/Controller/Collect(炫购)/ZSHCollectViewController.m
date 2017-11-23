//
//  ZSHCollectViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCollectViewController.h"
#import "ZSHCollectCell.h"
#import "ZSHBuyLogic.h"

static NSString *CollectCellIdentifier = @"CollectCellIdentifier";

@interface ZSHCollectViewController ()

@end

@implementation ZSHCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self requstData];
    [self initViewModel];
}

- (void)createUI{
    self.title = @"炫购收藏";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHCollectCell class] forCellReuseIdentifier:CollectCellIdentifier];
    [self.tableView reloadData];
    
}



- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *imageArr = @[@"buy_watch",@"collect_image_1",@"collect_image_2", @"collect_image_3"];
    
    NSArray *titleArr = @[@"卡地亚Cartier伦敦SOLO手表 石英男表W6701005",@"Gucci/古奇新款现货女士牛皮短款钱包零钱包黑色女包474802DRW1T", @"Cartier卡地亚SAPHIRS LÉGERS DE CARTIER系列玫瑰金项链B7218400", @"Channel 香奈儿黄色柔情邂逅女士淡香水50ML"];
    NSArray *contentArr = @[@"¥49200",@"￥4618",@"￥21200", @"￥640"];
    
    for (int i = 0; i<imageArr.count; i++) {
        
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(100);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //需要注册，无需判空
            ZSHCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:CollectCellIdentifier forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"bgImageName":imageArr[i],@"TitleText":titleArr[i],@"ContentText":contentArr[i]};
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
        
    }
    return sectionModel;
}


- (void)requstData {
    ZSHBuyLogic *logic = [[ZSHBuyLogic alloc] init];
    [logic requestShipCollectWithUserID:@"userID" success:^(id response) {
        
    }];
}

@end
