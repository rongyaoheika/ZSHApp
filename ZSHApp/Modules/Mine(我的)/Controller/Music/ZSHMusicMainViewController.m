//
//  ZSHMusicMainViewController.m
//  ZSHApp
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHMusicMainViewController.h"
#import "ZSHBaseTitleButtonCell.h"
#import "ZSHGuideView.h"
#import "ZSHRadioScrollCell.h"
#import "ZSHMusicLogic.h"
#import "ZSHPlayListViewController.h"

@interface ZSHMusicMainViewController ()

@property (nonatomic, strong) ZSHGuideView          *guideView;
@property (nonatomic, strong) ZSHMusicLogic         *musicLogic;
@property (nonatomic, strong) NSArray               *allMusicArr;
@property (nonatomic, strong) NSArray               *singer_picArr;
@property (nonatomic, strong) NSArray               *typeArr;
@property (nonatomic, strong) NSArray               *radioStationListArr;
@property (nonatomic, strong) NSArray               *MusicLibraryArr;
@property (nonatomic, strong) NSArray               *songsRecommendArr;     // 歌单推荐

@end

static NSString *MusicListCellID = @"MusicListCell";
static NSString *MusicLibraryCellID = @"MusicLibraryCell";
static NSString *MusicSingerCellID = @"MusicSingerCell";
static NSString *MusicRankCellID = @"MusicRankCell";
static NSString *MusicRadioCellID = @"MusicRadioCell";

@implementation ZSHMusicMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
    _typeArr = @[@(21),@(1),@(12),@(2),@(11),@(24),@(22)];
    _musicLogic = [[ZSHMusicLogic alloc] init];
    [self requestData];
}

- (void)createUI{
    self.title = @"荣耀音乐";
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHBaseTitleButtonCell class] forCellReuseIdentifier:MusicListCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:MusicLibraryCellID];
    [self.tableView registerClass:[ZSHBaseTitleButtonCell class] forCellReuseIdentifier:MusicSingerCellID];
    [self.tableView registerClass:[ZSHRadioScrollCell class] forCellReuseIdentifier:MusicRadioCellID];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, KBottomTabH, 0));
    }];
    
    NSDictionary *nextParamDic = @{KFromClassType:@(FromBuyVCToGuideView),@"pageViewHeight":@(kRealValue(175)),@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false)};
    _guideView = [[ZSHGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(175)) paramDic:nextParamDic];
    self.tableView.tableHeaderView = _guideView;
    NSArray *imageArr = @[@"find_image_1",@"find_image_2",@"find_image_3",@"find_image_4"];
    [_guideView updateViewWithParamDic:@{@"dataArr":imageArr}];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
   
    [self.tableViewModel.sectionModelArray addObject:[self storeMusicListSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMusicLibrarySection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMusicSingerSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMusicRankSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMusicRadioSection]];
    
    [self.tableView reloadData];
}

//歌单推荐
- (ZSHBaseTableViewSectionModel*)storeMusicListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    
    NSDictionary *headTitleParamDic = @{@"text":@"歌单推荐",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(163);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
//        NSArray *paramDicArr = @[@{@"imageName":@"search_image_10",@"imageTitle":@"聆听一首打开你心情的乡村音乐"},@{@"imageName":@"search_image_11",@"imageTitle":@"那些年我们爱不释耳的音乐"},
//                                 @{@"imageName":@"search_image_12",@"imageTitle":@"心灵的声音 声音的艺术"}];
        NSMutableArray *paramDicArr = [NSMutableArray arrayWithCapacity:weakself.songsRecommendArr.count];
        for (NSDictionary *dic in weakself.songsRecommendArr) {
            [paramDicArr addObject:@{@"imageName":dic[@"billboard"][@"pic_s640"], @"imageTitle":dic[@"billboard"][@"comment"]}];
        }
        ZSHBaseTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicListCellID forIndexPath:indexPath];
        if(paramDicArr.count)
            [cell updateCellWithDataArr:paramDicArr paramDic:@{KFromClassType:@(FromMusicMenuToNoticeView)}];
