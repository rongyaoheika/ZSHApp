//
//  ZSHTogetherViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTogetherViewController.h"
#import "ZSHTogetherView.h"
#import "ZSHBaseCell.h"
#import "ZSHEntertainmentViewController.h"
#import "ZSHEntertainmentDetailViewController.h"

static NSString *cellIdentifier = @"listCell";

@interface ZSHTogetherViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSArray            *pushVCsArr;
@property (nonatomic, strong) NSArray            *paramArr;

@end

@implementation ZSHTogetherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.pushVCsArr = @[@"ZSHEntertainmentDetailViewController",@"ZSHEntertainmentViewController",@"",@"ZSHEntertainmentViewController"];
    self.paramArr = @[@{},@{}];
    [self initViewModel];
}

- (void)createUI{

    [self.navigationItem setTitleView:self.searchBar];
    self.searchBar.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, KBottomNavH, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHTogetherView class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView reloadData];
    
    [self addNavigationItemWithImageName:@"nav_home_more" title:@"三亚" locate:XYButtonEdgeInsetsStyleRight isLeft:YES target:self action:@selector(locateBtnAction) tag:10];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    NSArray *imageArr = @[@"together_image_1",@"together_image_2",@"together_image_3",@"together_image_4",@"together_image_5",@"together_image_6"];
    NSArray *chineseTitleArr = @[@"吃喝玩乐区",@"高端品鉴",@"荣耀活动",@"金钻活动",@"贵宾活动",@"核力轰趴"];
    NSArray *englishTitleArr = @[@"Entertainment",@"High-end Tasting",@"Glory activities",@"Diamond activities",@"VIP activities",@"Home party"];
    for (int i = 0; i<imageArr.count; i++) {
        
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(140);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHTogetherView *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"bgImageName":imageArr[i],@"chineseText":chineseTitleArr[i],@"englishText":englishTitleArr[i],@"fromClassType":@(ZSHFromTogetherVCToTogetherView)};
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHEntertainmentDetailViewController *entertaimmentVC= [[ZSHEntertainmentDetailViewController alloc]init];
            [weakself.navigationController pushViewController:entertaimmentVC animated:YES];
        };
    }
    
    
    return sectionModel;
}

- (void)locateBtnAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
