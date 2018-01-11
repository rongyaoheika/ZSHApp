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
@interface ZSHMusicMainViewController ()

@property (nonatomic, strong) ZSHGuideView          *guideView;

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
    ZSHGuideView *guideView = [[ZSHGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(175)) paramDic:nextParamDic];
    self.tableView.tableHeaderView = guideView;
    NSArray *imageArr = @[@"find_image_1",@"find_image_2",@"find_image_3",@"find_image_4"];
    [guideView updateViewWithParamDic:@{@"dataArr":imageArr}];
    
    [self.tableView reloadData];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
   
    [self.tableViewModel.sectionModelArray addObject:[self storeMusicListSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMusicLibrarySection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMusicSingerSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMusicRankSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeMusicRadioSection]];
}

//歌单推荐
- (ZSHBaseTableViewSectionModel*)storeMusicListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    
    NSDictionary *headTitleParamDic = @{@"text":@"歌单推荐",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(163);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        NSArray *paramDicArr = @[@{@"imageName":@"search_image_10",@"imageTitle":@"聆听一首打开你心情的乡村音乐"},@{@"imageName":@"search_image_11",@"imageTitle":@"那些年我们爱不释耳的音乐"},
                                 @{@"imageName":@"search_image_12",@"imageTitle":@"心灵的声音 声音的艺术"}];
        ZSHBaseTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicListCellID forIndexPath:indexPath];
        [cell updateCellWithDataArr:paramDicArr paramDic:@{KFromClassType:@(FromMusicMenuToNoticeView)}];
        cell.itemClickBlock = ^(NSInteger tag) {//歌单推荐
           
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
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    
    NSDictionary *headTitleParamDic = @{@"text":@"曲库推荐",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(110);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        NSArray *paramDicArr = @[@{@"imageName":@"search_image_10"},@{@"imageName":@"search_image_11"},
                                 @{@"imageName":@"search_image_12"}];
        ZSHBaseTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicListCellID forIndexPath:indexPath];
        [cell updateCellWithDataArr:paramDicArr paramDic:@{KFromClassType:@(FromMusicMenuToNoticeView)}];
        cell.itemClickBlock = ^(NSInteger tag) {//曲库推荐
            
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
        if (![cell.contentView viewWithTag:2]) {
            NSDictionary *nextParamDic = @{KFromClassType:@(FromBuyVCToGuideView),@"pageViewHeight":@(cellHeight),@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false)};
            ZSHGuideView *guideView = [[ZSHGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, cellHeight) paramDic:nextParamDic];
            guideView.tag = 2;
            [cell addSubview:guideView];
            
            NSArray *imageArr = @[@"find_image_1",@"find_image_2",@"find_image_3",@"find_image_4"];
            [guideView updateViewWithParamDic:@{@"dataArr":imageArr}];
        }
        
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    };
    
    
    return sectionModel;
}

//榜单推荐
- (ZSHBaseTableViewSectionModel*)storeMusicRankSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    
    NSDictionary *headTitleParamDic = @{@"text":@"榜单推荐",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(110);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        NSArray *paramDicArr = @[@{@"imageName":@"search_image_10"},@{@"imageName":@"search_image_11"},
                                 @{@"imageName":@"search_image_12"}];
        ZSHBaseTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicListCellID forIndexPath:indexPath];
        [cell updateCellWithDataArr:paramDicArr paramDic:@{KFromClassType:@(FromMusicMenuToNoticeView)}];
        cell.itemClickBlock = ^(NSInteger tag) {//榜单推荐
            
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
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    
    NSDictionary *headTitleParamDic = @{@"text":@"电台",@"font":kPingFangMedium(15)};
    sectionModel.headerView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(200);
    cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHRadioScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicRadioCellID forIndexPath:indexPath];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    };
    
    
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
