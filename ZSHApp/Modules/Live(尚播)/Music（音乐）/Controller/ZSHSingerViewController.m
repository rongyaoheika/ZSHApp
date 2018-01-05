//
//  ZSHSingerViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSingerViewController.h"
#import "LXScollTitleView.h"
#import "ZSHMusicLogic.h"
#import "ZSHMusicPlayListCell.h"
#import "ZSHPlayListViewController.h"
@interface ZSHSingerViewController ()

@property (nonatomic, strong) ZSHMusicLogic         *musicLogic;
@property (nonatomic, strong) NSArray               *singerModelArr;
@property (nonatomic, strong) NSDictionary          *requestDic;
@property (nonatomic, assign) NSInteger             genderIndex;
@property (nonatomic, assign) NSInteger             areaIndex;
@property (nonatomic, strong) NSArray               *typeArr;
@end

static NSString *ZSHMusicPlayListCellID = @"ZSHMusicPlayListCell";
@implementation ZSHSingerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)loadData{

    _genderIndex = -1;
    _areaIndex = -1;
    _musicLogic = [[ZSHMusicLogic alloc]init];
    _requestDic = @{@"offset":@(0)};
    [self requestData];
    [self initViewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_singerModelArr) {
        [self requestData];
    }

}

- (void)requestData{
    kWeakSelf(self);
    [_musicLogic loadSingerListWithParamDic:_requestDic Success:^(id responseObject) {
        [weakself endTabViewRefresh];
        _singerModelArr = responseObject;
        [weakself initViewModel];
    } fail:nil];
    
}

- (void)createUI{
    self.title = @"歌手";
    [self addNavigationItemWithImageName:@"live_search" isLeft:NO target:self action:@selector(searchAction) tag:1];
    //@[@"全部",@"流行",@"嘻哈",@"摇滚",@"电子",@"民谣",@"民歌"]
    NSArray *titleArr = @[@[@"全部",@"内地",@"港台",@"欧美",@"日本",@"韩国"],
  @[@"全部",@"男",@"女",@"组合"]];
    _typeArr = @[@[@(-1),@(0),@(1),@(2),@(5),@(6)],
                 @[@(-1),@(0),@(1),@(2)]
                ];
    for (NSUInteger i = 0; i<titleArr.count; i++) {
        LXScollTitleView *titleView = [self createTitleViewWithTag:i];
        titleView.frame = CGRectMake(0, KNavigationBarHeight+i*kRealValue(40), KScreenWidth, kRealValue(40));
        [self.view addSubview:titleView];
        
        titleView.titleWidth = KScreenWidth /6.5;
        [titleView reloadViewWithTitles:titleArr[i]];
    }
    
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = KZSHColor1D1D1D;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KNavigationBarHeight + (titleArr.count)*kRealValue(40));
        make.left.and.right.and.bottom.mas_equalTo(self.view);
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHMusicPlayListCell class] forCellReuseIdentifier:ZSHMusicPlayListCellID];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i <_singerModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(50);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHMusicPlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHMusicPlayListCellID forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            ZSHSingerModel *singerModel = _singerModelArr[indexPath.row];
            [cell updateCellWithSingerModel:singerModel];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHSingerModel *singerModel = _singerModelArr[indexPath.row];
            NSDictionary *paramDic = @{@"headImage":singerModel.avatar_big, @"tinguid":singerModel.ting_uid, KFromClassType:@(ZSHFromSingerVCToPlayListVC)};
            ZSHPlayListViewController  *playListVC = [[ZSHPlayListViewController alloc]initWithParamDic:paramDic];
            [weakself.navigationController pushViewController:playListVC animated:YES];
        };
    }
    
    return sectionModel;
}


//getter
- (LXScollTitleView *)createTitleViewWithTag:(NSUInteger)tag{
    kWeakSelf(self);
    LXScollTitleView *titleView = [[LXScollTitleView alloc] init];
    titleView.tag = tag;
    titleView.normalTitleFont = kPingFangRegular(15);
    titleView.selectedTitleFont = kPingFangMedium(15);
    titleView.selectedColor = KZSHColor929292;
    titleView.normalColor = KZSHColor929292;
    titleView.indicatorHeight = 0;
    titleView.selectedBlock = ^(NSInteger index){
        if (tag == 0) {//地区分类
            _areaIndex = [_typeArr[tag][index]integerValue];
        } else if (tag == 1){//性别
            _genderIndex = [_typeArr[tag][index]integerValue];
        }
        
//        _requestDic = @{@"offset":@(0),@"area":@(_areaIndex),@"gender":@(_genderIndex)};
        
        if (_areaIndex!=-1 && _genderIndex!=-1) {
            _requestDic = @{@"offset":@(0),@"area":@(_areaIndex),@"gender":@(_genderIndex)};
        }

        if (_areaIndex!=-1 &&_genderIndex == -1 ) {
            _requestDic = @{@"offset":@(0),@"area":@(_areaIndex)};
        }

        if (_areaIndex==-1 &&_genderIndex != -1 ) {
            _requestDic = @{@"offset":@(0),@"gender":@(_genderIndex)};
        }

        if (_areaIndex == -1 && _genderIndex== -1) {
            _requestDic = @{@"offset":@(0)};
        }
        
        [weakself requestData];

    };
    return titleView;
}

//上拉刷新
-(void)footerRereshing{
    [self requestData];
}


- (void)searchAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
