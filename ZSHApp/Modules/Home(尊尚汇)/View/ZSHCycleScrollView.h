//
//  ZSHCycleScrollView.h
//  ZSHApp
//
//  Created by Apple on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger{
    ZSHCycleScrollViewHorizontal,
    ZSHCycleScrollViewVertical,
} ZSHCycleScrollViewDirection;

typedef void(^ItemClickBlock)(NSInteger);

@interface ZSHCycleScrollView : UIView

@property (nonatomic, strong)NSMutableArray                *dataArr;
@property (nonatomic, copy)  ItemClickBlock                itemClickBlock;
@property (nonatomic, assign)ZSHCycleScrollViewDirection   scrollDirection;
@property (nonatomic, assign)BOOL                          autoScroll;

@end
