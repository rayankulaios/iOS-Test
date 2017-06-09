//
//  FileHandler.m
//  Nescafe
//
//  Created by Rajesh.Nanna on 12/03/14.
//  Copyright (c) 2014 WIN Information Technology. All rights reserved.
//

#import "FileHandler.h"


#define NullValidate(string) \
{if(string==nil || [string isKindOfClass:[NSNull class]] || [string isEqualToString:@"(null)"] || ![string length]){string=[NSMutableString stringWithString:@""];}}


#define APPLICATION_CACHE_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) count]?[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]:@""

#define DOWNLOADED_IMAGES @"DOWNLOADEDIMAGES"
#define SOCIALHISTORY_DOWNLOADED_IMAGES @"PROFILEPIC"
#define MISCELLENOUS_DOWNLOADED_IMAGES @"PROFILEPIC"
#define COMPETITION_DOWNLOADED_IMAGES @"COMPETITIONDOWNLOADEDIMAGES/1"

@implementation FileHandler

+(BOOL)createFolderAtPath:(NSString *)folderPath
{
    NSError *error = nil;
    
    if( [[NSFileManager defaultManager]fileExistsAtPath:folderPath])
    {
        return YES;
    }
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        
//        folderPath = nil;
        if(error)
            return NO;
        else
            return YES;
    }
}

+(BOOL)createFolderAtPath:(NSString *)folderPath withFileName:(NSString *)fileName
{
    NullValidate(folderPath);
    NullValidate(fileName);
    
    NSError *err = nil;
    
    [FileHandler createFolderAtPath:folderPath];
    
    if(![FileHandler isFileExistsAtPath:[folderPath stringByAppendingPathComponent:fileName]])
    {
        //create file
        NSString *defaultPath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:fileName];
        
        [[NSFileManager defaultManager] copyItemAtPath:defaultPath toPath:[folderPath stringByAppendingPathComponent:fileName] error:&err];
        
        if(err)
        {
            defaultPath = nil;
            folderPath = nil;
            fileName = nil;
            
         //   SOHLogs(@"Error while creating file %@",[err localizedDescription]);
            return NO;
        }
        else
        {
            defaultPath = nil;
            folderPath = nil;
            fileName = nil;
            
            return YES;
        }
    }
    else{
        folderPath = nil;
        fileName = nil;

     //   SOHLogs(@"file already exists");
        return YES;
    }
    
    return NO;
}

#pragma mark ---

+(NSString *) getCacheDirectory
{
    return APPLICATION_CACHE_PATH;
}


+(BOOL) isFileExistsAtPath:(NSString *)path
{
    NullValidate(path);
    return [[NSFileManager defaultManager]fileExistsAtPath:path];
}

+(BOOL) removeFileAtPath:(NSString *)path
{
    NullValidate(path);

    NSError *error = nil;
    BOOL success = NO;
    
    success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (!success || error) {
        path = nil;
        return NO;
    }
    
    path = nil;
    return success;
}


#pragma mark Image Save Methods

+(NSString *) getFeedsDownloadedImageFilePathWithName:(NSMutableString *)fileName
{
    NSMutableString *filepath = [NSMutableString string];
    NSMutableString *strMutFileName = [NSMutableString stringWithString:fileName.length?fileName:@""];
    
    [strMutFileName replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];

    [filepath appendFormat:@"%@/%@/%@",[FileHandler getCacheDirectory],SOCIALHISTORY_DOWNLOADED_IMAGES,strMutFileName];
    
    fileName = nil;
    strMutFileName = nil;
    
    return (NSString *)filepath;
}

