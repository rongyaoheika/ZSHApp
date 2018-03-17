//
//  RootWebViewController.h
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
//#import "RxWebViewController.h"
/**
 WebView 基类
 */
@interface RootWebViewController : RootViewController
/**
 *  origin url
 */
@property (nonatomic)NSString* url;

/**
 *  embed webView
 */
//@property (nonatomic)UIWebView* webView;

/**
 *  tint color of progress view
 */
@property (nonatomic)UIColor* progressViewColor;


-(void)reloadWebView;


@end
