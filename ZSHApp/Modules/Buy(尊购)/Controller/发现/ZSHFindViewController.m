//
//  ZSHFindViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFindViewController.h"
#import "ZSHFindCell.h"
#import "ZSHFindArticleCell.h"
#import "ADPlayer.h"

static NSString *Identify_headCell = @"Identify_headCell";
static NSString *Identify_ArticleCell = @"Identify_ArticleCell";


@interface ZSHFindViewController ()<ADPlayerDelegate>


@property (nonatomic, strong) NSMutableArray *viedoLists;
@property (nonatomic, strong) ADPlayer       *player;
@property (nonatomic, strong) NSIndexPath    *currentIndexPath; // 当前播放的cell
@property (nonatomic, assign) BOOL            isSmallScreen; // 是否放置在window上
@property (nonatomic, strong) ZSHFindCell    *currentCell; // 当前cell

@end

@implementation ZSHFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotification) name:ADTabbarChangeClick object:nil];
    self.isSmallScreen = NO;
    
    [self initViewModel];
    
}

- (void)createUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHFindCell class] forCellReuseIdentifier:Identify_headCell];
    [self.tableView registerClass:[ZSHFindArticleCell class] forCellReuseIdentifier:Identify_ArticleCell];
    [self.tableView reloadData];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
}

//head
- (ZSHBaseTableViewSectionModel*)storeHeadSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    NSArray *title1Arr = @[@"这才是只能手表，其他都是电子表！", @"女生最讨厌男生戴什么手表？看看你中招没？", @"三种旅途必备神器，有他们旅途更安逸", @"这才是只能手表，其他都是电子表！", @"三种旅途必备神器，有他们旅途更安逸", @"三种旅途必备神器，有他们旅途更安逸",];
    NSArray *imageArr = @[@"play_find_2", @"play_find_3", @"play_find_4", @"play_find_2", @"play_find_3", @"play_find_4"];
    NSArray *heightArr = @[@"195", @"105", @"105", @"195", @"105", @"105"];
    self.viedoLists = @[@"http://flv3.bn.netease.com/videolib3/1711/06/qQtzb8738/HD/qQtzb8738-mobile.mp4", @"", @"", @"http://flv3.bn.netease.com/videolib3/1711/06/qQtzb8738/HD/qQtzb8738-mobile.mp4", @"", @""].mutableCopy;
    
    for (int i = 0; i<title1Arr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        kWeakSelf(cellModel);
        kWeakSelf(self);
        cellModel.height = kRealValue(195);
        
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            if (indexPath.row%3 == 0) {
                ZSHFindCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_headCell];
                [cell updateCellWithParamDic:@{@"title":title1Arr[indexPath.row], @"image":imageArr[indexPath.row]}];
                cell.playBtn.tag = indexPath.row;
                [cell.playBtn addTapBlock:^(UIButton *btn) {
                    [self startPlayVideo:btn];
                }];
                weakcellModel.height = [heightArr[indexPath.row] floatValue];
                return cell;
            } else {
                ZSHFindArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_ArticleCell];
                [cell updateCellWithParamDic:@{@"title":title1Arr[indexPath.row], @"image":imageArr[indexPath.row]}];
                weakcellModel.height = [heightArr[indexPath.row] floatValue];
                return cell;
            }
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            RLog(@"点击了该行%ld",(long)indexPath.row);
        };
    }
    return sectionModel;
}

#pragma mark -Player
-(void)getNotification
{
    //1.当前界面不在主窗口上
    if (self.view.window != nil) return;
    //2.如果当前控制器不是allViewController,不要刷新
    if (self.player) {
        ZSHFindCell *currentCell = (ZSHFindCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndexPath.row inSection:0]];
        [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
        [self.player releaseplayer];
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
}

/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (self.player==nil||self.player.superview==nil) return;
    //旋转屏幕方向
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)([UIDevice currentDevice].orientation);
    switch (interfaceOrientation) {
            //电池朝上
        case UIInterfaceOrientationPortrait:{
            if (self.isSmallScreen) {
                //放widow上,小屏显示
                [self toSmallScreen];
            }
            [self toCell];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        default:
            break;
    }
}
// 滚动的时候小屏幕，放window上显示
-(void)toSmallScreen{
    //放widow上
    [self.player removeFromSuperview];
    [self.player ToSmallScreen];
    [self setNeedsStatusBarAppearanceUpdate];
    self.isSmallScreen = YES;
}
// 当前cell显示
-(void)toCell{
    ZSHFindCell *currentCell = (ZSHFindCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndexPath.row inSection:0]];
    //移除player
    [self.player removeFromSuperview];
    self.player.transform = CGAffineTransformIdentity;
    //回到cell显示
    self.player.frame = currentCell.bounds;
    self.player.playerLayer.frame =  self.player.bounds;
    [currentCell.picView addSubview:self.player];
    [currentCell.picView bringSubviewToFront:self.player];
    [self.player BackToCell];
    //重新设置frame，重新设置layer的frame
    self.player.frame = currentCell.picView.bounds;
    [self setNeedsStatusBarAppearanceUpdate];
    self.isSmallScreen = NO;
}

