//
//  ZSHLiveGiftView.m
//  ZSHApp
//
//  Created by mac on 2018/1/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHLiveGiftView.h"

@interface ZSHLiveGiftView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView            *headView;
@property (nonatomic, strong) UIScrollView      *midScrollView;

@property (nonatomic, strong) NSArray           *btnTitleArr;
@property (nonatomic, strong) NSMutableArray    *btnArr;
@property (nonatomic, strong) NSArray           *scrollContentArr;
@property (nonatomic, assign) NSInteger         midScrollIndex;
@property (nonatomic, assign) NSInteger         subScrollIndex;

//底部
@property (nonatomic, strong) UIView            *footView;
@property (nonatomic, strong) UIButton          *rechargeBtn;
@property (nonatomic, strong) UIImageView       *giftBtnView;
@property (nonatomic, strong) UIButton          *giftLeftBtn;
@property (nonatomic, strong) UIButton          *giftRightBtn;

@property (nonatomic, strong) UIPageControl     *pageControl;
@end

@implementation ZSHLiveGiftView

- (void)setup{
    
    [self loadLocalData];
    [self createUI];
    
    
}

- (void)createUI{
    self.backgroundColor = [UIColor blackColor];
    [self createHeadView];
    [self createMidView];
    [self createFootView];
}

- (void)loadLocalData{
    _btnArr = [[NSMutableArray alloc]init];
    _btnTitleArr = @[@"常规",@"轻奢"];
    _scrollContentArr = @[@(2),@(2)];
    _midScrollView = 0;
    _subScrollIndex = 0;
}

- (void)createHeadView{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(50))];
    [self addSubview:_headView];
    
    for (int i = 0; i<_btnTitleArr.count; i++) {
        NSDictionary *liveTypeBtnDic = @{@"title":_btnTitleArr[i],@"font":kPingFangMedium(15)};
        UIButton *liveTypeBtn = [ZSHBaseUIControl createBtnWithParamDic:liveTypeBtnDic];
        liveTypeBtn.frame = CGRectMake(i*kRealValue(65), 0, kRealValue(65), kRealValue(50));
        [liveTypeBtn addTarget:self action:@selector(liveTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        liveTypeBtn.tag = i+1;
        [_headView addSubview:liveTypeBtn];
        [_btnArr addObject:liveTypeBtn];
    }
    [self selectedByIndex:1];
}

//礼物UI
- (void)createMidView{
    [self addSubview:self.midScrollView];
    for (int i = 0; i<_btnTitleArr.count; i++) {
        UIScrollView *giftSV = [self createScrollViewWithIndex:i Count:[_scrollContentArr[i] integerValue] ];
        [self.midScrollView addSubview:giftSV];
    }
}

//底部送礼物UI
- (void)createFootView{
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.midScrollView.frame), KScreenWidth, kRealValue(50))];
    [self addSubview:_footView];
    
    NSDictionary *rechargeBtnDic = @{@"title":@"充值",@"font":kPingFangRegular(15)};
    _rechargeBtn = [ZSHBaseUIControl createBtnWithParamDic:rechargeBtnDic];
    
    [_footView addSubview:_rechargeBtn];
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_footView);
        make.left.mas_equalTo(_footView).offset(KLeftMargin);
        make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(15)));
    }];
    
    [_footView addSubview:self.pageControl];
    self.pageControl.numberOfPages = [_scrollContentArr[0]integerValue];
    
    [self createGiftBtnView];
    
}

