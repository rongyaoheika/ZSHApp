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
#import "ZSHFootPlayMusicView.h"

@interface ZSHPlayListViewController ()

@property (nonatomic, strong) ZSHPlayListHeadView  *headView;
@property (nonatomic, strong) UIView               *tabHeadView;
@property (nonatomic, strong) UILabel              *songCountLabel;
@property (nonatomic, strong) ZSHFootPlayMusicView *footView;
@property (nonatomic, strong) ZSHMusicLogic        *musicLogic;
@property (nonatomic, strong) NSMutableArray       *songArr;
@property (nonatomic, strong) NSArray              *rankModelArr;
@property (nonatomic, strong) NSMutableArray       *singerSongArr;
@property (nonatomic, strong) ZSHRadioDetailModel  *radioDetailModel;
@property (nonatomic, assign) NSInteger            page;
@property (nonatomic, strong) NSArray              *normalDataArr;

/** 数据*/
@property (nonatomic, strong) NSArray               *musicMs;
@property (nonatomic, assign) AudioPlayerController *audio;


@end

static NSString *ZSHMusicPlayListCellID = @"ZSHMusicPlayListCell";
@implementation ZSHPlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    _page = 0;
    _musicLogic = [[ZSHMusicLogic alloc]init];
    _songArr = [[NSMutableArray alloc]init];
    _singerSongArr = [[NSMutableArray alloc]init];
    [self loadData];
    
}

- (void)loadData{
   
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

//排行榜歌单列表
- (void)requestRankDetailListData{
    kWeakSelf(self);
    
    [_musicLogic loadRankListWithParamDic:@{@"type":@([self.paramDic[@"type"]integerValue]),@"offset":@(_page)} Success:^(id responseObject) {
        _rankModelArr  = responseObject;
        _normalDataArr = _rankModelArr;
        [weakself initViewModel];
    } fail:nil];
    
}

//添加曲库歌单列表
- (void)requestLibraryRadioData{
    kWeakSelf(self);
    switch ([self.paramDic[@"index"]integerValue]) {
        case 0:{//推荐
            [_musicLogic loadkSongListWithParamDic:nil Success:^(id responseObject) {
                _rankModelArr = responseObject;
                _normalDataArr = _rankModelArr;
               [weakself initViewModel];
            } fail:nil];
            break;
        }
        case 1:{//精选
            [_musicLogic loadkSongListWithParamDic:nil Success:^(id responseObject) {
                _rankModelArr = responseObject;
                _normalDataArr = _rankModelArr;
                [weakself initViewModel];
            } fail:nil];
            break;
        }
        case 2:{//最热
            [_musicLogic loadRankListWithParamDic:@{@"type":@(2),@"offset":@(_page)} Success:^(id responseObject) {
                _rankModelArr = responseObject;
                _normalDataArr = _rankModelArr;
                [weakself initViewModel];
            } fail:nil];
        }
            
        case 3:{//最新
            [_musicLogic loadRankListWithParamDic:@{@"type":@(1),@"offset":@(_page)} Success:^(id responseObject) {
                _rankModelArr = responseObject;
                _normalDataArr = _rankModelArr;
                [weakself initViewModel];
            } fail:nil];
            break;
        }
            
            
        default:
            break;
    }
    
}

//电台歌单列表
- (void)requestRadioData{
    kWeakSelf(self);
    NSDictionary *paramDic = @{@"ch_name":self.paramDic[@"ch_name"]};
    [_musicLogic loadRadioDetailWithParamDic:paramDic Success:^(id responseObject) {
        [weakself endTabViewRefresh];
        _radioDetailModel = responseObject;
        _normalDataArr =  _radioDetailModel.songlist;
        [weakself initViewModel];
    } fail:nil];
}

//单个歌手歌单列表
- (void)requestSingerData{
    kWeakSelf(self);
    
    NSDictionary *paramDic = @{@"tinguid":self.paramDic[@"tinguid"],@"offset":@(_page)};
    [_musicLogic loadSingerSongListWithParamDic:paramDic Success:^(id responseObject) {
        [weakself endTabViewRefresh];
        [_singerSongArr addObjectsFromArray:responseObject];
        _normalDataArr = _singerSongArr;
        [weakself initViewModel];
    } fail:nil];
}

- (void)createUI{
    self.title = @"曲库";
    
    _headView = [[ZSHPlayListHeadView alloc]init];
    _headView.frame = CGRectMake(0, 0, kScreenWidth, kRealValue(225));
    [self.view addSubview:_headView];
   
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = KZSHColor1D1D1D;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(kRealValue(225), 0, KBottomNavH+KBottomHeight, 0 ));
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHMusicPlayListCell class] forCellReuseIdentifier:ZSHMusicPlayListCellID];
    
    kWeakSelf(self);
    _footView = [[ZSHFootPlayMusicView alloc]initWithFrame:CGRectMake(0, KScreenHeight - KBottomNavH - KBottomHeight, KScreenWidth, KBottomNavH + KBottomHeight)];
    [self.view addSubview:_footView];
    _footView.footerViewAction = ^{
        [weakself footerViewAction];
    };
    
    _footView.btnClickBlock = ^(UIButton *btn) {
        [weakself playBtnAction:btn];
    };
}

