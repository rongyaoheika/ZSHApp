//
//  ZSHCycleScrollView.m
//  ZSHApp
//
//  Created by Apple on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCycleScrollView.h"
#define kHeight      self.frame.size.height
#define kWidth       self.frame.size.width

@interface ZSHCycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView       *scrollView;
@property (nonatomic, strong) UIPageControl      *pageControl;
@property (nonatomic, strong) NSTimer            *timer;
@property (nonatomic, strong) UIImageView        *noticeImageView;

@end

@implementation ZSHCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:self.bounds];
        scrollview.pagingEnabled = YES;
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.delegate = self;
        [self addSubview:scrollview];
        self.scrollView = scrollview;

        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.hidesForSinglePage = YES;
        pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        pageControl.backgroundColor = [UIColor clearColor];
        [self addSubview:pageControl];
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.bottom.mas_equalTo(self.bottom).offset(-4);
            make.height.mas_equalTo(6);
            make.width.mas_equalTo(self);
        }];
        self.pageControl = pageControl;
    }
    return self;
}

-(void)startTime{
    [self stopTime];
    if (!self.autoScroll) {
        return;
    }
    // 一页的时候不开启定时器
    if (self.dataArr.count<2) {
        return;
    }
    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)stopTime{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    
    // scrollview设置
    NSInteger countOfFocus = dataArr.count;
    
    if (self.scrollDirection == ZSHCycleScrollViewVertical) {
        //垂直滚动
        UIImage *image = [UIImage imageNamed:@"home_notice_head"];
        self.scrollView.contentSize = CGSizeMake(0, (countOfFocus+2)*kHeight);
        [self addSubview:self.noticeImageView];
        [self.noticeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self).offset(1);
            make.width.mas_equalTo(image.size.width);
            make.height.mas_equalTo(image.size.height);
            make.left.mas_equalTo(15);
        }];
        
    } else {
        //水平滚动
        self.scrollView.contentSize = CGSizeMake((countOfFocus+2)*kWidth, 0);
    }
    
    self.pageControl.numberOfPages = countOfFocus;
    for (int index=1; index<=countOfFocus; index++) {
        [self addItemWithData:dataArr[index-1] atIndex:index realIndex:index-1];
    }
    
    [self addItemWithData:[_dataArr lastObject] atIndex:0 realIndex:countOfFocus - 1];
    [self addItemWithData:[_dataArr firstObject]atIndex:countOfFocus+1 realIndex:0];
    
    // 将ScrollView滑动到第一页
    CGPoint contentOffset = self.scrollView.contentOffset;
    
    if (self.scrollDirection == ZSHCycleScrollViewVertical) {
        //垂直滑动
        contentOffset.y = kHeight;
        
    } else {
        //水平滑动
        contentOffset.x = kWidth;
    }
    
    self.scrollView.contentOffset = contentOffset;
    self.pageControl.currentPage = 0;
    
    // 开启定时器
    if (dataArr.count>1) {
        [self startTime];
    }
    
}

/**
 * 添加图片或文字到ScrollView里
 */
-(void) addItemWithData:(id)item atIndex:(NSInteger)index realIndex:(NSInteger)realIndex{
    UIButton *button = [[UIButton alloc]init];
    if (self.scrollDirection == ZSHCycleScrollViewVertical) {
        //垂直滑动
        button.frame = CGRectMake(20 + kRealValue(40), kHeight * index, kWidth, kHeight);
    } else {
        // 水平滑动
        button.frame =CGRectMake(kWidth * index, 0, kWidth, kHeight);
    }
    
    button.tag = realIndex+1;
    [button addTarget:self action:@selector(itemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    if ([item isKindOfClass:[UIImage  class]]) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
        [button addSubview:imgView];
        imgView.image = item;
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(button);
            make.centerX.mas_equalTo(button);
            make.size.mas_equalTo(imgView.image.size);
        }];
    } else if ([item isKindOfClass:[NSString class]]){
        
        self.pageControl.hidden = YES;
        UILabel *label  = [[UILabel alloc]initWithFrame:button.bounds];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = kPingFangLight(14);
        label.textColor = KZSHColor929292;
        label.text = (NSString *)item;
        [button addSubview:label];
    }
    
}


-(void)itemDidClicked:(UIButton *)btn{
    if (self.itemClickBlock) {
        self.itemClickBlock(btn.tag-1);
    }
}

//自动滑动
-(void)timeTick{
    CGPoint newOffset = self.scrollView.contentOffset;
    
    if (self.scrollDirection == ZSHCycleScrollViewVertical) {
        //垂直滑动
        newOffset.y = (NSInteger)(newOffset.y/kHeight)*kHeight;
        newOffset.y += kHeight;
        
    } else {
        // 水平滑动
        newOffset.x = (NSInteger)(newOffset.x/kWidth)*kWidth;
        newOffset.x += kWidth;
    }
    
    [self.scrollView setContentOffset:newOffset animated:YES];
}


-(void)adjustScrollView{
    NSInteger count = _dataArr.count;
    CGPoint newOffset = self.scrollView.contentOffset;
    NSInteger index = 0;
    if (self.scrollDirection == ZSHCycleScrollViewVertical) {
        //垂直滑动
        index = floor(newOffset.y/kHeight);
    } else {
        //水平滑动
        index = floor(newOffset.x/kWidth);
    }
    
    
    
    if (index == 0) {
        if (self.scrollDirection == ZSHCycleScrollViewVertical) {
            //垂直滑动
            newOffset.y = count * kHeight;
        } else {
            //水平滑动
            newOffset.x = count * kWidth;
        }
        
        //        self.scrollView.contentOffset = newOffset;
        [self.scrollView setContentOffset:newOffset animated:NO];
        self.pageControl.currentPage = count-1;
    }else if(index == count+1){
        if (self.scrollDirection == ZSHCycleScrollViewVertical) {
            //垂直滑动
            newOffset.y = kHeight;
        } else {
            //水平滑动
            newOffset.x = kWidth;
        }
        
        //        self.scrollView.contentOffset = newOffset;
        [self.scrollView setContentOffset:newOffset animated:NO];
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage = index - 1;
    }
}

#pragma delegate

/*
 * 拖拽时先停止timer
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.timer) {
         [self stopTime];
    }
}

/*
 * 手动滑动完毕时调用
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self adjustScrollView];
    [self startTime];
}

/*
 * 自动滑动完毕时调用
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self adjustScrollView];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    //及时显示pageControl的index
    NSInteger count = self.dataArr.count;
    NSInteger index = 0;
    if (self.scrollDirection == ZSHCycleScrollViewVertical) {
        //垂直滑动
        index = floor((*targetContentOffset).y / kHeight);
    } else {
        //水平滑动
        index = floor((*targetContentOffset).x / kWidth);
    }
    
    if (index == 0) {
        // 当offset为0时
        self.pageControl.currentPage = count - 1;
    } else if (index == count + 1) {
        // 当offset为最后一页时
        self.pageControl.currentPage = 0;
    } else {
        //其它页
        self.pageControl.currentPage = index - 1;
    }
}

- (UIImageView *)noticeImageView{
    if (!_noticeImageView) {
        UIImage *image = [UIImage imageNamed:@"home_notice_head"];
        _noticeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, image.size.width, image.size.height)];
        _noticeImageView.centerY = self.centerY;
        _noticeImageView.image = image;
        _noticeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _noticeImageView.clipsToBounds = YES;
    }
    return _noticeImageView;
}

@end