+(NSString *) getMiscelleneousDownloadedImageFilePathWithName:(NSMutableString *)fileName
{
    NSMutableString *filepath = [NSMutableString string];
    NSMutableString *strMutFileName = [NSMutableString stringWithString:fileName.length?fileName:@""];

    [strMutFileName replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    
    [filepath appendFormat:@"%@/%@/%@",[FileHandler getCacheDirectory],MISCELLENOUS_DOWNLOADED_IMAGES,strMutFileName];
    
    fileName = nil;
    strMutFileName = nil;
    
    return (NSString *)filepath;
}

+(NSString *) getDownloadedImageFilePathWithName:(NSString *)fileName
{
    NSMutableString *filepath = [NSMutableString string];
    
    [filepath appendFormat:@"%@/%@/%@",[FileHandler getCacheDirectory],DOWNLOADED_IMAGES,fileName];
    fileName = nil;
    
    return (NSString *)filepath;
}

+(void) saveImageInCache:(UIImage *)imgDownloaded withName:(NSMutableString *)fileName completion:(void (^)(NSError *error))completionBlock
{
    NSMutableString *strMutFileName = [NSMutableString stringWithString:fileName];

    [strMutFileName replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];

    BOOL isSaved = NO;
 
    if(!imgDownloaded)
    {
        fileName = nil;
        strMutFileName = nil;
        completionBlock([NSError errorWithDomain:@"Image is nil" code:1221 userInfo:nil]);
        return;
    }
    
    NSData *responseData = UIImageJPEGRepresentation(imgDownloaded,1.0);
    
    NSString *cachePath = [FileHandler getCacheDirectory];
    
    NSMutableString *folderPath = [NSMutableString string];
    
    [folderPath appendFormat:@"%@/%@",[FileHandler getCacheDirectory],DOWNLOADED_IMAGES];

    [FileHandler createFolderAtPath:folderPath];
    
    NSString *filePath;
	filePath =  [cachePath stringByAppendingPathComponent:DOWNLOADED_IMAGES];
    
    NSString *savingFilePath = [filePath stringByAppendingPathComponent:strMutFileName];
    isSaved = [responseData writeToFile:savingFilePath atomically:YES];

    savingFilePath = nil;
    responseData = nil;
    fileName = nil;
    strMutFileName = nil;
    filePath = nil;
    cachePath = nil;
    
    if(isSaved)
        completionBlock(nil);
    else
        completionBlock([NSError errorWithDomain:@"Failed to save image in cache" code:1221 userInfo:nil]);
}

+(void) saveFeedsImageInCache:(UIImage *)imgDownloaded withName:(NSString *)fileName completion:(void (^)(NSError *error))completionBlock
{
    NSMutableString *strMutFileName = [NSMutableString stringWithString:fileName];

    [strMutFileName replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    
    BOOL isSaved = NO;
    
    if(!imgDownloaded)
    {
        imgDownloaded = nil;
        fileName = nil;
        strMutFileName = nil;
        
        completionBlock([NSError errorWithDomain:@"Image is nil" code:1221 userInfo:nil]);
        return;
    }
    
    NSData *responseData = UIImageJPEGRepresentation(imgDownloaded, 1.0);
    
    NSString *cachePath = [FileHandler getCacheDirectory];
    
    NSMutableString *folderPath = [NSMutableString string];
    
    [folderPath appendFormat:@"%@/%@",[FileHandler getCacheDirectory],SOCIALHISTORY_DOWNLOADED_IMAGES];
    
    
    [FileHandler createFolderAtPath:folderPath];
    folderPath = nil;
    
    NSString *filePath;
	filePath =  [cachePath stringByAppendingPathComponent:SOCIALHISTORY_DOWNLOADED_IMAGES];
    
    NSString *savingFilePath = [filePath stringByAppendingPathComponent:strMutFileName];
    isSaved = [responseData writeToFile:savingFilePath atomically:YES];
    
    responseData = nil;
    cachePath = nil;
    savingFilePath = nil;
    strMutFileName = nil;
    fileName = nil;

    if(isSaved)
        completionBlock(nil);
    else
        completionBlock([NSError errorWithDomain:@"Failed to save image in cache" code:1221 userInfo:nil]);
}

+(void) saveMiscelleneousImageInCache:(UIImage *)imgDownloaded withName:(NSMutableString *)fileName completion:(void (^)(NSError *error))completionBlock
{
    NSMutableString *strMutFileName = [NSMutableString stringWithString:fileName];

    [strMutFileName replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];

    BOOL isSaved = NO;
    
    if(!imgDownloaded)
    {
        fileName = nil;
        strMutFileName = nil;
        
        completionBlock([NSError errorWithDomain:@"Image is nil" code:1221 userInfo:nil]);
        return;
    }
    
    NSData *responseData = UIImageJPEGRepresentation(imgDownloaded, 1.0);
    imgDownloaded = nil;
    
    NSString *cachePath = [FileHandler getCacheDirectory];
    
    NSMutableString *folderPath = [NSMutableString string];
    
    [folderPath appendFormat:@"%@/%@",[FileHandler getCacheDirectory],MISCELLENOUS_DOWNLOADED_IMAGES];
    
    [FileHandler createFolderAtPath:folderPath];
    
    NSString *filePath;
	filePath =  [cachePath stringByAppendingPathComponent:MISCELLENOUS_DOWNLOADED_IMAGES];
    
    NSString *savingFilePath = [filePath stringByAppendingPathComponent:strMutFileName];
    isSaved = [responseData writeToFile:savingFilePath atomically:YES];
    
    responseData = nil;
    cachePath = nil;
    folderPath = nil;
    filePath = nil;
    savingFilePath = nil;
    strMutFileName = nil;
    
    if(isSaved)
        completionBlock(nil);
    else
        completionBlock([NSError errorWithDomain:@"Failed to save image in cache" code:1221 userInfo:nil]);
}


+(UIImage *) getImageFromCachewithName:(NSMutableString *)fileName
{
    NSMutableString *strMutFileName = [NSMutableString stringWithString:fileName];

    [strMutFileName replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];

    UIImage *imgSaved = nil;
    
    if(!strMutFileName || !strMutFileName.length)
    {
        return nil;
    }
    
    NSString *cachePath = [FileHandler getCacheDirectory];
    
    
    NSMutableString *folderPath = [NSMutableString string];
    
    [folderPath appendFormat:@"%@/%@",[FileHandler getCacheDirectory],DOWNLOADED_IMAGES];

    if(![FileHandler isFileExistsAtPath:folderPath])
    {
        cachePath = nil;
        folderPath = nil;
        strMutFileName = nil;
        return nil;
    }
    
    NSString *filePath;
	filePath =  [cachePath stringByAppendingPathComponent:folderPath];
    
    NSString *savingFilePath = [filePath stringByAppendingPathComponent:strMutFileName];
    
    imgSaved = [UIImage imageWithContentsOfFile:savingFilePath];
    
    cachePath = nil;
    folderPath = nil;
    filePath = nil;
    savingFilePath = nil;
    strMutFileName = nil;
    
    return imgSaved;
}

+(void) removeImageFromCachewithName:(NSMutableString *)fileName completion:(void (^)(NSError *error))completionBlock
{
    NSMutableString *strMutFileName = [NSMutableString stringWithString:fileName];

    [strMutFileName replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    [strMutFileName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
    
    if(!strMutFileName || !strMutFileName.length)
    {
        completionBlock([NSError errorWithDomain:@"File name is empty" code:1221 userInfo:nil]);
        return;
    }
    
    NSString *cachePath = [FileHandler getCacheDirectory];
    
    
    NSMutableString *folderPath = [NSMutableString string];
    
    [folderPath appendFormat:@"%@/%@",[FileHandler getCacheDirectory],DOWNLOADED_IMAGES];

    if(![FileHandler isFileExistsAtPath:folderPath])
    {
        completionBlock([NSError errorWithDomain:@"Folder doesn't exist" code:1221 userInfo:nil]);
        return;
    }
    
    NSString *filePath;
	filePath =  [cachePath stringByAppendingPathComponent:folderPath];
    
    NSString *savingFilePath = [filePath stringByAppendingPathComponent:strMutFileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:savingFilePath] == YES)
	{
		BOOL isSaved = [[NSFileManager defaultManager] removeItemAtPath:savingFilePath error:nil];
        
        cachePath = nil;
        filePath = nil;
        savingFilePath = nil;
        folderPath = nil;
        
        if(!isSaved)
            completionBlock([NSError errorWithDomain:@"Failed to remove the image at path" code:1221 userInfo:nil]);
        else
            completionBlock(nil);
	}
    else
    {
        cachePath = nil;
        filePath = nil;
        savingFilePath = nil;
        folderPath = nil;
        
        completionBlock([NSError errorWithDomain:@"File doesn't exists at path" code:1221 userInfo:nil]);
    }
}
+(NSString *) getCompetitionDownloadedImageFilePathWithName:(NSMutableString *)fileName
{
    NSMutableString *filepath = [NSMutableString string];
    NSMutableString *strMutFileName = [NSMutableString stringWithString:fileName.length?fileName:@""];
   
        [strMutFileName replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
        [strMutFileName replaceOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
        [strMutFileName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
        
        [filepath appendFormat:@"%@/%@/%@",[FileHandler getCacheDirectory],COMPETITION_DOWNLOADED_IMAGES,strMutFileName];
        
    
    fileName = nil;
    strMutFileName = nil;
    
    return (NSString *)filepath;
}
+(void) saveCompetitionImageInCache:(id)imgDownloaded withName:(NSMutableString *)fileName completion:(void (^)(NSError *error))completionBlock
{
    @try {
        NSMutableString *strMutFileName;
      
        
         strMutFileName = [NSMutableString stringWithString:fileName];
        
        [strMutFileName replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
        [strMutFileName replaceOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
        [strMutFileName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMutFileName.length)];
        
        BOOL isSaved = NO;
        
        if(!imgDownloaded)
        {
            fileName = nil;
            strMutFileName = nil;
            
            completionBlock([NSError errorWithDomain:@"Image is nil" code:1221 userInfo:nil]);
            return;
        }
        
        NSData *responseData = UIImageJPEGRepresentation(imgDownloaded, 1.0);
        imgDownloaded = nil;
        
        NSString *cachePath = [FileHandler getCacheDirectory];
        
        NSMutableString *folderPath = [NSMutableString string];
        
            [folderPath appendFormat:@"%@/%@",[FileHandler getCacheDirectory],COMPETITION_DOWNLOADED_IMAGES];
        
        [FileHandler createFolderAtPath:folderPath];
        
        NSString *filePath;
        
       
            filePath =  [cachePath stringByAppendingPathComponent:COMPETITION_DOWNLOADED_IMAGES];
            
            NSString *savingFilePath = [filePath stringByAppendingPathComponent:strMutFileName];
            isSaved = [responseData writeToFile:savingFilePath atomically:YES];
            savingFilePath = nil;

        responseData = nil;
        cachePath = nil;
        folderPath = nil;
        filePath = nil;
        strMutFileName = nil;
        
        if(isSaved)
            completionBlock(nil);
        else
            completionBlock([NSError errorWithDomain:@"Failed to save image in cache" code:1221 userInfo:nil]);

    }
    @catch (NSException *exception) {
      //  SOHLogs(@"exception : %@ ",exception.description);
    }
}
@end
