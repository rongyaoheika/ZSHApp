//
//  ZSHTopLineMoreTypeViewController.h
//  ZSHApp
//
//  Created by mac on 2018/2/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RootViewController.h"
#import "ChannelCell.h"


/**
 选择出来的tags们
 
 @param tags 数组里都是对象
 */
typedef void(^ChoosedTags)(NSArray *chooseTags,NSArray *recommandTags);


/**
 单独选择的tag
 
 @param channel channel对象
 */
typedef void(^SelectedTag)(Channel *channel);
@interface ZSHTopLineMoreTypeViewController : RootViewController

@property (nonatomic, strong) UICollectionView      *mainView ;
@property (nonatomic, strong) NSMutableArray        *myChannels ;
@property (nonatomic, strong) NSMutableArray        *recommandChannels ;
@property (nonatomic, copy) ChoosedTags             choosedTags ;
@property (nonatomic, copy) SelectedTag             selectedTag ;

@end
