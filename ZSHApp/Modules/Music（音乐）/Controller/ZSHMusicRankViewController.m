//
//  ZSHMusicRankViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicRankViewController.h"
#import "ZSHMusicRankCell.h"
#import "ZSHMusicLogic.h"
#import "AudioPlayerController.h"
#import "ZSHPlayListViewController.h"

@interface ZSHMusicRankViewController ()

@property (nonatomic, strong) ZSHMusicLogic *musicLogic;
@property (nonatomic, strong) ZSHRankModel  *rankModel;
@property (nonatomic, strong) NSMutableArray *songArray;
@property (nonatomic, strong) NSArray        *rankModelArr;
@property (nonatomic, copy) NSString         *musicImageUrl;

@property (nonatomic, strong) NSMutableArray *allMusicArr;
@property (nonatomic, strong) NSMutableArray *leftImageArr;

@end

static NSString *ZSHMusicRankCellID = @"ZSHMusicRankCell";

@implementation ZSHMusicRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    _allMusicArr = [[NSMutableArray alloc]init];
    _leftImageArr = [[NSMutableArray alloc]init];
    [self requestData];
    [self initViewModel];
}

- (void)requestData{
    _musicLogic = [[ZSHMusicLogic alloc]init];
    
    //(1-新歌榜,2-热歌榜,6-KTV热歌榜,8-Hito中文榜,11-摇滚榜,12-爵士,16-流行,21-欧美金 曲榜,22-经典老歌榜,23-情歌对唱榜,24-影视金曲榜,25-网络歌曲榜)
    NSArray *typeValueArr = @[@(21),@(1),@(12),@(2),@(11),@(24),@(22)];
    for (int i = 0; i<typeValueArr.count; i++) {
        [_musicLogic loadRankListWithParamDic:@{@"type":typeValueArr[i],@"offset":@(1)} Success:^(id responseObject,NSString *imageUrl) {
            RLog(@"音乐排行榜数据==%@",responseObject);
            _rankModelArr = responseObject;
            _musicImageUrl = imageUrl;
            if (!imageUrl.length) {//新歌榜
                _musicImageUrl = @"http://c.hiphotos.baidu.com/ting/pic/item/f7246b600c33874495c4d089530fd9f9d62aa0c6.jpg";
            }
           
            [_leftImageArr addObject:_musicImageUrl];
            [_allMusicArr addObject:_rankModelArr];
            if (_leftImageArr.count == typeValueArr.count) {
                [self initViewModel];
            }
        } fail:nil];
    }


// 本地数据
//        NSString *str = [[NSBundle mainBundle]pathForResource:@"musicPaper" ofType:@"json"];
//        NSData *data = [[NSData alloc]initWithContentsOfFile:str];
//        NSMutableArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        //    [self.songArray addObject:dic];
//        for (NSDictionary *dic in dataArray) {
//            MusicModel *model = [[MusicModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [self.songArray addObject:model];
//        }

}

- (void)createUI{
    self.title = @"排行榜";
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = KZSHColor1D1D1D;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHMusicRankCell class] forCellReuseIdentifier:ZSHMusicRankCellID];
    
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
    sectionModel.footerHeight = 5;
    sectionModel.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    for (int i = 0; i < _allMusicArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(110);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHMusicRankCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHMusicRankCellID forIndexPath:indexPath];
            [cell updateCellWithParamDic:@{@"rankModelArr":_allMusicArr[indexPath.row]}];
            cell.imageUrl = _leftImageArr[indexPath.row];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            NSDictionary *paramDic = @{@"dataArr":_allMusicArr[indexPath.row],KFromClassType:@(ZSHFromRankVCToPlayListVC)};
            
            ZSHPlayListViewController  *playListVC = [[ZSHPlayListViewController alloc]initWithParamDic:paramDic];
            
            [weakself.navigationController pushViewController:playListVC animated:YES];
        };
    }
    
    return sectionModel;
}

- (NSMutableArray *)songArray
{
    if (!_songArray) {
        _songArray = [NSMutableArray array];
    }
    return _songArray;
}

-(void)headerRereshing{
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
