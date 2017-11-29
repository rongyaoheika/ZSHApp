//
//  URLMacros.h
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#ifndef URLMacros_h
#define URLMacros_h


//内部版本号 每次发版递增
#define KVersionCode 1
/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever    1
#define TestSever       0
#define ProductSever    0

#if DevelopSever

/**开发服务器*/
#define kUrlRoot                    @"http://192.168.1.108:8080/ZSHINTER/"
//#define kUrlRoot                  @"http://192.168.11.122:8090" //展鹏

#elif TestSever

/**测试服务器*/
#define kUrlRoot                   @"http://192.168.1.108:8080/ZSHINTER/"

#elif ProductSever

/**生产服务器*/
#define kUrlRoot                   @"http://192.168.1.108:8080/ZSHINTER/"

#endif




#pragma mark - ——————— 详细接口地址 ————————

//测试接口
#define kUrlTest                    @"/api/cast/home/start"

#pragma mark - ——————— 用户相关 ————————
//自动登录
#define kUrlUserAutoLogin           @"/api/autoLogin"
//登录
#define kUrlUserLogin               @"/appuserin/userloginphone?LOGIN"

// 1首页推荐（完成）
#define kUrlUserHome [NSString stringWithFormat:@"/apphomein/getrecommendlist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"COMMEND"]]
// 2用户注册
#define kUrlUserRegister [NSString stringWithFormat:@"/appuserin/userregister?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"REGISTER"]]
// 3用户登录
//  手机号登录
//  参数：PHONE 手机号
#define kUrlUserLoginPhone [NSString stringWithFormat:@"/appuserin/userloginphone?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"LOGIN"]]
//  卡密登录
//  参数：CARDNO 登录会员卡号/PASSWORD 登录密码
#define kUrlUserLoginCard [NSString stringWithFormat:@"/appuserin/userlogincard?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"LOGIN"]]
// 4获取用户收货地址列表
#define kUrlUserShipAdr [NSString stringWithFormat:@"/appuserin/usershipadr?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPADR"]]
// 5添加用户收货地址
//  参数：CONSIGNEE 收货人姓名/ADRPHONE 收货人电话/PROVINCE  收货人所在地区/ADDRESS  收货人详细地址
#define kUrlUserAddShipAdr [NSString stringWithFormat:@"/appuserin/useraddshipadr?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPADR"]]
// 6修改用户收货地址
// 参数：ADDRESS_ID 收货地址ID/CONSIGNEE 收货人姓名/ADRPHONE 收货人电话/PROVINCE 收货人所在地区/ADDRESS 收货人详细地址
#define kUrlUserEdiShipAdr [NSString stringWithFormat:@"/appuserin/useredishipadr?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPADR"]]
//7.删除用户收货地址
//参数：ADDRESS_ID 当前收货地址id
#define kUrlUserDelShipAdr [NSString stringWithFormat:@"/appuserin/userdelshipadr?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPADR"]]
//8.获取商品具体详情
//参数：PRODUCT_ID 商品具体id
//请求地址：/appshipin/shipdetails?SHIPDT(混淆码)
#define kUrlShipDetails [NSString stringWithFormat:@"/appshipin/shipdetails?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPDT"]]
//9.获取所有商品列表
//参数：无参数
//请求地址：/appshipin/shiplistall?SHIPAll(混淆码)
#define kUrlShipListAll [NSString stringWithFormat:@"/appshipin/shiplistall?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPAll"]]
//10.获得类别下商品品牌列表
//参数：BRAND_ID 类型参数id
//请求地址：/appshipin/shipbrandiconlist?SHIPBRIC(混淆码)
#define kUrlShipBrandIconList [NSString stringWithFormat:@"/appshipin/shipbrandiconlist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPBRIC"]]
//11.获得商品类别列表
//参数：无参数
//请求地址：/appshipin/shipbrandlist?SHIPBR(混淆码)
#define kUrlShipBrandList [NSString stringWithFormat:@"/appshipin/shipbrandlist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPBR"]]
//12.尊购首页专区点击之后的列表
//参数：BRAND_ID 类型参数id
//(手表id:1b4ed4c57ef04933b97e8def48fc423a)
//(包袋id:a34d1f14a4b7481e8284ad4ba97a496b)
//(首饰id:2df2c7e628b14341be1e2932cb377c82)
//(豪车id:c387f598e5c64a1ea275a7ca3e77518c)
//(飞机游艇id:668b21fc68a44080899cfd840107af22)
//(家电数码id:a1d59672053f45e1a5499fb1d5850144)
//(高尔夫汇id：暂无)
//请求地址：/appshipin/shipprefecture?SHIPPRE(混淆码)
#define kUrlShipPrefecture [NSString stringWithFormat:@"/appshipin/shipprefecture?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPPRE"]]
//13.获得用户名下所有订单列表
//参数：HONOURUSER_ID 用户id
//请求地址：/apporderin/orderalllist?ALLORDER(混淆码)
#define kUrlOrderAllList [NSString stringWithFormat:@"/apporderin/orderalllist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ALLORDER"]]
//14.获取用户名带条件查询的订单列表（待付款，待收货，待评价，已完成）
//参数：HONOURUSER_ID 用户id/CONORDER 查询状态
//（0040001）为待付款状态
//(0040002) 为待收货状态
//(0040003) 为待评价状态
//(0040004) 为已完成订单状态
//请求地址：/apporderin/orderconlist?CONORDER(混淆码)
#define kUrlOrderConList [NSString stringWithFormat:@"/apporderin/orderconlist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CONORDER"]]
//15.购物车列表
//参数：HONOURUSER_ID 用户id
//请求地址：/apporderin/shoppingcart?SHOPPINGCART(混淆码)
#define kUrlShoppingCart [NSString stringWithFormat:@"/apporderin/shoppingcart?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHOPPINGCART"]]
//16.添加商品到购物车
//参数: PRODUCT_ID 添加商品id/HONOURUSER_ID 当前用户id
//请求地址：/apporderin/shoppingcartadd?SHIPCARTADD(混淆码)
#define kUrlShoppingCartAdd [NSString stringWithFormat:@"/apporderin/shoppingcartadd?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPCARTADD"]]
//17.从购物车删除商品
//参数：PRODUCT_ID 删除商品id/HONOURUSER_ID 当前用户id
//请求地址：/apporderin/shoppingcartdel?SHIPCARTDEL(混淆码)
#define kUrlShoppingCartDel [NSString stringWithFormat:@"/apporderin/shoppingcartdel?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPCARTDEL"]]
//18.生成订单接口（未产生交易）状态为待付款（购物车结算）
//参数：ORDERADDRESS 订单地址/ORDERMONEY 订单总金额/ORDERDELIVERY 配送方式（顺丰...）/HONOURUSER_ID         用户id/PRODUCT_ID 生成订单的商品id/PRODUCTCOUNT 商品数量
//请求地址：/apporderin/shiporder?SHIPORDER(混淆码)
#define kUrlShipOrder [NSString stringWithFormat:@"/apporderin/shiporder?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPORDER"]]
//19.订单状态修改（修改为待收货，待评价，已完成）
//参数：ORDERNUMBER 订单编号/HONOURUSER_ID 用户id/ORDERSTATUS 订单状态编码
//（0040001）为待付款状态
//(0040002) 为待收货状态
//(0040003) 为待评价状态
//(0040004) 为已完成订单状态
//请求地址：/apporderin/shiporderstaupd?SHIPORDERUPD(混淆码)
#define kUrlShipOrderStauPb [NSString stringWithFormat:@"/apporderin/shiporderstaupd?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPORDERUPD"]]
//20.尊购里模糊查询
//参数：KEYWORDS 关键字
//请求地址：/appshipin/shipdimquery?SHIPDIMQ(混淆码)
#define kUrlShipDimQuery [NSString stringWithFormat:@"/appshipin/shipdimquery?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPDIMQ"]]
//21.炫购收藏列表
//参数：HONOURUSER_ID 用户id
//请求地址：/appshipin/shipcollect?SHIPCOL(混淆码)
#define kUrlShipCollect [NSString stringWithFormat:@"/appshipin/shipcollect?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPCOL"]]
//22.添加商品到炫购收藏
//参数：HONOURUSER_ID 用户id/PRODUCT_ID 商品id
//请求地址：/appshipin/shipcollectadd?SHIPCOLADD(混淆码)
#define kUrlShipCollectAdd [NSString stringWithFormat:@"/appshipin/shipcollectadd?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPCOLADD"]]
//23.从炫购收藏删除商品
//参数：COLLECT_ID 炫购收藏id
//请求地址：/appshipin/shipcollectdel?SHIPCOLDEL(混淆码)
#define kUrlShipCollectDel [NSString stringWithFormat:@"/appshipin/shipcollectdel?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPCOLDEL"]]
//24.获得首页中美食分类列表（完成）
//参数：无参数
//请求地址：/appsfoodin/sfood?SORTFOOD(混淆码)
#define kUrlSFood [NSString stringWithFormat:@"/appsfoodin/sfood?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTFOOD"]]


