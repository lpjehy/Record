//
//  Record.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "Extension.h"
#import "UrlUtil.h"
#import "AppManager.h"

#import "Notifications.h"

#import "Colors.h"
#import "Fonts.h"


///接口版本号
#define KeyWindow  [[UIApplication sharedApplication] keyWindow]



#define DeviceSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)



#define ISPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define InterfaceOrientationLandscape ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define GoldenHeight [UIScreen mainScreen].bounds.size.width * 0.618
#define GoldenSectionPoint 0.618







#ifdef DEBUG
#define MSLog(fmt,...) NSLog((@"[行号:%d]" "[函数名:%s]\n" fmt),__LINE__,__FUNCTION__,##__VA_ARGS__);
#else
#define MSLog(fmt,...);
#endif

#define WS(wSelf)          __weak typeof(self) wSelf = self
#define SS(sSelf)          __strong typeof(wSelf) sSelf = wSelf





#define TimeIntervalHour     (60 * 60)
#define TimeIntervalDay      (60 * 60 * 24)
#define TimeIntervalMonth    (60 * 60 * 24 * 30)
#define TimeIntervalYear     (60 * 60 * 24 * 30 * 12)




