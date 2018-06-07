//
//  AliyunPlaySDKDemoFullScreenScrollViewController.m
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/8/16.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import "AliyunPlaySDKDemoFullScreenScrollViewController.h"
#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>
#import "AliyunPlaySDKDemoFullScreenScrollCollectionViewCell.h"
#import "ZSHAudienceLivePopView.h"
#import "ZSHLiveLogic.h"
#import "ZSHPersonalCenterViewController.h"

@interface AliyunPlaySDKDemoFullScreenScrollViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) ZSHAudienceLivePopView     *audienceView;

@end

@implementation AliyunPlaySDKDemoFullScreenScrollViewController
static NSString *cellId = @"customCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kWeakSelf(self);
    self.isHidenNaviBar = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushLivePersonInfoVCAction) name:KPushLivePersonInfoVC object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareInfoAction:) name:KShareInfo object:nil];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize =  CGSizeMake(KScreenWidth, KScreenHeight);
    layout.minimumInteritemSpacing=0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakself.view).insets(UIEdgeInsetsMake(0, 0, KBottomHeight, 0));
    }];
    
    [self.view addSubview:self.audienceView];
    self.audienceView.dissmissViewBlock = ^(UIButton *btn) {
        NSArray *ary = [weakself.collectionView visibleCells];
        for (AliyunPlaySDKDemoFullScreenScrollCollectionViewCell *cell in ary) {
            [cell releasePlayer];
        }
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    if(!self.publishUrl){
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"live_room_bg"]];
        image.backgroundColor = [UIColor redColor];
        image.frame = self.view.bounds;
        [self.audienceView insertSubview:image atIndex:0];
    }
    
}

- (void)pushLivePersonInfoVCAction{
    ZSHPersonalCenterViewController *vc = [[ZSHPersonalCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 5;
    
    return 1;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //开多个分区，没有使用重用机制。
   static NSString *identifier=@"identifier";
    [collectionView registerClass:[AliyunPlaySDKDemoFullScreenScrollCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    AliyunPlaySDKDemoFullScreenScrollCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
                                                               
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    AliyunPlaySDKDemoFullScreenScrollCollectionViewCell *temp =  (AliyunPlaySDKDemoFullScreenScrollCollectionViewCell*)cell;
    [temp prepareWithPublishUrl:self.publishUrl];
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    AliyunPlaySDKDemoFullScreenScrollCollectionViewCell *temp =  (AliyunPlaySDKDemoFullScreenScrollCollectionViewCell*)cell;
    [temp stopPlay];
}


#pragma mark - 懒加载
- (ZSHAudienceLivePopView *)audienceView {
    if (!_audienceView) {
        _audienceView = [[ZSHAudienceLivePopView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _audienceView.backgroundColor = [UIColor clearColor];
    }
    return _audienceView;
}

- (void)shareInfoAction:(NSNotification *)noti{
    kWeakSelf(self);
    UIButton *btn = [noti.object objectForKey:@"btn"];
    NSInteger sharePlatform = UMSocialPlatformType_WechatTimeLine;
    switch (btn.tag) {
        case 1://朋友圈
            sharePlatform = UMSocialPlatformType_WechatTimeLine;
            break;
        case 2://好友
            sharePlatform = UMSocialPlatformType_WechatSession;
            break;
        case 3://QQ好友
            sharePlatform = UMSocialPlatformType_QQ;
            break;
        case 4://QQ空间
            sharePlatform = UMSocialPlatformType_Qzone;
            break;
        case 5://新浪
            sharePlatform = UMSocialPlatformType_Sina;
            break;
        default:
            break;
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        UIImage *screenShot = [weakself takeScreenShot];
       
        NSString *shareText = @"荣耀黑卡，风暴来袭";
        NSString *descr = @"荣耀黑卡为您提供至尊轻奢服务，期待您的入驻，期待您的关注";
        UIImage *screenShot = [UIImage imageNamed:@"home_service"];
        [[ShareManager sharedShareManager]shareToPlatform:sharePlatform title:shareText descr:descr image:screenShot url:nil controller:weakself callback:^(BOOL flag) {
            if (flag) {
                RLog(@"分享成功！");
            }
        }];
    });

}

//屏幕快照
- (UIImage *)takeScreenShot {
    // 截图
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
