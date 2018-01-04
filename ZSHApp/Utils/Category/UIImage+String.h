//
//  UIImage+String.h
//  ZSHApp
//
//  Created by mac on 29/12/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (String)
+ (UIImage *)imageToAddText:(UIImage *)img withText:(NSString *)text;
+ (UIImage *)getImage:(NSString *)name;
@end
