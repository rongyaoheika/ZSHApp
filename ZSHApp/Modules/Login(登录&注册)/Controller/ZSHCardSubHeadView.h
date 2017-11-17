//
//  ZSHCardSubHeadView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"

typedef NS_ENUM(NSInteger,ZSHToCardSubHeadView ){
    FromCustomizedCellToCardSubHeadView ,        //定制-头部视图
    FromCardNumCellToCardSubHeadView,           //定制手机号-头部视图
    FromNoneToCardSubHeadView
};

typedef void (^HeadRightBtnActionBlock) (NSInteger);

@interface ZSHCardSubHeadView : ZSHBaseView

@property (nonatomic, copy) HeadRightBtnActionBlock    rightBtnActionBlock;

@end