//25.美食店铺添加评价
//参数：SORTFOOD_ID 店铺id/HONOURUSER_ID 评价用户id/EVALUATECONTENT 评价内容/EVALUATECOINT 评价分数
//请求地址：/appsfoodin/sfoodaddeva?SFOODADDEVA（混淆码）
#define kUrlSFoodAddEva [NSString stringWithFormat:@"/appsfoodin/sfoodaddeva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SFOODADDEVA"]]
//26.美食店铺综合评价分数
//参数：SORTFOOD_ID 需要查询的店铺id
//请求地址：/appsfoodin/sfoodmeaneva?SFOODMEANEVA(混淆码)
#define kUrlSFoodMeanEva [NSString stringWithFormat:@"/appsfoodin/sfoodmeaneva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SFOODMEANEVA"]]
//27.获得某家店铺评价数量
//参数：SORTFOOD_ID 需要查询的店铺id
//请求地址：/appsfoodin/sfoodcounteva?SFOODCOUNTEVA(混淆码)
#define kUrlSFoodCountEva [NSString stringWithFormat:@"/appsfoodin/sfoodcounteva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SFOODCOUNTEVA"]]
//28.获得某家店铺具体服务接口
//参数：SORTFOOD_ID 需要查询的店铺id
//请求地址：/appsfoodin/sfoodserv?SFOODSERV(混淆码)
#define kUrlSFoodServ [NSString stringWithFormat:@"/appsfoodin/sfoodserv?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SFOODSERV"]]
//29.获得所有私人定制列表接口
//参数：无参数
//请求地址：/apppersonalin/personallist?PERSONAL(混淆码)
#define kUrlPersonalList [NSString stringWithFormat:@"/apppersonalin/personallist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PERSONAL"]]
//30.获取私人订制详情接口
//参数：PERSONAL_ID 私人定制id
//请求地址：/apppersonalin/personaldet?PERSONALDET(混淆码)
#define kUrlPersonalDet [NSString stringWithFormat:@"/apppersonalin/personaldet?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PERSONALDET"]]
//31.根据条件获取火车票列表接口
//参数：from 始发站/to 终点站/date 出发日期/tt 是否为高铁动车（不打勾不需要传递，打勾需要传递’D’）
//请求地址：/apppersonalin/trainselect?TRAINSELECT(混淆码)
#define kUrlTrainSelect [NSString stringWithFormat:@"/apppersonalin/trainselect?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"TRAINSELECT"]]
//32.首页中获取所有特权接口
//参数：无参数
//请求地址：/apphomein/privilegelist?PRIVILIST(混淆码)
#define kUrlTrainSelect [NSString stringWithFormat:@"/apppersonalin/trainselect?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"TRAINSELECT"]]
//33.首页中对应特权详情（仅马术，游艇，飞机，高尔夫，豪车）
//参数：PRIVILEGE_ID 特权id
//请求地址：/apphomein/privilegedet?PRIVIDET(混淆码)
#define kUrlPrivilegeDet [NSString stringWithFormat:@"/apphomein/privilegedet?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PRIVIDET"]]
//34.首页中新闻标题列表
//参数：暂无
//请求地址：/apphomein/getnewslist?NEWSLIST(混淆码)
#define kUrlGetNewsList [NSString stringWithFormat:@"/apphomein/getnewslist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"NEWSLIST"]]
//35.获取新闻详情
//参数：NEWS_ID 新闻id
//请求地址：/apphomein/getnewsdet?NEWSDET(混淆码)
#define kUrlGetNewsDet [NSString stringWithFormat:@"/apphomein/getnewsdet?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"NEWSDET"]]
//36.获取新闻所有评论
//参数：NEWS_ID 新闻id
//请求地址：/apphomein/getnewseva?NEWSEVA(混淆码)
#define kUrlGetNewsEva [NSString stringWithFormat:@"/apphomein/getnewseva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"NEWSEVA"]]
//37.添加新闻评论
//参数：NEWS_ID 评价新闻id/HONOURUSER_ID 评价用户id /NEWSEVACONTENT 评论内容
//请求地址：/apphomein/getnewsevaadd?NEWSEVAADD(混淆码)
#define kUrlGetNewsEvaAdd [NSString stringWithFormat:@"/apphomein/getnewsevaadd?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"NEWSEVAADD"]]
//38.获取汇聚列表接口
//参数：无参数
//请求地址：/appconvergein/convergelist?CONVERGELIST(混淆码)
#define kUrlConvergeList [NSString stringWithFormat:@"/appconvergein/convergelist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CONVERGELIST"]]
//39.获得指定汇聚下所有聚会列表
//参数：CONVERGE_ID 汇聚列表下汇聚id
//请求地址：/appconvergein/getpartylist?PARTYLIST(混淆码)
#define kUrlGetPartyList [NSString stringWithFormat:@"/appconvergein/getpartylist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PARTYLIST"]]
//40.查看指定聚会详情
//参数：CONVERGEDETAIL_ID 指定聚会id
//请求地址：/appconvergein/getdetailbyid?DETAILID(混淆码)
#define kUrlGetDetaiByID [NSString stringWithFormat:@"/appconvergein/getdetailbyid?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"DETAILID"]]
//41.发布聚会
//参数：STARTTIME 聚会开始时间/ENDTIME 聚会结束时间/PRICEMIN 期望价格最低值/PRICEMAX 期望价格最高值/
//CONVERGEPER 人数要求/CONVERGESEX 性别要求（0为女1为男2为不限）/AGEMIN 年龄要求下限/
//AGEMAX 年龄要求上限/CONVERGETYPE 聚会方式/CONVERGEDET 聚会详细要求/
//CONVERGETITLE 聚会标题/HONOURUSER_ID 发起人id
//请求地址：/appconvergein/adddetailparty?DETAILADD(混淆码)
#define kUrlAddDetailParty [NSString stringWithFormat:@"/appconvergein/adddetailparty?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"DETAILADD"]]
//42. 获得首页特权酒店分类列表 (完成)
//参数：SORTHOTEL_ID 酒店id
//请求地址：/appshotelin/shotel.do?SORTHOTEL（混淆码）
#define kUrlSHotelDo [NSString stringWithFormat:@"/appshotelin/shotel.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTHOTEL"]]
//43. 获得某家酒店的综合评价
//参数：SORTHOTEL_ID 酒店id
//请求地址：/appshotelin/shotelmeaneva?SHOTELMEANEVA（混淆码）
#define kUrlSHotelMeanEva [NSString stringWithFormat:@"/appshotelin/shotelmeaneva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHOTELMEANEVA"]]
//44. 获得某家店铺的评价数量
//参数：SORTHOTEL_ID酒店id
//请求地址：/appshotelin/shotelcounteva?SHOTELCOUNTEVA(混淆码)
#define kUrlSHotelCountEva [NSString stringWithFormat:@"/appshotelin/shotelcounteva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHOTELCOUNTEVA"]]
//45. 获得某家酒店的具体服务接口
//参数：SHOP_ID 对应店铺id
//请求地址：/appshotelin/shotelserv?SHOTELSERV(混淆码)
#define kUrlSHotelServ [NSString stringWithFormat:@"/appshotelin/shotelserv?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHOTELSERV"]]
//46. 酒店店铺添加用户评价接口
//参数：SORTHOTEL_ID 所属店铺id/HONOURUSER_ID 评价用户id/EVALUATECONTENT 评价内容/EVALUATECOINT 评价分数
//请求地址：/appshotelin/shoteladdeva?SHOTELADDEVA(混淆码)
#define kUrlSHotelAddEva [NSString stringWithFormat:@"/appshotelin/shoteladdeva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHOTELADDEVA"]]
//47. 生成酒店订单接口（未产生交易）
//参数：ORDERUNAME 入住人姓名/ORDERPHONE 入住人手机号码/ORDERREMARK 订单备注/ORDERMONEY 订单价格/ORDERROOMNUM 预定酒店房间数量/ORDERCHECKDATE 入住日期/ORDERLEAVEDATE 离开日期
///ORDERDAYS 入住天数 /HOTELDETAIL_ID 预定房间类型id/HONOURUSER_ID 提交订单用户id
//请求地址：/appshotelin/shiphotelorder?SHIPHOTELORDER(混淆码)
#define kUrlShipHotlOrder [NSString stringWithFormat:@"/appshotelin/shiphotelorder?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPHOTELORDER"]]
//48. 修改酒店订单状态(改为支付成功,用户已支付)
//参数：ORDERSTATUS 订单状态编码/HONOURUSER_ID 提交订单的用户id /ORDERNUMBER 订单编号
//请求地址：/appshotelin/shiporderstaupd?SHIPHORELORDERUPD(混淆码)
#define kUrlShipOrderStauPd [NSString stringWithFormat:@"/appshotelin/shiporderstaupd?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPHORELORDERUPD"]]
//49. 获得用户名下所有酒店订单列表
//参数：HONOURUSER_ID 需要查询的用户id
//请求地址：/apphotelorderin/hotelorderalllist?ALLHOTELORDER(混淆码)
#define kUrlHotelOrderAllList [NSString stringWithFormat:@"/apphotelorderin/hotelorderalllist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ALLHOTELORDER"]]
//50. 获取某酒店详情列表
//参数：SORTHOTEL_ID 某酒店id
//请求地址：/appshotelin/hoteldetaillist?HOTELDETAIL(混淆码)
#define kUrlHotelDetailList [NSString stringWithFormat:@"/appshotelin/hoteldetaillist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"HOTELDETAIL"]]
//51. 获得某家KTV的综合评价
//参数：SORTKTV_ID   KTV的id
//请求地址：/appsktvin/sktvmeaneva?SKTVMEANEVA（混淆码）
#define kUrlSKtvMeanEva [NSString stringWithFormat:@"/appsktvin/sktvmeaneva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SKTVMEANEVA"]]
//52. 获得某家KTV的评价数量
//参数：SORTKTV_ID   KTV的id
//请求地址：/appsktvin/sktvcounteva?SKTVCOUNTEVA(混淆码)
#define kUrlSKtvMeanEva [NSString stringWithFormat:@"/appsktvin/sktvmeaneva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SKTVMEANEVA"]]
//53. 获得某家KTV的具体服务接口
//参数：SHOP_ID 对应KTV的id
//请求地址：/appsktvin/sktvserv?SKTVSERV(混淆码)
#define kUrlSKtvServ [NSString stringWithFormat:@"/appsktvin/sktvserv?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SKTVSERV"]]
//54. KTV店铺添加用户评价接口
//参数：SORTKTV_ID 所属KTV的id/HONOURUSER_ID 评价用户id/EVALUATECONTENT 评价内容/EVALUATECOINT 评价分数
//请求地址：/appsktvin/sktvaddeva?SKTVADDEVA(混淆码)
#define kUrlSKtvAddEva [NSString stringWithFormat:@"/appsktvin/sktvaddeva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SKTVADDEVA"]]
//55. 生成KTV订单接口（未产生交易）
//参数：ORDERUNAME 入住人姓名/ORDERPHONE 入住人手机号码/ORDERREMARK 订单备注/ORDERMONEY 订单价格/ORDERROOMNUM 预定KTV房间数量/ORDERROOMBEGIN 包厢开始时间/ORDERROOMEND 包厢结束时间
///KTVDETAIL_ID 所关联的KTV包厢id/HONOURUSER_ID 提交订单用户id
//请求地址：/appsktvin/shipktvorder?SHIPKTVORDER(混淆码)
#define kUrlShipKtvOrder [NSString stringWithFormat:@"/appsktvin/shipktvorder?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPKTVORDER"]]
//56. 修改KTV订单状态(改为支付成功,用户已支付)
//参数：ORDERSTATUS 订单状态编码/HONOURUSER_ID 提交订单的用户id /ORDERNUMBER 订单编号
//请求地址：/appsktvin/shipktvstaupd?SHIPKTVORDERUPD(混淆码)
#define kUrlShipKtvStauPd [NSString stringWithFormat:@"/appsktvin/shipktvstaupd?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPKTVORDERUPD"]]
//57 获得用户名下所有KTV订单列表
//参数：HONOURUSER_ID 需要查询的用户id
//请求地址：/appsktvin/ktvorderalllist?ALLKTVORDER(混淆码)
#define kUrlKtvOrderAllList [NSString stringWithFormat:@"/appsktvin/ktvorderalllist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ALLKTVORDER"]]
//58. 获取某KTV详情列表
//参数：SORTKTV_ID 某KTVid
//请求地址：/appsktvin/ktvdetaillist?KTVDETAIL(混淆码)
#define kUrlKtvDetailList [NSString stringWithFormat:@"/appsktvin/ktvdetaillist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"KTVDETAIL"]]
//59. 根据状态获取轮播图
//参数：无
//请求地址：/appshipin/scarouselfigure?SCAROUSELFIGURE(混淆码)
#define kUrlScarouselfigure [NSString stringWithFormat:@"/appshipin/scarouselfigure?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SCAROUSELFIGURE"]]
//60.根据酒店id获取酒店综合详细（完成）
//参数：SORTHOTEL_ID 某酒店id
//请求地址：/appshotelin/hotelsyn?HOTELSYN（混淆码）
#define kUrlHotelSyn [NSString stringWithFormat:@"/appshotelin/hotelsyn?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"HOTELSYN"]]
//61.根据美食店铺id获取美食店铺综合详细（完成）
//参数：SORTFOOD_ID 某美食店铺id
//请求地址：/appsfoodin/foodsyn?SFOODSYN（混淆码）
#define kUrlFoodSyn [NSString stringWithFormat:@"/appsfoodin/foodsyn?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SFOODSYN"]]
//62.根据KTVid获取KTV店铺综合详细（完成）
//参数：SORTKTV_ID 某KTVid
//请求地址：/appsktvin/ktvsyn?KTVSYN（混淆码）
#define kUrlKtvSyn [NSString stringWithFormat:@"/appsktvin/ktvsyn?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"KTVSYN"]]
//63. 获得引导页列表
//参数：无
//请求地址：/appshipin/bootpagelist?BOOTPAGELIST(混淆码)
#define kUrlBootPageList [NSString stringWithFormat:@"/appshipin/bootpagelist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"BOOTPAGELIST"]]
//64. 获得首页荣耀服务列表
//参数：SERVER_ID 某荣耀服务id
//请求地址：/appserverin/server.do?SERVER(混淆码)
#define kUrlServerDo [NSString stringWithFormat:@"/appserverin/server.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SERVER"]]
//65. 获取荣耀服务详情列表
//参数：无
//请求地址：/appserverin/serverdetaillist.do?SERVERDETAIL(混淆码)
#define kUrlServerDetailList [NSString stringWithFormat:@"/appserverin/serverdetaillist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SERVERDETAIL"]]
//66.获得某酒店评论列表 （完成）
//参数：SORTHOTEL_ID 某酒店id
//请求地址：/appshotelin/hotelevalist?HOTELEVA
//返回参数：EVALUATEDATE 	评价日期/EVALUATECONTENT 评价内容/PORTRAIT 用户头像/NICKNAME 用户昵称
#define kUrlHotelEvaList [NSString stringWithFormat:@"/appshotelin/hotelevalist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"HOTELEVA"]]
//67.获得某美食店铺评论列表(完成)
//参数：SORTFOOD_ID 某美食店铺id
//请求地址：/appsfoodin/foodevalist?FOODEVA
//返回参数：EVALUATEDATE 	评价日期/EVALUATECONTENT 评价内容/PORTRAIT 用户头像/NICKNAME 用户昵称
#define kUrlFoodEvaList [NSString stringWithFormat:@"/appsfoodin/foodevalist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"FOODEVA"]]
//67.获得KTV店铺评论列表（完成）
//参数：SORTKTV_ID 某KTVid
//请求地址：/appsktvin/ktvevalist?KTVEVA
//返回参数：EVALUATEDATE 	评价日期/EVALUATECONTENT 评价内容/PORTRAIT 用户头像/NICKNAME 用户昵称
#define kUrlKtvEvaList [NSString stringWithFormat:@"/appsktvin/ktvevalist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"KTVEVA"]]
//68.用户上传头像的方法
//参数：HONOURUSER_ID 上传头像人员id
//请求地址：/appuserin/up?UPPORT
#define kUrlUp [NSString stringWithFormat:@"/appuserin/up?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"UPPORT"]]


