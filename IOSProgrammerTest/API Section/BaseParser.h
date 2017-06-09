//
//  BaseParser.h
//  StyleCracker
//
//  Created by Abhijeet on 30/10/15.
//  Copyright © 2015 Winit. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ParserDelegate;

@interface BaseParser : NSObject<NSURLSessionDelegate>

@property(nonatomic, strong) id <ParserDelegate>delegate;
@property(nonatomic, assign) int tag;
@property (nonatomic, strong) NSMutableData *responseData;

+ (NSArray *)groupsFromJSON:(NSData *)objectNotation error:(NSError **)error;
- (void)createUrlBodySession:(NSURL *)url withBody:(NSData *)requestData withMethod:(NSString *)methodName;
- (NSDictionary *)getDataFromJSON:(NSData *)objectNotation error:(NSError **)error;

- (void)createUrlSession:(NSURL *)url withParameters:(NSString *)params withMethod:(NSString *)methodName;

- (void)parserData:(NSDictionary *)responseDictionary;

-(void)taskCompletedSuccessfully;

@end
@protocol ParserDelegate <NSObject>

-(void)responseReceived:(id)object forTag:(int)tag;
-(void)errorReceived:(id)object forTag:(int)tag;
@optional
-(void)taskCompletedSuccessfully;

@end