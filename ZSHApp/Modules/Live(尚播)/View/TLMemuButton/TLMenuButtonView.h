//
//  TLMenuButtonView.h
//  MiShu
//
//  Created by tianlei on 16/6/24.
//  Copyright © 2016年 Qzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLMenuButtonView : UIView

@property (nonatomic, assign) CGPoint centerPoint;

- (void)showItems;
- (void)dismiss;
- (void)dismissAtNow;

@property (nonatomic, copy) void (^clickLiveSubButton)(NSInteger index);

@end
