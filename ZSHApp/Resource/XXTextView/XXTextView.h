//
//  XXTextView.h
//  Remember
//
//  Created by Jason on 2017/5/21.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BeginEditBlock) ();

@interface XXTextView : UITextView

@property (copy, nonatomic, nullable) IBInspectable NSString *xx_placeholder;

@property (strong, nonatomic, nullable) IBInspectable UIColor *xx_placeholderColor;

@property (strong, nonatomic, nullable) UIFont *xx_placeholderFont;

@property (copy, nonatomic, nullable) BeginEditBlock  beginEdit;


@end
