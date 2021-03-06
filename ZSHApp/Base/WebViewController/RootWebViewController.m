//
//  RootWebViewController.m
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootWebViewController.h"
#import <WebKit/WebKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "ZSHConfirmOrderLogic.h"
@interface RootWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
{
    WKUserContentController * userContentController;
}
@property (nonatomic, strong)  WKWebView         *wkwebView;
@property (nonatomic, strong)  UIProgressView    *progressView;  //这个是加载页面的进度条

//支付
@property (nonatomic, strong) ZSHConfirmOrderLogic   *orderLogic;
@property (nonatomic, copy)   NSString               *payType;
@property (nonatomic, strong) NSDictionary           *wechatOrderDic;
@property (nonatomic, strong) NSDictionary           *alipayOrderDic;

@end

@implementation RootWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.url = self.paramDic[@"url"];
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initProgressView];
    //支付回调
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aliPayCallBack:) name:kAliPayCallBack object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayCallBack:) name:kWXPayCallBack object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
    self.navigationController.navigationBar.hidden = NO;
    [self.wkwebView.configuration.userContentController removeScriptMessageHandlerForName:@"BackAction"];
    [self.wkwebView.configuration.userContentController removeScriptMessageHandlerForName:@"CommitOrderAction"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark 初始化webview
-(void)createUI
{
    _progressViewColor = [UIColor colorWithRed:119.0/255 green:228.0/255 blue:115.0/255 alpha:1];
    self.navigationController.navigationBar.hidden = YES;
    
    //去掉顶部20像素的状态栏
    [self setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //先实例化配置类 以前UIWebView的属性有的放到了这里
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    //注册供js调用的方法
    userContentController = [[WKUserContentController alloc]init];
   
    //返回按键
    [userContentController addScriptMessageHandler:self  name:@"BackAction"];
    //提交订单
    [userContentController addScriptMessageHandler:self  name:@"CommitOrderAction"];

    
    configuration.userContentController = userContentController;
    configuration.preferences.javaScriptEnabled = YES;//打开js交互
    _wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, KScreenHeight-20) configuration:configuration];
    [self.view addSubview:_wkwebView];
    _wkwebView.backgroundColor = KClearColor;
    _wkwebView.allowsBackForwardNavigationGestures = YES;//打开网页间的 滑动返回
    _wkwebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    _wkwebView.scrollView.backgroundColor = KClearColor;
    if (kiOS9Later) {
        _wkwebView.allowsLinkPreview = YES;//允许预览链接
    }
    _wkwebView.UIDelegate = self;
    _wkwebView.navigationDelegate = self;
    [_wkwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];//注册observer 拿到加载进度
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_wkwebView loadRequest:request];
}

#pragma mark --这个就是设置的上面的那个加载的进度
-(void)initProgressView
{
    CGFloat progressBarHeight = 3.0f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    //        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight-0.5, navigaitonBarBounds.size.width, progressBarHeight);
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height, navigaitonBarBounds.size.width, progressBarHeight);
    if (!_progressView || !_progressView.superview) {
        _progressView =[[UIProgressView alloc]initWithFrame:barFrame];
        _progressView.tintColor = [UIColor colorWithHexString:@"0485d1"];
        _progressView.trackTintColor = [UIColor clearColor];
        
        [self.navigationController.navigationBar addSubview:self.progressView];
    }
}
//检测进度条，显示完成之后，进度条就隐藏了
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (object == self.wkwebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - update nav items

-(void)updateNavigationItems{
    if (self.wkwebView.canGoBack) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -6.5;
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
        [self addNavigationItemWithTitles:@[@"返回",@"关闭"] isLeft:YES target:self action:@selector(leftBtnClick:) tags:@[@2000,@2001]];
        
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
        //iOS8系统下发现的问题：在导航栏侧滑过程中，执行添加导航栏按钮操作，会出现按钮重复，导致导航栏一系列错乱问题
        //解决方案待尝试：每个vc显示时，遍历 self.navigationController.navigationBar.subviews 根据tag去重
        //现在先把iOS 9以下的不使用动态添加按钮 其实微信也是这样做的，即便返回到webview的第一页也保留了关闭按钮
        
        if (kiOS9Later) {
            [self addNavigationItemWithImageName:@"nav_back" isLeft:YES target:self action:@selector(leftBtnClick:) tag:2001];
        }
    }
}

-(void)leftBtnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 2000:
            [self.wkwebView goBack];
            break;
        case 2001:
            [self backBtnClicked];
            break;
        default:
            break;
    }
}

-(void)reloadWebView{
    [self.wkwebView reload];
}


#pragma mark - ——————— WKNavigationDelegate ————————

// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    RLog(@"web页面开始加载");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
// 当内容开始返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    RLog(@"web页面获取内容开始返回");
}
// 页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    RLog(@"web页面加载完成");
}

// 页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    RLog(@"web页面加载失败");
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"BackAction"]) {
        RLog(@"返回按钮");
        [self backBtnClicked];
    } else if ([message.name isEqualToString:@"CommitOrderAction"]) {
        RLog(@"提交订单");
        NSDictionary *paramDic = message.body;
        [self doPayWith:paramDic];
        
    }
}

//调用第三方支付
- (void)doPayWith:(NSDictionary *)responseObject{
    if ([responseObject[@"PAYTYPE"] isEqualToString:@"微信"]) {//微信支付
        _wechatOrderDic = responseObject;
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = responseObject[@"orderStr"][@"partnerId"];
        request.prepayId= responseObject[@"orderStr"][@"prepayId"];
        request.package = responseObject[@"orderStr"][@"package"];
        request.nonceStr= responseObject[@"orderStr"][@"nonceStr"];
        request.sign = responseObject[@"orderStr"][@"sign"];
        NSString *stamp =  responseObject[@"orderStr"][@"timeStamp"];
        request.timeStamp = stamp.intValue;
        [WXApi sendReq:request];
    } else if ([responseObject[@"PAYTYPE"] isEqualToString:@"支付宝"]){//支付宝支付
        _alipayOrderDic = responseObject;
        [[AlipaySDK defaultService] payOrder:responseObject[@"orderStr"] fromScheme:kAppScheme_Alipay callback:nil];
    }
    
}

#pragma mark ————— 清理 —————
-(void)dealloc{
    [self clean];
}

-(void)clean{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.wkwebView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.wkwebView.UIDelegate = nil;
    self.wkwebView.navigationDelegate = nil;
}

//弹窗提示支付结果
- (void)showPayResultAlertWithDic:(NSDictionary *)dic{
    _orderLogic = [[ZSHConfirmOrderLogic alloc]init];
    [_orderLogic requestPayInfoWithParamDic:@{@"ORDERNUMBER":dic[@"ORDERNUMBER"]} Success:^(id responseObject) {
        UIAlertView *payResultAlert = [[UIAlertView alloc]initWithTitle:@"支付结果" message:responseObject[@"pd"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [payResultAlert show];
    } fail:nil];
}

//微信支付回调
- (void)wxPayCallBack:(NSNotification *)noti{
    [self showPayResultAlertWithDic:_wechatOrderDic];
}

//支付宝回调
- (void)aliPayCallBack:(NSNotification *)noti{
    [self showPayResultAlertWithDic:_alipayOrderDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
