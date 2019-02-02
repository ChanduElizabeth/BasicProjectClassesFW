//
//  NetworkServicObject.m
//  ItsTomato
//
//  Created by Tvisha Technologies on 1/13/17.
//  Copyright © 2017 Tvisha Technologies. All rights reserved.
//

#import "NetworkServicObject.h"


@interface NetworkServicObject (){
    NSURLSessionDataTask *loginDataTask1;
}
@property (nonatomic) UIViewController *presentController;
@property (nonatomic, strong)NetworkCompletioHandlerAction NetworkServiceBlock;
@end

@implementation NetworkServicObject

-(void)NetworkCallingOnUrl:(NSString *)_URL withKeys:(NSArray *)_keys andWithValues:(NSArray *)_val OperatingWithin:(UIViewController *)_Controller {
    
    self.presentController = _Controller;
    
    if (_keys.count != _val.count) {
        self.NetworkServiceBlock(@{@"message" : @"Keys and values count are not same"},Diconnect);
        return;
    }
    
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if([[cookie domain] isEqualToString:_URL]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:
                                   [NSURL URLWithString:_URL]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", [[[UIDevice currentDevice] identifierForVendor]UUIDString]];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", [[[UIDevice currentDevice] identifierForVendor]UUIDString]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (int i=0; i<_keys.count; i++) {
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",[_keys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[_val objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", [[[UIDevice currentDevice] identifierForVendor]UUIDString]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [request setHTTPBody:body];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setURL:[NSURL URLWithString:_URL]];
    NSURLSession *session = [NSURLSession sharedSession];
    [NSThread sleepForTimeInterval:.2];
    // post the request and handle response
    NSURLSessionDataTask *loginDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if ([error code] == -1005) { //network connection failure
            self.NetworkServiceBlock(@{@"message": @"Something went wrong try again"},Diconnect);
            return;
        } else if ([error code] == -999) { // @"Please Try   again"
            self.NetworkServiceBlock(@{@"message": @"Something went wrong try again"},Diconnect);
            return;
        } else if ([error code] == -1004) { //@"connection timed out"
            self.NetworkServiceBlock(@{@"message": @"Request Timeout try again"},TimeUp);
            return;
        } else if ([error code] == -1009) { //@"internet connection not avilable"
            self.NetworkServiceBlock(@{@"message": @"Please check your network"},noInternet);
            return;
        } else if ([error code] == -1001) { //@"connection timed out"
            self.NetworkServiceBlock(@{@"message": @"Something went wrong try again"},TimeUp);
            return;
        }else {
            if (data != nil) {
                [self recivingJSONData:data withError:error];
            }
        }
    }];
    [loginDataTask resume];
}

-(void)NetworkCallingOnUrlImageUploading:(NSString *)_URL withKeys:(NSArray *)_keys andWithValues:(NSArray *)_val ImgData:(NSData *)_data OperatingWithin:(UIViewController *)_Controller {
    self.presentController = _Controller;
    
    if (_keys.count != _val.count) {
        self.NetworkServiceBlock(@{@"message" : @"Keys and values count are not same"},Diconnect);
        return;
    }
    
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if([[cookie domain] isEqualToString:_URL]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:
                                   [NSURL URLWithString:_URL]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", [[[UIDevice currentDevice] identifierForVendor]UUIDString]];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", [[[UIDevice currentDevice] identifierForVendor]UUIDString]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (int i=0; i<_keys.count-1; i++) {
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",[_keys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[_val objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", [[[UIDevice currentDevice] identifierForVendor]UUIDString]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", [_keys objectAtIndex:_keys.count-1],[_val objectAtIndex:_val.count-1]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:_data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", [[[UIDevice currentDevice] identifierForVendor]UUIDString]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
   
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setURL:[NSURL URLWithString:_URL]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [NSThread sleepForTimeInterval:.2];
    // post the request and handle response
    NSURLSessionDataTask *loginDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([error code] == -1005) { //network connection failure
            self.NetworkServiceBlock(@{@"Data": @"no"},Diconnect);
            return;
        } else if ([error code] == -999) { // @"Please Try   again"
            self.NetworkServiceBlock(@{@"Data": @"no"},Diconnect);
            return;
        } else if ([error code] == -1004) { //@"connection timed out"
            self.NetworkServiceBlock(@{@"Data": @"no"},TimeUp);
            return;
        } else if ([error code] == -1009) { //@"internet connection not avilable"
            self.NetworkServiceBlock(@{@"Data": @"no"},noInternet);
            return;
        } else if ([error code] == -1001) { //@"connection timed out"
            self.NetworkServiceBlock(@{@"Data": @"no"},TimeUp);
            return;
        } else {
            if (data != nil) {
                [self recivingJSONData:data withError:error];
            }
        }
    }];
    [loginDataTask resume];
}