//具体礼物ScrollView
- (UIScrollView *)createScrollViewWithIndex:(NSInteger)index Count:(NSInteger)count{
    UIScrollView *giftSV = [[UIScrollView alloc]initWithFrame:CGRectMake(index*KScreenWidth, 0, KScreenWidth, kRealValue(190))];
    giftSV.tag = index+20;
    giftSV.contentSize = CGSizeMake(count*KScreenWidth, 0);
    giftSV.showsVerticalScrollIndicator = NO;
    giftSV.showsHorizontalScrollIndicator = NO;
    giftSV.pagingEnabled = YES;
    giftSV.delegate = self;
    
    NSArray *btnDicArr = @[
                           @[
                               @[
                                   @{@"btnNormalImage":@"gift_image_0",@"btnTitle":@"心",@"coinTile":@"1黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_1",@"btnTitle":@"星星",@"coinTile":@"1黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_2",@"btnTitle":@"棒棒糖",@"coinTile":@"1黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_3",@"btnTitle":@"棒棒糖",@"coinTile":@"1黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_4",@"btnTitle":@"红包",@"coinTile":@"6黑咖币"},
                                   ],
                               
                               @[
                                   @{@"btnNormalImage":@"gift_image_5",@"btnTitle":@"奖杯",@"coinTile":@"10黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_6",@"btnTitle":@"冰淇淋",@"coinTile":@"18黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_7",@"btnTitle":@"奶酪",@"coinTile":@"28黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_8",@"btnTitle":@"小蛋糕",@"coinTile":@"68黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_9",@"btnTitle":@"皇冠",@"coinTile":@"188黑咖币"},
                                   ],
                               
                               ],
                           
                           @[
                               @[
                                   @{@"btnNormalImage":@"gift_image_10",@"btnTitle":@"蓝色妖姬",@"coinTile":@"1黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_11",@"btnTitle":@"小熊",@"coinTile":@"1黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_12",@"btnTitle":@"炸弹",@"coinTile":@"1黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_13",@"btnTitle":@"口红",@"coinTile":@"1黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_14",@"btnTitle":@"么么哒",@"coinTile":@"1黑咖币"},
                                   ],
                               
                               @[
                                   @{@"btnNormalImage":@"gift_image_15",@"btnTitle":@"炮竹",@"coinTile":@"18黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_16",@"btnTitle":@"巧克力",@"coinTile":@"68黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_17",@"btnTitle":@"包包",@"coinTile":@"188黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_18",@"btnTitle":@"蓝钻石",@"coinTile":@"288黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_19",@"btnTitle":@"皮卡丘",@"coinTile":@"288黑咖币"},
                                   ],
                               
                               ],
                           ];
    
    
    
    CGFloat viewW = KScreenWidth/5;
    CGFloat viewH = kRealValue(190)/2;
    
    for (int contentCount = 0; contentCount<count; contentCount++) {//contentSize
    
        for (int i = 0; i<2; i++) {//2行
            for (int j = 0; j <5; j++) {//5列
                UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth*contentCount + j*viewW, i*viewH, viewW, viewH)];
                [giftSV addSubview:btnView];
                
                //图片
                UIImageView *giftIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:btnDicArr[index][i][j][@"btnNormalImage"]]];
                [btnView addSubview:giftIV];
                [giftIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(kRealValue(45), kRealValue(45)));
                    make.centerX.mas_equalTo(btnView);
                    make.top.mas_equalTo(btnView).offset(kRealValue(10));
                }];
                
                
                //文字
                NSDictionary *giftLBDic = @{@"text":btnDicArr[index][i][j][@"btnTitle"],@"font":kPingFangRegular(12),@"textAlignment":@(NSTextAlignmentCenter)};
                UILabel *giftLB = [ZSHBaseUIControl createLabelWithParamDic:giftLBDic];
                [btnView addSubview:giftLB];
                [giftLB mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(btnView);
                    make.centerX.mas_equalTo(btnView);
                    make.top.mas_equalTo(giftIV.mas_bottom);
                    make.height.mas_equalTo(kRealValue(22));
                }];
                
                //消费
                NSDictionary *coinLBDic = @{@"text":btnDicArr[index][i][j][@"coinTile"],@"font":kPingFangRegular(10),@"textAlignment":@(NSTextAlignmentCenter)};
                UILabel *coinLB = [ZSHBaseUIControl createLabelWithParamDic:coinLBDic];
                [btnView addSubview:coinLB];
                [coinLB mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(btnView);
                    make.centerX.mas_equalTo(btnView);
                    make.top.mas_equalTo(giftLB.mas_bottom);
                    make.height.mas_equalTo(kRealValue(10));
                }];
            }
        }
        
    }
    
    
    return giftSV;
    
}

