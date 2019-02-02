//
//  NetworkServicObject.h
//  ItsTomato
//
//  Created by Tvisha Technologies on 1/13/17.
//  Copyright © 2017 Tvisha Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define noInternet @"No Internet"
#define TimeUp @"Time out"
#define Diconnect @"Connection Disconnected"
#define NoSuccess @"false"
#define NetworkSuccess @"true"

typedef void (^NetworkCompletioHandlerAction) (NSDictionary  * _Nullable json, NSString * _Nullable outCome);
@interface NetworkServicObject : NSObject

-(void)NetworkCallingOnUrl:(NSString *_Nullable)_URL withKeys:(NSArray *_Nullable)_keys andWithValues:(NSArray *_Nullable)_val OperatingWithin:(UIViewController *_Nullable)_Controller;
-(void)NetworkCallingOnUrlImageUploading:(NSString *)_URL withKeys:(NSArray *)_keys andWithValues:(NSArray *)_val ImgData:(NSData *)_data OperatingWithin:(UIViewController *)_Controller;
-(void)NetworkCallingOnUrlEncoded:(NSString *)_URL withKeys:(NSArray *)_keys andWithValues:(NSArray *)_val OperatingWithin:(UIViewController *)_Controller;
-(void)RawDataAddressNetworkCallingOnUrl:(NSString *)_URL withString:(NSString *)_Data WithType:(NSString *)_type OperatingWithin:(UIViewController *)_Controller;
-(void)GETNetworkCallingOnUrl:(NSString *)_URL withKeysHeader:(NSArray *)_keys andWithValuesHeader:(NSArray *)_val OperatingWithin:(UIViewController *)_Controller;
-(void)StopTask;
-(void)NetworkServiceCompleted:(nullable NetworkCompletioHandlerAction)completionHandler;
@end


