    
//
//  BaseParser.m
//  StyleCracker
//
//  Created by Abhijeet on 30/10/15.
//  Copyright © 2015 Winit. All rights reserved.
//

#import "BaseParser.h"

@implementation BaseParser
@synthesize delegate;
@synthesize tag;


-(void)request:(NSURL *)url body:(NSString *)body andMethodType:(NSString *)type
{
//    NSURLSession 
}


+ (NSArray *)groupsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    

    NSArray *results = [parsedObject valueForKey:@"response"];
    
    return results;
}
- (NSDictionary *)getDataFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    if ([parsedObject.allKeys containsObject:@"response"]) {
        
        return parsedObject[@"response"];
    }
    else  if ([parsedObject.allKeys containsObject:@"error"]) {
        NSInteger code = [[parsedObject objectForKey:@"error"] integerValue];
        if (code == 1000) {
            [self.delegate errorReceived:@"Please logout and login again to continue" forTag:self.tag];
        }
        else
        {
            [self.delegate errorReceived:parsedObject[@"message"] forTag:self.tag];
        }
        return nil;
    }
        
        
    return parsedObject;
}

#pragma mark - Create NSURlSession & Delegate Methods
- (void)createUrlSession:(NSURL *)url withParameters:(NSString *)strtemp withMethod:(NSString *)methodName {
    
    
    NSLog(@"REQUEST === %@ && url is : %@",strtemp,url.absoluteString);
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    defaultConfigObject.timeoutIntervalForRequest = 800;
    defaultConfigObject.timeoutIntervalForResource = 800;
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:methodName];
//    [urlRequest setValue:@"createNewOrganizer" forHTTPHeaderField:@"Action"];
    
    [urlRequest setHTTPBody:[strtemp dataUsingEncoding:NSUTF8StringEncoding]];
    

//    NSString *strtemp=[NSString stringWithFormat:@"Action=createNewOrganizer&JsoneString=%@",params];
    
    NSData *requestData = [strtemp dataUsingEncoding:NSUTF8StringEncoding];
    
  
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
 
    [urlRequest setHTTPBody: requestData];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    
    [dataTask resume];
    
}

- (void)createUrlBodySession:(NSURL *)url withBody:(NSData *)requestData withMethod:(NSString *)methodName {
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    defaultConfigObject.timeoutIntervalForRequest = 80;
    defaultConfigObject.timeoutIntervalForResource = 80;
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:methodName];
    //    [urlRequest setValue:@"createNewOrganizer" forHTTPHeaderField:@"Action"];
    
//    [urlRequest setHTTPBody:[strtemp dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    //    NSString *strtemp=[NSString stringWithFormat:@"Action=createNewOrganizer&JsoneString=%@",params];
//    
//    NSData *requestData = [strtemp dataUsingEncoding:NSUTF8StringEncoding];
//    
    
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [urlRequest setHTTPBody: requestData];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    
    [dataTask resume];
    
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    if (self.responseData == nil) {
        
        self.responseData = [NSMutableData new];
    }
    [self.responseData appendData:data];
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if(error == nil)
    {
      //  SOHLogs(@"Download is Succesfull");
        
        NSDictionary *responseDictionary = nil;
        
        if (self.responseData != nil) {
            NSString * str = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
            NSLog(@"Received String %@",str);

            responseDictionary = [self getDataFromJSON:self.responseData error:&error];
        }
        
        if ([responseDictionary isKindOfClass:[NSDictionary class]]) {
            [self parserData:responseDictionary];
        }
        else{
            [self.delegate errorReceived:[error localizedDescription] forTag:self.tag];
        }
    }
    else {
        NSLog(@"Error %@",[error userInfo]);
        if ([self.delegate respondsToSelector:@selector(errorReceived:forTag:)]) {
            
            NSUInteger location = [[error localizedDescription] rangeOfString:@" ("].location;
            if ([error localizedDescription].length>location) {
                [self.delegate errorReceived:[[error localizedDescription] substringToIndex:[[error localizedDescription] rangeOfString:@" ("].location] forTag:self.tag];

            }
            else
            {
                NSRange rangeStr = [[error localizedDescription].lowercaseString rangeOfString:@"The Internet "];
                if(rangeStr.length)
                {
                    [self.delegate errorReceived:@"Please make sure you are connected to the internet to continue using our services" forTag:self.tag];

                }
                else
                {
                    [self.delegate errorReceived:[error localizedDescription] forTag:self.tag];

                }
                
            }
        }
    }
}


- (void)parserData:(NSDictionary *)responseDictionary
{
    NSAssert(0, @"NO need here");
}

-(void)taskCompletedSuccessfully
{
    
}

-(void)responseReceived:(id)object forTag:(int)tag
{
}
-(void)errorReceived:(id)object forTag:(int)tag;
{
    
}


@end