-(void)recivingJSONData:(NSData *)data withError:(NSError *)error {
    NSMutableDictionary *jsonResponse = [[NSMutableDictionary alloc] init];
    jsonResponse=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonResponse == nil) {
        self.NetworkServiceBlock(@{@"Data": @"no"},TimeUp);
    }
    if([[NSString stringWithFormat:@"%@",[jsonResponse valueForKey:@"success"]] isEqualToString:@"1"] || [[NSString stringWithFormat:@"%@",[jsonResponse valueForKey:@"success"]] isEqualToString:@"true"] || [[NSString stringWithFormat:@"%@",[jsonResponse valueForKey:@"e"]] isEqualToString:@"0"]) { //when success
        self.NetworkServiceBlock(jsonResponse,NetworkSuccess);
    } else { //when success is failure
        self.NetworkServiceBlock(jsonResponse,NoSuccess);
        return;
    }
}

-(void)NetworkCallingOnUrlEncoded:(NSString *)_URL withKeys:(NSArray *)_keys andWithValues:(NSArray *)_val OperatingWithin:(UIViewController *)_Controller {
    
    self.presentController = _Controller;
    
    if (_keys.count != _val.count) {
        self.NetworkServiceBlock(@{@"message" : @"Keys and values count are not same"},Diconnect);
        return;
    }
    
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if([[cookie domain] isEqualToString:_URL]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:
                                   [NSURL URLWithString:_URL]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    NSMutableData *body = [NSMutableData data];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    NSMutableString *dataStr = [[NSMutableString alloc] init];
    for (int i=0; i<_keys.count; i++) {
        [dataStr appendString:[NSString stringWithFormat:@"%@=%@",[_keys objectAtIndex:i],[_val objectAtIndex:i]]];
        if (_keys.count-1 != i) {
            [dataStr appendString:@"&"];
        }
    }
    [request setURL:[NSURL URLWithString:_URL]];
    [body appendData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *loginDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        if ([error code] == -1005) { //network connection failure
            self.NetworkServiceBlock(@{@"message": @"Something went wrong try again"},Diconnect);
            return;
        } else if ([error code] == -999) { // @"Please Try   again"
            self.NetworkServiceBlock(@{ @"Data" : @"no"},Diconnect);
            return;
        } else if ([error code] == -1009) { //@"internet connection not avilable"
            self.NetworkServiceBlock(@{@"message": @"Something went wrong try again"},noInternet);
            return;
        } else if ([error code] == -1004) { //@"connection timed out"
            self.NetworkServiceBlock(@{@"message": @"Something went wrong try again"},TimeUp);
            return;
        } else if ([error code] == -1001) { //@"connection timed out"
            self.NetworkServiceBlock(@{@"message": @"Something went wrong try again"},TimeUp);
            return;
        } else {
            if (data != nil) {
                [self recivingJSONData:data withError:error];
            }
        }
    }];
    [loginDataTask resume];
}

-(void)StopTask {
    [loginDataTask1 cancel];
}



-(void)NetworkServiceCompleted:(nullable NetworkCompletioHandlerAction)completionHandler {
    self.NetworkServiceBlock = completionHandler;
}


