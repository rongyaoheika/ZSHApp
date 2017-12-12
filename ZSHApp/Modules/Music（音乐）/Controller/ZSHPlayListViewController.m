//
//  ZSHPlayListViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPlayListViewController.h"
#import "ZSHMusicLogic.h"
#import "ZSHPlayListHeadView.h"
#import "ZSHMusicPlayListCell.h"
#import "AudioPlayerController.h"
#import "ZSHSingerModel.h"
#import "MusicModel.h"
#import "ZSHRadioModel.h"
#import "ZSHRadioDetailModel.h"

@interface ZSHPlayListViewController ()

@property (nonatomic, strong) ZSHPlayListHeadView  *headView;
@property (nonatomic, strong) UIView               *tabHeadView;
@property (nonatomic, strong) UIView               *footView;
@property (nonatomic, strong) ZSHMusicLogic        *musicLogic;
@property (nonatomic, strong) NSMutableArray       *songArr;
@property (nonatomic, strong) NSArray              *rankModelArr;
@property (nonatomic, strong) NSArray              *singerSongArr;
@property (nonatomic, strong) ZSHRadioDetailModel  *radioDetailModel;
@property (nonatomic, strong) NSArray              *librarySongArr;
@property (nonatomic, assign) NSInteger            page;
/** 数据*/
@property (nonatomic, strong) NSArray              *musicMs;

@end

static NSString *ZSHMusicPlayListCellID = @"ZSHMusicPlayListCell";
@implementation ZSHPlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    _page = 0;
    
    _musicLogic = [[ZSHMusicLogic alloc]init];
    _songArr = [[NSMutableArray alloc]initWithCapacity:10];
    switch (kFromClassTypeValue) {
        case ZSHFromRankVCToPlayListVC:{//排行榜
            [self requestRankDetailListData];
            break;
        }
        case ZSHFromRadioVCToPlayListVC:{//电台
            [self requestRadioData];
            break;
        }
        case ZSHFromSingerVCToPlayListVC:{//歌手歌单
             [self requestSingerData];
            break;
        }
        case ZSHFromLibraryVCToPlayListVC:{//曲库
            [self requestLibraryRadioData];
            break;
        }
        default:
            break;
    }
   
    NSDictionary *headDic = @{@"headImage":self.paramDic[@"headImage"]};
    [_headView updateViewWithParamDic:headDic];
}

- (void)requestRankDetailListData{
    kWeakSelf(self);
    
    [_musicLogic loadRankListWithParamDic:@{@"type":@([self.paramDic[@"type"]integerValue]),@"offset":@(_page)} Success:^(id responseObject) {
        _rankModelArr  = responseObject;
        [weakself initViewModel];
    } fail:nil];
    
}

//添加曲库歌单
- (void)requestLibraryRadioData{
    kWeakSelf(self);
    switch ([self.paramDic[@"index"]integerValue]) {
        case 0:{//推荐
            [_musicLogic loadkSongListWithParamDic:nil Success:^(id responseObject) {
                _rankModelArr = responseObject;
               [weakself initViewModel];
            } fail:nil];
            break;
        }
        case 1:{//精选
            [_musicLogic loadkSongListWithParamDic:nil Success:^(id responseObject) {
                _rankModelArr = responseObject;
                [weakself initViewModel];
            } fail:nil];
            break;
        }
        case 2:{//最热
            [_musicLogic loadRankListWithParamDic:@{@"type":@(2),@"offset":@(0)} Success:^(id responseObject) {
                _rankModelArr = responseObject;
                [weakself initViewModel];
            } fail:nil];
        }
            
        case 3:{//最新
            [_musicLogic loadRankListWithParamDic:@{@"type":@(1),@"offset":@(0)} Success:^(id responseObject) {
                _rankModelArr = responseObject;
                [weakself initViewModel];
            } fail:nil];
            break;
        }
            
            
        default:
            break;
    }
    
}

- (void)requestRadioData{
    kWeakSelf(self);
    NSDictionary *paramDic = @{@"ch_name":self.paramDic[@"ch_name"]};
    [_musicLogic loadRadioDetailWithParamDic:paramDic Success:^(id responseObject) {
       _radioDetailModel = responseObject;
        [weakself initViewModel];
    } fail:nil];
}

- (void)requestSingerData{
    kWeakSelf(self);
    
    NSDictionary *paramDic = @{@"tinguid":self.paramDic[@"tinguid"],@"offset":@(0)};
    [_musicLogic loadSingerSongListWithParamDic:paramDic Success:^(id responseObject) {
        _singerSongArr = responseObject;
        [weakself initViewModel];
    } fail:nil];
}

