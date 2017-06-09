//
//  FileHandler.h
//  Nescafe
//
//  Created by Rajesh.Nanna on 12/03/14.
//  Copyright (c) 2014 WIN Information Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface FileHandler : NSObject

+(BOOL)createFolderAtPath:(NSString *)folderPath;
+(BOOL)createFolderAtPath:(NSString *)folderPath withFileName:(NSMutableString *)fileName;
+(NSString *) getCacheDirectory;
+(BOOL) isFileExistsAtPath:(NSString *)path;
+(BOOL) removeFileAtPath:(NSString *)path;

+(void) saveImageInCache:(UIImage *)imgDownloaded withName:(NSMutableString *)fileName completion:(void (^)(NSError *error))completionBlock;
+(UIImage *) getImageFromCachewithName:(NSMutableString *)fileName;
+(void) removeImageFromCachewithName:(NSMutableString *)fileName completion:(void (^)(NSError *error))completionBlock;
+(NSString *) getDownloadedImageFilePathWithName:(NSMutableString *)fileName;
+(NSString *) getFeedsDownloadedImageFilePathWithName:(NSMutableString *)fileName;
+(void) saveFeedsImageInCache:(UIImage *)imgDownloaded withName:(NSString *)fileName completion:(void (^)(NSError *error))completionBlock;

+(void) saveMiscelleneousImageInCache:(UIImage *)imgDownloaded withName:(NSMutableString *)fileName completion:(void (^)(NSError *error))completionBlock;
+(NSString *) getMiscelleneousDownloadedImageFilePathWithName:(NSMutableString *)fileName;
+(NSString *) getCompetitionDownloadedImageFilePathWithName:(NSMutableString *)fileName;
+(void) saveCompetitionImageInCache:(UIImage *)imgDownloaded withName:(NSMutableString *)fileName completion:(void (^)(NSError *error))completionBlock;




@end