-(void)RawDataAddressNetworkCallingOnUrl:(NSString *)_URL withString:(NSString *)_Data WithType:(NSString *)_type OperatingWithin:(UIViewController *)_Controller {
    
    self.presentController = _Controller;
    
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if([[cookie domain] isEqualToString:_URL]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    
    NSData *postData = [_Data dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    
    if(_type.length != 0) {
        [request setValue:_type forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    }
    NSError *error = nil;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable _data, NSURLResponse * _Nullable _response, NSError * _Nullable _error) {
        if (error) {     //error
             self.NetworkServiceBlock(@{ @"Data" : @"no"},Diconnect);
        } else {
            NSMutableDictionary *jsonResponse=[NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingAllowFragments error:&_error];
            if (jsonResponse == nil){
                self.NetworkServiceBlock(@{ @"Data" : @"no"},Diconnect);
                return;
            }
            if([[NSString stringWithFormat:@"%@",[jsonResponse valueForKey:@"em"]] isEqualToString:@"success"] || [[NSString stringWithFormat:@"%@",[jsonResponse valueForKey:@"success"]] isEqualToString:@"true"] || [[jsonResponse valueForKey:@"success"] isEqualToString:@"0"]) { //when success
                self.NetworkServiceBlock(jsonResponse,NetworkSuccess);
            } else { //when success is failure
                self.NetworkServiceBlock(jsonResponse,NoSuccess);
                return;
            }
        }
    }] resume];
   
}


-(void)GETNetworkCallingOnUrl:(NSString *)_URL withKeysHeader:(NSArray *)_keys andWithValuesHeader:(NSArray *)_val OperatingWithin:(UIViewController *)_Controller
{
    self.presentController = _Controller;
    if (_keys.count != _val.count) {
        self.NetworkServiceBlock(@{@"message" : @"Keys and values count are not same"},Diconnect);
        return;
    }
    
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if([[cookie domain] isEqualToString:_URL]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [request setHTTPMethod:@"GET"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    NSMutableString *dataStr = [[NSMutableString alloc] init];
    for (int i=0; i<_keys.count; i++) {
        [request setValue:[_val objectAtIndex:i] forHTTPHeaderField:[_keys objectAtIndex:i]];
    }
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_URL,dataStr]]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *loginDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //                                               NSLog(@"%@",[error description]);
        if ([error code] == -1005) { //network connection failure
            self.NetworkServiceBlock(@{ @"Data" : @"no"},Diconnect);
            return;
        } else if ([error code] == -999) { // @"Please Try   again"
            self.NetworkServiceBlock(@{ @"Data" : @"no"},Diconnect);
            return;
        } else if ([error code] == -1009) { //@"internet connection not avilable"
            self.NetworkServiceBlock(@{ @"Data" : @"no"},noInternet);
            return;
        } else if ([error code] == -1001) { //@"connection timed out"
            self.NetworkServiceBlock(@{ @"Data" : @"no"},TimeUp);
            return;
        } else if ([error code] == -1004) { //@"connection timed out"
            self.NetworkServiceBlock(@{ @"Data" : @"no"},TimeUp);
            return;
        } else {
            if (data != nil) {
                [self recivingJSONData:data withError:error];
            }
        }
    }];
    [loginDataTask resume];
}

/*erro codes for nsurl connetion
 
 kCFURLErrorUnknown   = -998,
 kCFURLErrorCancelled = -999,
 kCFURLErrorBadURL    = -1000,
 kCFURLErrorTimedOut  = -1001,
 kCFURLErrorUnsupportedURL = -1002,
 kCFURLErrorCannotFindHost = -1003,
 kCFURLErrorCannotConnectToHost    = -1004,
 kCFURLErrorNetworkConnectionLost  = -1005,
 kCFURLErrorDNSLookupFailed        = -1006,
 kCFURLErrorHTTPTooManyRedirects   = -1007,
 kCFURLErrorResourceUnavailable    = -1008,
 kCFURLErrorNotConnectedToInternet = -1009,
 kCFURLErrorRedirectToNonExistentLocation = -1010,
 kCFURLErrorBadServerResponse             = -1011,
 kCFURLErrorUserCancelledAuthentication   = -1012,
 kCFURLErrorUserAuthenticationRequired    = -1013,
 kCFURLErrorZeroByteResource        = -1014,
 kCFURLErrorCannotDecodeRawData     = -1015,
 kCFURLErrorCannotDecodeContentData = -1016,
 kCFURLErrorCannotParseResponse     = -1017,
 kCFURLErrorInternationalRoamingOff = -1018,
 kCFURLErrorCallIsActive               = -1019,
 kCFURLErrorDataNotAllowed             = -1020,
 kCFURLErrorRequestBodyStreamExhausted = -1021,
 kCFURLErrorFileDoesNotExist           = -1100,
 kCFURLErrorFileIsDirectory            = -1101,
 kCFURLErrorNoPermissionsToReadFile    = -1102,
 kCFURLErrorDataLengthExceedsMaximum   = -1103,
 
 */

@end