- (void)createUI{
    self.title = @"曲库";
    
    _headView = [[ZSHPlayListHeadView alloc]init];
    _headView.frame = CGRectMake(0, 0, kScreenWidth, kRealValue(225));
    [self.view addSubview:_headView];
    [self.view addSubview:self.footView];
    
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.separatorColor = KZSHColor1D1D1D;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(kRealValue(225), 0, 0, KBottomNavH+KBottomHeight));
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
    sectionModel.headerView = self.tabHeadView;
    sectionModel.headerHeight = kRealValue(40);
    NSArray *arr = nil;
    switch (kFromClassTypeValue) {
        case ZSHFromRankVCToPlayListVC:{//排行榜
            arr = _rankModelArr;
            break;
        }
        case ZSHFromRadioVCToPlayListVC:{//电台
            arr = _radioDetailModel.songlist;
            break;
        }
        case ZSHFromSingerVCToPlayListVC:{//歌手
            arr = _singerSongArr;
            break;
        }
        case ZSHFromLibraryVCToPlayListVC:{//曲库
            arr = _rankModelArr;
            break;
        }
        
        default:
            break;
    }
    
    
    for (int i = 0; i < arr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(60);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            
            ZSHMusicPlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHMusicPlayListCellID forIndexPath:indexPath];
            if (kFromClassTypeValue == ZSHFromRankVCToPlayListVC) {
                ZSHRankModel *rankModel = _rankModelArr[indexPath.row];
                [cell updateCellWithModel:rankModel];
            } else if (kFromClassTypeValue == ZSHFromRadioVCToPlayListVC){
                ZSHRadioDetailSubModel *radioDetailSubModel = _radioDetailModel.songlist[indexPath.row];
                [cell updateCellWithRadioDetailModel:radioDetailSubModel];
            } else if (kFromClassTypeValue == ZSHFromSingerVCToPlayListVC){
                ZSHRankModel *rankModel = _singerSongArr[indexPath.row];
                [cell updateCellWithModel:rankModel];
            } else if (kFromClassTypeValue == ZSHFromLibraryVCToPlayListVC){
                ZSHRankModel *rankModel = _rankModelArr[indexPath.row];
                [cell updateCellWithModel:rankModel];
            }
           
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            NSString *songId = @"";
            if (kFromClassTypeValue == ZSHFromRankVCToPlayListVC) {
               ZSHRankModel *rankModel = _rankModelArr[indexPath.row];
                songId = rankModel.song_id;
            } else if (kFromClassTypeValue == ZSHFromRadioVCToPlayListVC){
                ZSHRadioDetailSubModel *radioDetailSubModel = _radioDetailModel.songlist[indexPath.row];
                songId = radioDetailSubModel.songid;
            } else if (kFromClassTypeValue == ZSHFromSingerVCToPlayListVC){
                ZSHRankModel *rankModel = _singerSongArr[indexPath.row];
                songId = rankModel.song_id;
            } else if (kFromClassTypeValue == ZSHFromLibraryVCToPlayListVC){
                ZSHRankModel *rankModel = _rankModelArr[indexPath.row];
                songId = rankModel.song_id;
            }
            
            RLog(@"歌曲id参数 == %@",songId);
            [_musicLogic loadSongDetailtWithParamDic:@{@"songid":songId} Success:^(id responseObject) {
                RLog(@"音乐详细数据== %@",responseObject);
                MusicModel *model = responseObject;
                if (model) {
                     [_songArr removeAllObjects];
                     [_songArr addObject:model];
                }

                AudioPlayerController *audio = [AudioPlayerController audioPlayerController];
                [audio initWithArray:self.songArr index:0];
                [weakself presentViewController:audio animated:YES completion:nil];
                
            } fail:nil];
            
           
            
        };
    }
    
    return sectionModel;
}



- (UIView *)tabHeadView{
    if (!_tabHeadView) {
        _tabHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(40))];
        NSDictionary *btnDic = @{@"title":@"随机播放",@"withImage":@(YES),@"normalImage":@"music_play"};
        UIButton *playBtn = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
        playBtn.frame = CGRectMake(KLeftMargin, 0, kRealValue(100), kRealValue(40));
        [playBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(7.5)];
        [_tabHeadView addSubview:playBtn];
        
        NSDictionary *titleLabelDic = @{@"text":@"共123首",@"font":kPingFangRegular(12)};
        UILabel *songCountLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
        [_tabHeadView addSubview:songCountLabel];
        [songCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(playBtn.mas_right);
            make.top.and.height.and.right.mas_equalTo(_tabHeadView);
        }];
    }
    return _tabHeadView;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - KBottomNavH, kScreenWidth, KBottomNavH)];
        _footView.backgroundColor = KZSHColor0B0B0B;
        
        UIImageView *authorIV = [[UIImageView alloc]init];
        authorIV.image = [UIImage imageNamed:@"music_image_1"];
        [_footView addSubview:authorIV];
        [authorIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_footView).offset(KLeftMargin);
            make.centerY.mas_equalTo(_footView);
            make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(40)));
        }];
        
        NSDictionary *songLabelDic = @{@"text":@"后来",@"font":kPingFangRegular(12)};
        UILabel *songLabel = [ZSHBaseUIControl createLabelWithParamDic:songLabelDic];
        [_footView addSubview:songLabel];
        [songLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(authorIV.mas_right).offset(kRealValue(10));
            make.height.mas_equalTo(_footView);
            make.centerY.mas_equalTo(_footView);
            make.width.mas_equalTo(kRealValue(100));
        }];
        
        UIButton *startBtn = [[UIButton alloc]init];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"music_stop"] forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"music_start"] forState:UIControlStateNormal];
        [startBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:startBtn];
         [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_footView).offset(-KLeftMargin);
            make.centerY.mas_equalTo(_footView);
            make.size.mas_equalTo(CGSizeMake(kRealValue(25), kRealValue(25)));
        }];
        
    }
    return _footView;
}

- (void)playBtnAction:(UIButton *)btn{
    RLog(@"点击播放按钮的点击");
    btn.selected = !btn.selected;
    
}

- (void)footerRereshing{
    _page++;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