#pragma 懒加载
//外层礼物ScrollView
- (UIScrollView *)midScrollView{
    if (!_midScrollView) {
        _midScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kRealValue(50), KScreenWidth, kRealValue(190))];
        _midScrollView.tag = 10;
        _midScrollView.contentSize = CGSizeMake(2*KScreenWidth, 0);
        _midScrollView.showsVerticalScrollIndicator = NO;
        _midScrollView.showsHorizontalScrollIndicator = NO;
        _midScrollView.pagingEnabled = YES;
        _midScrollView.delegate = self;
    }
    return _midScrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((KScreenWidth-kRealValue(100))/2, 0, kRealValue(100), kRealValue(50))];
        _pageControl.currentPageIndicatorTintColor = KZSHColor929292;
        _pageControl.pageIndicatorTintColor = KZSHColor2A2A2A;
    }
    return _pageControl;
}

- (UIView *)createGiftBtnView{
    
    _giftBtnView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"give_gift"]];
    _giftBtnView.userInteractionEnabled = YES;
    _giftBtnView.clipsToBounds = YES;
    [self.footView addSubview:_giftBtnView];
    [_giftBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_footView).offset(-KLeftMargin);
        make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(30)));
        make.centerY.mas_equalTo(_footView);
    }];
    
    _giftLeftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kRealValue(50), kRealValue(30))];
    [_giftLeftBtn addTarget:self action:@selector(giftLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_giftLeftBtn setTitle:@"1" forState:UIControlStateNormal];
    [_giftLeftBtn setImage:[UIImage imageNamed:@"gift_more"] forState:UIControlStateNormal];
    [_giftLeftBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(15)];
    [_giftBtnView addSubview:_giftLeftBtn];
    
    _giftRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(kRealValue(55), 0, kRealValue(50), kRealValue(30))];
    [_giftRightBtn addTarget:self action:@selector(giftRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_giftRightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_giftRightBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(15)];
    [_giftBtnView addSubview:_giftRightBtn];
    
    
    
    return _giftBtnView;
}

#pragma action
- (void)liveTypeBtnAction:(UIButton *)btn{
    [self selectedByIndex:btn.tag];
    
}

- (void)giftLeftBtnAction:(UIButton *)btn{
    RLog(@"点击左侧按钮");
}

- (void)giftRightBtnAction:(UIButton *)btn{
    RLog(@"点击右侧发送按钮");
}

#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) return;
    [self dealPageEnableWithScrollView:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self dealPageEnableWithScrollView:scrollView];
}
#pragma mark 处理scrollView翻页效果
- (void)dealPageEnableWithScrollView:(UIScrollView *)scrollView{
//     NSInteger midScrollViewIndex = (NSInteger)(fabs((scrollView.contentOffset.x/KScreenWidth)));
//    RLog(@"scrollView 的tag == %ld  page==%ld   contentoffset==%f",scrollView.tag,midScrollViewIndex,scrollView.contentOffset.x);
    if (scrollView.tag == 10) {//外层scrollview
        NSInteger midScrollViewIndex = (NSInteger)(fabs((scrollView.contentOffset.x/KScreenWidth)));
        [self selectedByIndex:midScrollViewIndex+1];
        self.pageControl.numberOfPages = [_scrollContentArr[midScrollViewIndex]integerValue];
       
        UIScrollView *subScrollView = [self.midScrollView viewWithTag:midScrollViewIndex + 20];
        NSInteger subScrollIndex = (NSInteger)(fabs((subScrollView.contentOffset.x/KScreenWidth)));
        self.pageControl.currentPage = subScrollIndex;

    } else {//内层scrollview
        
        NSInteger subScrollIndex = (NSInteger)(fabs((scrollView.contentOffset.x/KScreenWidth)));
        self.pageControl.currentPage = subScrollIndex;
        [scrollView setContentOffset:CGPointMake(KScreenWidth * subScrollIndex,0)];
    }
    
   
    
}

- (void)selectedByIndex:(NSUInteger)index {
    [_btnArr enumerateObjectsUsingBlock:^(UIButton *btn , NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn.tag == index) {
            btn.selected = YES;
            btn.titleLabel.font = kPingFangMedium(15);
        } else {
            btn.selected = NO;
            btn.titleLabel.font = kPingFangRegular(15);
        }
    }];
    
    //外层scrollview
    self.pageControl.numberOfPages = [_scrollContentArr[index-1]integerValue];
    [_midScrollView setContentOffset:CGPointMake((index-1)*kScreenWidth, 0)];
    
    //内层scrollview
    UIScrollView *subScrollView = [self.midScrollView viewWithTag:(index-1) + 20];
    [subScrollView setContentOffset:CGPointMake(0, 0)];//默认第0组
}

@end