//        [cell updateCellWithDataArr:paramDicArr paramDic:@{KFromClassType:@(FromMusicMenuToNoticeView)}];

        cell.itemClickBlock = ^(NSInteger tag) {//歌单推荐
            NSDictionary *dic = weakself.songsRecommendArr[tag];
            NSDictionary *paramDic = @{KFromClassType:@(ZSHFromRankVCToPlayListVC),@"headImage":dic[@"billboard"][@"pic_s640"], @"type":_typeArr[tag]};
            ZSHPlayListViewController  *playListVC = [[ZSHPlayListViewController alloc]initWithParamDic:paramDic];
            [weakself.navigationController pushViewController:playListVC animated:YES];
        };
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    
    return sectionModel;
}

//曲库推荐
- (ZSHBaseTableViewSectionModel*)storeMusicLibrarySection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    
    NSDictionary *headTitleParamDic = @{@"text":@"曲库推荐",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(110);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        NSMutableArray *paramDicArr = [NSMutableArray arrayWithCapacity:weakself.MusicLibraryArr.count];
        for (NSDictionary *dic in weakself.MusicLibraryArr) {
            [paramDicArr addObject:@{@"imageName":dic[@"pic_big"], @"imageTitle":dic[@"author"]}];
        }
        ZSHBaseTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicListCellID forIndexPath:indexPath];
        if(paramDicArr.count)
            [cell updateCellWithDataArr:paramDicArr paramDic:@{KFromClassType:@(FromMusicMenuToNoticeView)}];
        
        cell.itemClickBlock = ^(NSInteger tag) {//曲库推荐
            NSDictionary *rankModel = weakself.MusicLibraryArr[tag];
            NSDictionary *paramDic = @{KFromClassType:@(ZSHFromLibraryVCToPlayListVC),@"headImage":rankModel[@"pic_big"],@"index":@(tag%1)};
            ZSHPlayListViewController *playListVC = [[ZSHPlayListViewController alloc]initWithParamDic:paramDic];
            [self.navigationController pushViewController:playListVC animated:YES];
        };
        
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    };
    
    
    return sectionModel;
}

//歌手推荐
- (ZSHBaseTableViewSectionModel*)storeMusicSingerSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    NSDictionary *headTitleParamDic = @{@"text":@"歌手推荐",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(100);
    __block  CGFloat cellHeight = cellModel.height;
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicSingerCellID forIndexPath:indexPath];
        if (![cell.contentView viewWithTag:23]) {
            NSDictionary *nextParamDic = @{KFromClassType:@(FromBuyVCToGuideView),@"pageViewHeight":@(cellHeight),@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false)};
            ZSHGuideView *guideView = [[ZSHGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, cellHeight) paramDic:nextParamDic];
            guideView.tag = 23;
            guideView.didSelected = ^(NSInteger index) {
                NSDictionary *paramDic = @{@"headImage":weakself.singer_picArr[index][@"singer_pic"], @"tinguid":weakself.singer_picArr[index][@"singer_id"], KFromClassType:@(ZSHFromSingerVCToPlayListVC)};
                ZSHPlayListViewController  *playListVC = [[ZSHPlayListViewController alloc]initWithParamDic:paramDic];
                [weakself.navigationController pushViewController:playListVC animated:YES];
            };
            [cell.contentView addSubview:guideView];

        }
        if (_singer_picArr.count) {
            ZSHGuideView *guideView = [cell.contentView viewWithTag:23];
            NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:_singer_picArr.count];
            for (NSDictionary *dic in _singer_picArr) {
                [dataArr addObject:dic[@"singer_pic"]];
            }
            [guideView updateViewWithParamDic:@{@"dataArr":dataArr}];
        }

        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    };
    
    
    return sectionModel;
}

