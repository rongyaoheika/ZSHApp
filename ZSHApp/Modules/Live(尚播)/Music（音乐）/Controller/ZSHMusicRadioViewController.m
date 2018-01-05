//
//  ZSHMusicRadioViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicRadioViewController.h"
#import "LXScollTitleView.h"
#import "ZSHMusicLogic.h"
#import "ZSHMusicPlayListCell.h"
#import "ZSHRadioModel.h"
#import "ZSHPlayListViewController.h"

@interface ZSHMusicRadioViewController ()

@property (nonatomic, strong) LXScollTitleView      *titleView;
@property (nonatomic, strong) NSArray               *titleArr;
@property (nonatomic, strong) NSArray               *typeArr;
@property (nonatomic, strong) ZSHMusicLogic         *musicLogic;
@property (nonatomic, strong) NSArray               *radioModelArr;
@property (nonatomic, strong) NSDictionary          *requestDic;

@end

static NSString *ZSHMusicPlayListCellID = @"ZSHMusicPlayListCell";
@implementation ZSHMusicRadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    self.titleArr = @[@"全部",@"语种频道",@"风格频道",@"时光频道",@"推荐频道",@"心情频道"];
    _typeArr = @[@"-1",@"语种频道",@"风格频道",@"时光频道",@"推荐频道",@"心情频道"];
    _requestDic = @{@"cate_sname":_typeArr[0]};
    [self reloadListData];
    _musicLogic = [[ZSHMusicLogic alloc]init];
    [self requestData];
    [self initViewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_radioModelArr) {
        [self requestData];
    }
}

- (void)requestData{
    kWeakSelf(self);
    [_musicLogic loadRadioListWithParamDic:_requestDic Success:^(id responseObject) {
        _radioModelArr = responseObject;
        [weakself endTabViewRefresh];
        [weakself initViewModel];
    } fail:nil];
    
}

- (void)createUI{
    self.title = @"电台";
    [self.view addSubview:self.titleView];
   
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = KZSHColor1D1D1D;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
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
    for (int i = 0; i <_radioModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(60);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHMusicPlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHMusicPlayListCellID forIndexPath:indexPath];
            ZSHRadioModel *radioModel = _radioModelArr[indexPath.row];
            [cell updateCellWithRadioModel:radioModel];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHRadioModel *radioModel = _radioModelArr[indexPath.row];
            NSDictionary *paramDic = @{@"ch_name":radioModel.ch_name,KFromClassType:@(ZSHFromRadioVCToPlayListVC),@"headImage":radioModel.thumb};
            ZSHPlayListViewController *playListVC = [[ZSHPlayListViewController alloc]initWithParamDic:paramDic];
            [weakself.navigationController pushViewController:playListVC animated:YES];
        };
    }
    
    return sectionModel;
}

//getter
- (LXScollTitleView *)titleView{
    kWeakSelf(self);
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, kRealValue(40))];
        _titleView.normalTitleFont = kPingFangRegular(15);
        _titleView.selectedTitleFont = kPingFangMedium(15);
        _titleView.selectedColor = KZSHColor929292;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = 0;
        _titleView.selectedBlock = ^(NSInteger index){
            _requestDic = @{@"cate_sname":self.typeArr[index]};
            [weakself requestData];
        };
        
    }
    return _titleView;
}

- (void)reloadListData{
    _titleView.titleWidth = KScreenWidth /4.5;
    [self.titleView reloadViewWithTitles:self.titleArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
