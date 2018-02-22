//
//  RootViewController.h
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import "UIViewController+AlertViewAndActionSheet.h"
#import "ZSHBaseTableViewModel.h"
#import "UIButton+XYButton.h"
#import "ZSHSearchBarView.h"

typedef void(^RemoveCompletedBlock)();
typedef void(^ZSHBottomBtnViewBtnBlock)(NSInteger);
/**
 VC 基类
 */
@interface RootViewController : UIViewController

/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle          StatusBarStyle;
@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic, strong) UIButton                  *bottomBtn;
@property (nonatomic, strong) UIView                    *bottomBtnView;
@property (nonatomic, copy)   ZSHBottomBtnViewBtnBlock  bottomBtnViewBtnBlock;
@property (nonatomic, strong) ZSHBaseTableViewModel     *tableViewModel;
@property (nonatomic, strong) UICollectionView          *collectionView;
@property (nonatomic, strong) ZSHSearchBarView          *searchView;
@property (nonatomic, strong) NSDictionary              *paramDic;
@property (nonatomic, strong) UIButton                  *leftBtn;

/**
 跳转登录
 */
- (void)goLogin;
- (void)goLoginWithPush;

/**
 *  显示没有数据页面
 */
-(void)showNoDataImage;

/**
 *  移除无数据页面
 */
-(void)removeNoDataImage;

/**
 *  需要登录
 */
- (void)showShouldLoginPoint;

/**
 *  加载视图
 */
- (void)showLoadingAnimation;

/**
 *  停止加载
 */
- (void)stopLoadingAnimation;

/**
 *  是否显示返回按钮,默认情况是YES
 */
@property (nonatomic, assign) BOOL isShowLiftBack;

/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL isHidenNaviBar;

/**
 导航栏添加文本按钮
 
 @param imageName       图片名字
 @param title           字体
 @param imageLocate     文字图片相对位置
 @param isLeft          是否是左边 非左即右
 @param target          目标
 @param action          点击方法
 @param tag             按钮标记，回调区分用
 */
- (void)addNavigationItemWithImageName:(NSString *)imageName title:(NSString *)title locate:(XYButtonEdgeInsetsStyle)imageLocate isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tag:(NSInteger)tag;

/**
 导航栏添加文本按钮

 @param titles 文本数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags    回调区分用
 */
- (void)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;
/**
 导航栏添加图标按钮

 @param imageName 图标名字
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tag 回调区分用
 */
- (void)addNavigationItemWithImageName:(NSString *)imageName isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tag:(NSInteger)tag;

/**
 *  默认返回按钮的点击事件，默认是返回，子类可重写
 */
- (void)backBtnClicked;

//取消网络请求
- (void)cancelRequest;

//跳转是传递参数
- (instancetype)initWithParamDic:(NSDictionary *)paramDic;

- (void)createUI;
- (void)loadData;

- (void) showProgress;
- (void) hideProgress;

- (void)endTabViewRefresh;
- (void)endCollectionViewRefresh;
- (void)collectionHeaderRereshing;
- (void)collectionFooterRereshing;
//定位
- (void)startLocateWithDelegate:(id)delegate;


@end
