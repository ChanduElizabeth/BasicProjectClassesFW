//
//  BasicComponents.h
//  VENetworkingBasicClasses
//
//  Created by vinod k on 29/01/19.
//  Copyright © 2019 tvisha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "Dimensions.h"
NS_ASSUME_NONNULL_BEGIN

@interface BasicComponents : NSObject

+(UIColor*)colorWithHexString:(NSString*)hex;
+(CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font;
+(CGFloat)getStringHeight:(CGSize)labelSize string: (NSString *)string font: (UIFont *)font;
+(NSString *)convertDateWithDateFormat:(NSString *)dateString currentDateFormat:(NSString *)_currentDF requiredDateFormat:(NSString *)_requiredTF isUTC:(BOOL)_isUTC;
+(BOOL)isInternetConnected;

@end

NS_ASSUME_NONNULL_END
