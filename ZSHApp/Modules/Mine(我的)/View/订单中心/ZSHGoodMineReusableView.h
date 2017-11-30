//
//  ZSHGoodMineReusableView.h
//  ZSHApp
//
//  Created by apple on 2017/11/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSHGoodMineReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *headLabel;

- (void)updateWithTitle:(NSString *)title;

@end