//63. 获得引导页列表（完成）
//参数：无
//请求地址：/appbootpagein/bootpagelist?BOOTPAGELIST(混淆码)
#define kUrlBootpagelist [NSString stringWithFormat:@"/appbootpagein/bootpagelist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"BOOTPAGELIST"]]

//64. 获得首页荣耀服务列表（完成）
//参数：无
//请求地址：/appserverin/server.do?SERVER(混淆码)
#define kUrlServerDo [NSString stringWithFormat:@"/appserverin/server.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SERVER"]]

//65. 获取荣耀服务详情列表

//参数：SERVER_ID 某荣耀服务id
//请求地址：/appserverin/serverdetaillist.do?SERVERDETAIL(混淆码)
#define kUrlServerdetaillistDo [NSString stringWithFormat:@"/appserverin/serverdetaillist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SERVERDETAIL"]]

//66.获得某酒店评论列表(完成)
//参数：SORTHOTEL_ID 某酒店id
//请求地址：/appshotelin/hotelevalist?HOTELEVA
//返回参数：EVALUATEDATE     评价日期/EVALUATECONTENT 评价内容/PORTRAIT 用户头像/NICKNAME 用户昵称
#define kUrlHotelevalist [NSString stringWithFormat:@"/appshotelin/hotelevalist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"HOTELEVA"]]

//92. 获得首页特权KTV分类列表（完成）
//参数：HONOURUSER_ID 用户id
//请求地址：/appsktvin/sktv.do?SORTKTV(混淆码)
#define kUrlSktvlist [NSString stringWithFormat:@"/appsktvin/sktv.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTKTV"]]

#endif /* URLMacros_h */
