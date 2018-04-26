//
//  ThirdMacros.h
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

//第三方配置

#ifndef ThirdMacros_h
#define ThirdMacros_h

// 友盟统计
#define UMengKey @"5ab89ce78f4a9d5fa8000100"

//微信
#define kAppKey_Wechat          @"wxe717a91321162694"
#define kSecret_Wechat          @"d9186ceef0608871cf7e085811c37d28"

// 腾讯
#define kAppKey_Tencent         @"1106139910"


//网易云信
#define kIMAppKey @"afc7265de3857bbaa7404b4ea92b191e"
#define kIMAppSecret @"c34bd403b29a"
#define kIMPushCerName @""

//即构科技
#define kAppId_Zego          421941598
#define kAppKey_Zego         0x71,0x96,0xa9,0x38,0xbb,0x3a,0xd5,0x6c,0xe5,0x61,0xe7,0x58,0x79,0xf4,0xfa,0x53,0x88,0xb4,0xcf,0x67,0xcf,0xd1,0x21,0x7a,0x5a,0x4d,0xc1,0xc3,0xdf,0xc1,0x8f,0x9d

//蒲公英
#define kPGYApiKey @"925b799ec8ce5d19910288cdde27bfdc"
#define kPGYAppKey @"ba5cdab1acf602dd6b5ffc206905d0a8"


//阿里云直播
#define PLAY_AUTH @""
#define VID @""
#define ACCESS_KEY_ID @""
#define ACCESS_KEY_SECRET @""
#define SECURITY_TOKEN @""

#define KZSHColorRGB(R,G,B)     [UIColor colorWithRed:(R * 1.0) / 255.0 green:(G * 1.0) / 255.0 blue:(B * 1.0) / 255.0 alpha:1.0]
#define KZSHColorRGBA(R,G,B,A)  [UIColor colorWithRed:(R * 1.0) / 255.0 green:(G * 1.0) / 255.0 blue:(B * 1.0) / 255.0 alpha:A]
#define AlivcTextPushURL @"rtmp://video-center.alivecdn.com/ZSHApp/stream00?vhost=live.rongyaohk.com&auth_key=1516417147-0-0-7b5549b1f901c18f84a0bef816cb5a75"
#define AlivcUserDefaultsIndentifierFirst @"AlivcUserDefaultsIndentifierFirst"

#define AlivcPullURL  @"http://cloud.video.taobao.com/play/u/2712925557/p/1/e/6/t/1/40050769.mp4"// @"rtmp://live.rongyaohk.com/ZSHApp/game1000001332958882?auth_key=1516442532-0-0-c94169850efaa7f15a2c565bec67d671"

//h5链接
#define   ZSHGoodsDetailH5          @"http://inters.rongyaohk.com/home/introduction.html"
#define   ZSHLeftShopCartH5         @"http://inters.rongyaohk.com/home/shopcart.html"
#define   ZSHMineAddressListH5      @"http://inters.rongyaohk.com/home/address.html"
#define   ZSHYachtDetailH5          @"http://inters.rongyaohk.com/home/bannerdetail.html"

//#define   ZSHGoodsDetailH5          @"http://192.168.1.121:8080/two/home/introduction.html"
//#define   ZSHLeftShopCartH5         @"http://192.168.1.121:8080/two/home/shopcart.html"
//#define   ZSHMineAddressListH5      @"http://192.168.1.121:8080/two/home/address.html"
//#define   ZSHYachtDetailH5          @"http://192.168.1.121:8080/two/home/bannerdetail.html"

#endif /* ThirdMacros_h */
