//
//  Record.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//



///接口版本号
#define KeyWindow  [[UIApplication sharedApplication] keyWindow]



#define DeviceSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)



#define ISPad 0//(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define InterfaceOrientationLandscape ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)










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


//#define LocalizedString(key)  NSLocalizedString(key, nil)

//#define LocalizedString(key)  [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


#define LocalizedString(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"AppLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"]