// 全屏显示
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    //移除player
    [self.player removeFromSuperview];
    self.player.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        self.player.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        self.player.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    //设置frame
    self.player.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.player.playerLayer.frame =  CGRectMake(0, 0, KScreenHeight, KScreenWidth);
    
    [self.player.downView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(KScreenWidth-40);
        make.width.mas_equalTo(KScreenHeight);
    }];
    
    [self.player.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(KScreenHeight);
    }];
    
    [self.player.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.player).with.offset((-KScreenHeight/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(self.player).with.offset(5);
        
    }];
    
    [self.player.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player.topView).with.offset(45);
        make.right.equalTo(self.player.topView).with.offset(-45);
        make.center.equalTo(self.player.topView);
        make.top.equalTo(self.player.topView).with.offset(0);
    }];
    
    [self.player.FailedLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KScreenHeight);
        make.center.mas_equalTo(CGPointMake(KScreenWidth/2-36, -(KScreenWidth/2)));
        make.height.equalTo(@30);
    }];
    
    [self.player.IndicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(KScreenWidth/2-37, -(KScreenWidth/2-37)));
    }];
    [self.player.FailedLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KScreenHeight);
        make.center.mas_equalTo(CGPointMake(KScreenWidth/2-36, -(KScreenWidth/2)+36));
        make.height.equalTo(@30);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.player];
    
    self.player.fullScreenBtn.selected = YES;
    [self.player bringSubviewToFront:self.player.downView];
}
#pragma mark - 播放器的代理回调

-(void)ClosebuttonClick:(UIButton *)button{
    ZSHFindCell *currentCell = (ZSHFindCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndexPath.row inSection:0]];
    [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
    [self.player releaseplayer];
    [self setNeedsStatusBarAppearanceUpdate];
    
}
//点击全屏按钮
-(void)fullScreenClick:(UIButton *)button
{
    if (button.isSelected) {//全屏显示
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        if (self.isSmallScreen) {
            //放widow上,小屏显示
            [self toSmallScreen];
        }else{
            [self toCell];
        }
    }
}
//播放完成
-(void)finishedPlay{
    ZSHFindCell *currentCell = (ZSHFindCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndexPath.row inSection:0]];
    [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
    [self.player releaseplayer];
    [self setNeedsStatusBarAppearanceUpdate];
}


- (void)startPlayVideo:(UIButton *)sender
{
    // 获取当前的indexpath
    self.currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    //获取cell
    if ([UIDevice currentDevice].systemVersion.floatValue>=8||[UIDevice currentDevice].systemVersion.floatValue<7) {
        self.currentCell = (ZSHFindCell *)sender.superview;
    }else{
        self.currentCell = (ZSHFindCell *)sender.superview.subviews;
    }
    NSString *url = [self.viedoLists objectAtIndex:sender.tag];
    
    // 当有上一个在播放的时候 点击 就先release
    if (self.player){
        [self.player releaseplayer];
    };
    self.player = [[ADPlayer alloc] initWithFrame:self.currentCell.picView.bounds];
    self.player.delegate = self;
    self.player.VideoURL = url;
    self.player.titleLB.text = @"title";
    
    //block
    __weak typeof(self) weakSelf = self;
    self.player.buttonAction = ^(UIButton *button){
        [weakSelf fullScreenClick:button];
    };
    self.player.ClosebuttonAction = ^(UIButton *button){
        [weakSelf ClosebuttonClick:button];
    };
    self.player.finishedPlay = ^(){
        [weakSelf finishedPlay];
    };
    // 把播放器加到当前cell的imageView上面
    [self.currentCell.picView addSubview:self.player];
    [self.currentCell.picView bringSubviewToFront:self.player];
    [self.currentCell.playBtn.superview sendSubviewToBack:self.currentCell.playBtn];
    [self.player play];
    [self.tableView reloadData];
}




@end