- (void)initViewModel {
    [_songArr removeAllObjects];
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
    
    for (int i = 0; i < _normalDataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(60);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            
            ZSHMusicPlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHMusicPlayListCellID forIndexPath:indexPath];
             NSString *songId = @"";
            if (kFromClassTypeValue == ZSHFromRankVCToPlayListVC) {
                ZSHRankModel *rankModel = _rankModelArr[indexPath.row];
                songId = rankModel.song_id;
                [cell updateCellWithModel:rankModel];
               
            } else if (kFromClassTypeValue == ZSHFromRadioVCToPlayListVC){
                ZSHRadioDetailSubModel *radioDetailSubModel = _radioDetailModel.songlist[indexPath.row];
                songId = radioDetailSubModel.songid;
                [cell updateCellWithRadioDetailModel:radioDetailSubModel];
                
            } else if (kFromClassTypeValue == ZSHFromSingerVCToPlayListVC){
                ZSHRankModel *rankModel = _singerSongArr[indexPath.row];
                songId = rankModel.song_id;
                [cell updateCellWithModel:rankModel];
            } else if (kFromClassTypeValue == ZSHFromLibraryVCToPlayListVC){
                ZSHRankModel *rankModel = _rankModelArr[indexPath.row];
                 songId = rankModel.song_id;
                [cell updateCellWithModel:rankModel];
            }
            
            [_musicLogic loadSongDetailtWithParamDic:@{@"songid":songId} Success:^(id responseObject) {
                MusicModel *model = responseObject;
                if (model) {
                     [_songArr addObject:model];
                }
               
                _songCountLabel.text = [NSString stringWithFormat:@"共%d首",_songArr.count];
                
            } fail:nil];
            
            
            
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHMusicPlayListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIImageView *authorIV = [_footView viewWithTag:2];
            authorIV.image = cell.headImageView.image;
            
            UILabel *songLabel = [_footView viewWithTag:3];
            songLabel.text = cell.titleLabel.text;
            
            [weakself playMusicAction:YES index:indexPath.row];
        };
    }
    return sectionModel;
}

- (UIView *)tabHeadView{
    if (!_tabHeadView) {
        _tabHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(40))];
        NSDictionary *btnDic = @{@"title":@"随机播放",@"withImage":@(YES),@"normalImage":@"music_play"};
        UIButton *playBtn = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
        [playBtn addTarget:self action:@selector(randomPlayAction:) forControlEvents:UIControlEventTouchUpInside];
        playBtn.tag = 1;
        playBtn.frame = CGRectMake(KLeftMargin, 0, kRealValue(100), kRealValue(40));
        [playBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(7.5)];
        [_tabHeadView addSubview:playBtn];
        
        NSDictionary *titleLabelDic = @{@"text":@"共10首",@"font":kPingFangRegular(12)};
        _songCountLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
        [_tabHeadView addSubview:_songCountLabel];
        [_songCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(playBtn.mas_right);
            make.top.and.height.and.right.mas_equalTo(_tabHeadView);
        }];
    }
    return _tabHeadView;
}

- (void)playMusicAction:(BOOL)play index:(NSInteger)index{
    if (play) {
        _audio = [AudioPlayerController audioPlayerController];
        [_audio initWithArray:self.songArr index:index];
        
         UIButton *btn = [_footView viewWithTag:4];
         UISlider *slider = [_footView viewWithTag:5];
        
        _audio.playStatus = ^(float value, BOOL play) {
             slider.maximumValue = _audio.paceSlider.maximumValue;
            if (play) {
                [btn setBackgroundImage:[UIImage imageNamed:@"music_stop"] forState:UIControlStateNormal];
            } else {
                [btn setBackgroundImage:[UIImage imageNamed:@"music_start"] forState:UIControlStateNormal];
            }
        };
        
        _audio.paceValueChanged = ^(float value) {
            slider.value = value;
        };
    }
}

- (void)playBtnAction:(UIButton *)btn{
    RLog(@"点击播放按钮的点击");
    if ([btn.currentBackgroundImage isEqual:[UIImage imageNamed:@"music_stop"]]) {
         [btn setBackgroundImage:[UIImage imageNamed:@"music_start"] forState:UIControlStateNormal];
        [_audio stop];
    } else {
        [btn setBackgroundImage:[UIImage imageNamed:@"music_stop"] forState:UIControlStateNormal];
        [_audio play];
    }
}

- (void)randomPlayAction:(UIButton *)btn{
    NSInteger randomIndex = arc4random()%(self.songArr.count);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:randomIndex inSection:0];
    ZSHMusicPlayListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIImageView *authorIV = [_footView viewWithTag:2];
    authorIV.image = cell.headImageView.image;
    
    UILabel *songLabel = [_footView viewWithTag:3];
    songLabel.text = cell.titleLabel.text;
    
    AudioPlayerController *randomAudo = [AudioPlayerController audioPlayerController];
    randomAudo.playerMode = AudioPlayerModeRandomPlay;
    [randomAudo initWithArray:self.songArr index:randomIndex];
    [self presentViewController:randomAudo animated:YES completion:nil];
    
}

- (void)footerViewAction{
    [self presentViewController:_audio animated:YES completion:nil];
}

- (void)footerRereshing{
    _page+=10;
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