// 榜单推荐
- (ZSHBaseTableViewSectionModel*)storeMusicRankSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    
    NSDictionary *headTitleParamDic = @{@"text":@"榜单推荐",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(110);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        NSMutableArray *paramDicArr = [NSMutableArray array];
        for (NSDictionary *dic in weakself.allMusicArr) {
            [paramDicArr addObject:@{@"imageName":dic[@"billboard"][@"pic_s640"], @"imageTitle":dic[@"billboard"][@"name"]}];
        }
        ZSHBaseTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicListCellID forIndexPath:indexPath];
        if (weakself.allMusicArr.count) {
            [cell updateCellWithDataArr:paramDicArr paramDic:@{KFromClassType:@(FromMusicMenuToNoticeView)}];
        }
        
        cell.itemClickBlock = ^(NSInteger tag) {//榜单推荐
            NSDictionary *dic = _allMusicArr[tag];
            NSDictionary *paramDic = @{KFromClassType:@(ZSHFromRankVCToPlayListVC),@"headImage":dic[@"billboard"][@"pic_s640"], @"type":_typeArr[tag]};
            ZSHPlayListViewController  *playListVC = [[ZSHPlayListViewController alloc]initWithParamDic:paramDic];
            [weakself.navigationController pushViewController:playListVC animated:YES];
        };
        
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    };

    return sectionModel;
}


//电台
- (ZSHBaseTableViewSectionModel*)storeMusicRadioSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    
    NSDictionary *headTitleParamDic = @{@"text":@"电台",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(200);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHRadioScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicRadioCellID forIndexPath:indexPath];
        if(weakself.radioStationListArr)
            [cell updateCellWithParamDic:@{@"dataArr":weakself.radioStationListArr}];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    
    
    return sectionModel;
}


- (void)requestData {
    kWeakSelf(self);

    // 音乐排行榜
    [_musicLogic loadTotalRankListWithParamDic:@{@"type":@"21,1,12,2,11,24,22",@"offset":@(0)} Success:^(id responseObject) {
        weakself.allMusicArr = responseObject;
        [weakself initViewModel];
    } fail:nil];
    
    // 音乐中心-首页：歌手推荐和广告
    [_musicLogic loadGetSongRecommend:@{} success:^(id response) {
        NSArray *adsArr = response[@"ads"];
        NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:adsArr.count];
        for (NSDictionary *dic in adsArr) {
            [dataArr addObject:dic[@"SHOWIMG"]];
        }
        if (dataArr.count)
            [weakself.guideView updateViewWithParamDic:@{@"dataArr":dataArr}];

        weakself.singer_picArr = response[@"singerList"];
        [weakself.tableViewModel.sectionModelArray replaceObjectAtIndex:2 withObject:[weakself storeMusicSingerSection]];
        [weakself.tableView reloadData];
    }];
    
    // 音乐中心-电台
    [_musicLogic loadGetRadioStationList:@{} success:^(id response) {
        weakself.radioStationListArr = response[@"pd"];
        [weakself.tableViewModel.sectionModelArray replaceObjectAtIndex:4 withObject:[weakself storeMusicRadioSection]];
        [weakself.tableView reloadData];
    }];
    
    // 曲库推荐
    [_musicLogic loadGetMusicLibrary:@{} success:^(id response) {
        weakself.MusicLibraryArr = response[@"pd"];
        [weakself.tableViewModel.sectionModelArray replaceObjectAtIndex:1 withObject:[weakself storeMusicLibrarySection]];
        [weakself.tableView reloadData];
    }];
    
    // 歌单推荐
    [_musicLogic loadGetSongsRecommend:@{} success:^(id response) {
        weakself.songsRecommendArr = response[@"song_recommend"];
        [weakself.tableViewModel.sectionModelArray replaceObjectAtIndex:0 withObject:[weakself storeMusicListSection]];
        [weakself.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
