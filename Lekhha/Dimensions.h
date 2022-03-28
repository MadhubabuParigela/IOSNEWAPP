//
//  Dimensions.h
//
//  Created by Mallesh on 10/07/18.
//

#ifndef Dimensions_h
#define Dimensions_h

#define TRIM(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

#define Max_Width [[UIScreen mainScreen] bounds].size.width
#define Max_Height [[UIScreen mainScreen] bounds].size.height
#define APDim_X [[UIScreen mainScreen] bounds].size.width/320
#define APDim_Y [[UIScreen mainScreen] bounds].size.height/568
#define ALDim_X [[UIScreen mainScreen] bounds].size.width/568
#define ALDim_Y [[UIScreen mainScreen] bounds].size.height/320
#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isiPhone5  (([[UIScreen mainScreen] bounds].size.width == 320)||([[UIScreen mainScreen] bounds].size.width == 568))?1:0
#define isiPhone6  (([[UIScreen mainScreen] bounds].size.width == 375)||([[UIScreen mainScreen] bounds].size.width == 667))?1:0
#define isiPhone6s  (([[UIScreen mainScreen] bounds].size.width == 414) ||([[UIScreen mainScreen] bounds].size.width == 736))?1:0
#define isiPhoneX (([[UIScreen mainScreen] bounds].size.width == 375) && ([[UIScreen mainScreen] bounds].size.height == 812))?1:0
#define isProtarit (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)?1:0
#define isLandScape (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)?1:0
#define landsacpeMode UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)

#define FONT_DIP_30 ([[UIScreen mainScreen] bounds].size.width == 320)?30:(([[UIScreen mainScreen] bounds].size.width == 375)?31:(([[UIScreen mainScreen] bounds].size.width == 414)?32:35))
#define FONT_DIP_25 ([[UIScreen mainScreen] bounds].size.width == 320)?25:(([[UIScreen mainScreen] bounds].size.width == 375)?26:(([[UIScreen mainScreen] bounds].size.width == 414)?27:30))
#define FONT_DIP_20 ([[UIScreen mainScreen] bounds].size.width == 320)?20:(([[UIScreen mainScreen] bounds].size.width == 375)?21:(([[UIScreen mainScreen] bounds].size.width == 414)?22:28))
#define FONT_DIP_19 ([[UIScreen mainScreen] bounds].size.width == 320)?19:(([[UIScreen mainScreen] bounds].size.width == 375)?20:(([[UIScreen mainScreen] bounds].size.width == 414)?21:27))
#define FONT_DIP_18 ([[UIScreen mainScreen] bounds].size.width == 320)?18:(([[UIScreen mainScreen] bounds].size.width == 375)?19:(([[UIScreen mainScreen] bounds].size.width == 414)?20:26))
#define FONT_DIP_17 ([[UIScreen mainScreen] bounds].size.width == 320)?17:(([[UIScreen mainScreen] bounds].size.width == 375)?18:(([[UIScreen mainScreen] bounds].size.width == 414)?19:25))
#define FONT_DIP_16 ([[UIScreen mainScreen] bounds].size.width == 320)?16:(([[UIScreen mainScreen] bounds].size.width == 375)?17:(([[UIScreen mainScreen] bounds].size.width == 414)?18:26))
#define FONT_DIP_15 ([[UIScreen mainScreen] bounds].size.width == 320)?15:(([[UIScreen mainScreen] bounds].size.width == 375)?16:(([[UIScreen mainScreen] bounds].size.width == 414)?17:23))
#define FONT_DIP_13 ([[UIScreen mainScreen] bounds].size.width == 320)?13:(([[UIScreen mainScreen] bounds].size.width == 375)?14:(([[UIScreen mainScreen] bounds].size.width == 414)?15:21))
#define FONT_DIP_12 ([[UIScreen mainScreen] bounds].size.width == 320)?12:(([[UIScreen mainScreen] bounds].size.width == 375)?13:(([[UIScreen mainScreen] bounds].size.width == 414)?15:20))
#define FONT_DIP_11 ([[UIScreen mainScreen] bounds].size.width == 320)?11:(([[UIScreen mainScreen] bounds].size.width == 375)?12:(([[UIScreen mainScreen] bounds].size.width == 414)?13:19))
#define FONT_DIP_10 ([[UIScreen mainScreen] bounds].size.width == 320)?10:(([[UIScreen mainScreen] bounds].size.width == 375)?11:(([[UIScreen mainScreen] bounds].size.width == 414)?12:18))
#define FONT_DIP_9 ([[UIScreen mainScreen] bounds].size.width == 320)?9:(([[UIScreen mainScreen] bounds].size.width == 375)?10:(([[UIScreen mainScreen] bounds].size.width == 414)?11:17))

/*system versions*/
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
/*structures*/

#import <UIKit/UIKit.h>

//dummy...

CG_INLINE CGRect CTRectMake(CGFloat x,
                            CGFloat y,
                            CGFloat width,
                            CGFloat height)
{
    CGRect rect;
    rect.origin.x    =  ([[UIScreen mainScreen] bounds].size.width/320)*x;
    rect.origin.y    = ([[UIScreen mainScreen] bounds].size.height/568)*y;
    rect.size.width  = ([[UIScreen mainScreen] bounds].size.width/320)*width;
    rect.size.height = ([[UIScreen mainScreen] bounds].size.height/568)*height;
    return rect;
}

CG_INLINE CGSize CTRect(CGFloat width, CGFloat height)
//CTSizeMake(CGFloat width, CGFloat height)
{
    CGSize size; size.width = width; size.height = height; return size;
}


#endif /* Dimensions_h */
