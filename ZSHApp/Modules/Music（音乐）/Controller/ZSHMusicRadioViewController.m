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
@property (nonatomic, strong) ZSHMusicLogic         *musicLogic;
@property (nonatomic, strong) NSArray               *radioModelArr;

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
    self.titleArr = @[@"全部",@"傍晚",@"最近",@"情感",@"主题",@"场景",@"曲库"];
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
    //只显示"公共频道",不显示“歌手频道”
    ZSHRadioModel *publicModel = _radioModelArr[0];
    NSArray *radioDataArr = publicModel.channellist;
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i <radioDataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(60);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHMusicPlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHMusicPlayListCellID forIndexPath:indexPath];
            ZSHRadioSubModel *radioSubModel = radioDataArr[indexPath.row];
            [cell updateCellWithRadioModel:radioSubModel];

            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHRadioSubModel *radioSubModel = radioDataArr[indexPath.row];
            NSDictionary *paramDic = @{@"ch_name":radioSubModel.ch_name,KFromClassType:@(ZSHFromRadioVCToPlayListVC)};
            ZSHPlayListViewController *playListVC = [[ZSHPlayListViewController alloc]initWithParamDic:paramDic];
            [weakself.navigationController pushViewController:playListVC animated:YES];
        };
    }
    
    return sectionModel;
}

- (void)requestData{
    kWeakSelf(self);
    [_musicLogic loadRadioListSuccess:^(id responseObject) {
        _radioModelArr = responseObject;
        [weakself initViewModel];
    } fail:nil];
    
}

//getter
- (LXScollTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, kRealValue(40))];
        _titleView.normalTitleFont = kPingFangRegular(15);
        _titleView.selectedTitleFont = kPingFangMedium(15);
        _titleView.selectedColor = KZSHColor929292;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = 0;
        _titleView.selectedBlock = ^(NSInteger index){
           
        };
        
    }
    return _titleView;
}

- (void)reloadListData{
    _titleView.titleWidth = KScreenWidth /self.titleArr.count;
    [self.titleView reloadViewWithTitles:self.titleArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
