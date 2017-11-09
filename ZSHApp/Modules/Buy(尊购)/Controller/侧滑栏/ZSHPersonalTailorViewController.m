//
//  ZSHPersonalTailorViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPersonalTailorViewController.h"
#import "ZSHTogetherView.h"
#import "ZSHTailorDetailViewController.h"

static NSString *cellIdentifier = @"listCell";
@interface ZSHPersonalTailorViewController ()

@property (nonatomic,strong) NSArray    *titleArr;
@property (nonatomic,strong) NSArray    *vcArr;
@property (nonatomic,strong) NSArray    *paramDicArr;

@end

@implementation ZSHPersonalTailorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.titleArr = @[@"英国皇家绅士产品",@"记录时间节点",@"定制你的专属旅程",@"记录你的美好回忆",@"高尔夫订制线路",@"情感定制 轻奢首饰", @"新东方美学"];
    NSArray *englishTitleArr = @[@"GIEVES&HAWKES",@"CITIZEN",@"TRAVELID",@"ANDREW",@"WOKEE",@"LABORON",@"CICI"];
    
    self.vcArr = @[@"",@"ZSHGoodsViewController",@"ZSHTitleContentViewController",@"JSCartViewController",@"",@"ZSHPersonalTailorViewController"];
//    self.paramDicArr = @[@{},@{},@{@"fromClassType":@(FromFindVCToTitleContentVC),@"title":@"发现"},@"",@"",@""];
    
    [self initViewModel];
}

- (void)createUI{
    self.title = @"私人频道";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHTogetherView class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    kWeakSelf(self);
    NSArray *imageArr = @[@"personal_image_1",@"personal_image_2",@"personal_image_3",@"personal_image_4",@"personal_image_5",@"personal_image_6",@"personal_image_7"];
    NSArray *chineseTitleArr = @[@"英国皇家绅士品牌",@"记录时间节点的仪式",@"定制你的专属旅程",@"记录你的美好回忆",@"高尔夫定制线路",@"情感定制 轻奢首饰",@"新东方美学",@"风雅生活，璞素之美"];
    NSArray *englishTitleArr = @[@"GIEVES&HAWKES",@"CITIZEN",@"TRAVELID",@"ANDREW",@"WOKEE",@"LABORON",@"CICI",@"璞素"];
    for (int i = 0; i<imageArr.count; i++) {
        
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(185);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //需要注册，无需判空
            ZSHTogetherView *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"bgImageName":imageArr[i],@"chineseText":chineseTitleArr[i],@"englishText":englishTitleArr[i],@"fromClassType":@(ZSHFromPersonalTailorVCToTogetherView)};
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHTailorDetailViewController *tailorDetailVC = [[ZSHTailorDetailViewController alloc] init];
            [weakself.navigationController pushViewController:tailorDetailVC animated:YES];
        };
    }
    return sectionModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
