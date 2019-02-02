//
//  BasicComponents.m
//  VENetworkingBasicClasses
//
//  Created by vinod k on 29/01/19.
//  Copyright © 2019 tvisha. All rights reserved.
//

#import "BasicComponents.h"

@implementation BasicComponents

#pragma mark : To assing Hexa color
+(UIColor*)colorWithHexString:(NSString*)hex {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return [UIColor grayColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark : Get tost alert
+(void)AlertViewNotification:(NSString *)_MSG superView:(UIViewController *)presentView {
    UIAlertController * alertViewController =   [UIAlertController
                                                 alertControllerWithTitle:@""
                                                 message:_MSG
                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* alert = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                            }];
    [alertViewController addAction:alert];
    dispatch_async(dispatch_get_main_queue(), ^{
        [presentView presentViewController:alertViewController animated:YES completion:nil];
    });
}

#pragma mark : Find width of a string
+(CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    @try{
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
    } @catch(NSException *exception){
        return 0.0;
    }
}

#pragma mark : Find height of a string
+(CGFloat)getStringHeight:(CGSize)labelSize string:(NSString *)string font:(UIFont *)font {
    
    CGSize size;
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [string boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font} context:context].size;
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
    
}

#pragma mark : Date Formate Converstions
+(NSString *)convertDateWithDateFormat:(NSString *)dateString currentDateFormat:(NSString *)_currentDF requiredDateFormat:(NSString *)_requiredTF isUTC:(BOOL)_isUTC {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:_currentDF];
    if (_isUTC) {
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    NSDate *date = [dateFormatter dateFromString:dateString]; // create date from string
    
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:_requiredTF];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *timestamp = [dateFormatter stringFromDate:date];
    
    return timestamp;
}

#pragma mark : Is Internet COnnected
+(BOOL)isInternetConnected {
    
    Reachability *reachable = [Reachability reachabilityWithHostName:@"www.google.com"];
    ; NetworkStatus internetStatus = [reachable currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
        /// Create an alert if connection doesn't work
        NSLog(@"INTERNET IS NOT CONNECTED");
        return NO;
    } else{
        NSLog(@"INTERNET IS CONNECTED");
        return YES;
    }
}

#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT
@end
