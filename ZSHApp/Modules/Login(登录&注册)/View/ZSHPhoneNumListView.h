//
//  ZSHPhoneNumListView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"
typedef void(^TapBlock)(NSString *section, NSInteger index);

@interface ZSHPhoneNumListView : ZSHBaseView

@property (nonatomic , copy) TapBlock tapBlock;

- (void)selectedByIndex:(NSUInteger)index;

@end
