//
//  APISectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "LoginSectionViewController.h"
#import "MainMenuViewController.h"

@interface LoginSectionViewController ()

@end

@implementation LoginSectionViewController
@synthesize txtFldPassword;
@synthesize txtFldUserName;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
//    MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
//    [self.navigationController pushViewController:mainMenuViewController animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark -
#pragma  mark -- UIAlertController Action Methods


-(void)showAlertwithTitle:(NSString *)strTitle withMsg:(NSString *)strMsg
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:strTitle message:strMsg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)btnLoginClicked:(id)sender
{
    if(!txtFldUserName.text.length)
    {
        [self showAlertwithTitle:nil withMsg:@"Please enter Username."];
        
    }
    else if(!txtFldPassword.text.length)
    {
        [self showAlertwithTitle:nil withMsg:@"Please enter password."];
    }
    else
    {
        
        NSString *strtemp=[NSString stringWithFormat:@"username=%@&password=%@",txtFldUserName.text,txtFldPassword.text];
        
      
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dev3.apppartner.com/AppPartnerDeveloperTest/scripts/login.php"]];
        
        
        [self createUrlSession:url withParameters:strtemp withMethod:@"POST"];
        
    }
}

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
            [self showAlertwithTitle:@"" withMsg:@"Please logout and login again to continue"];
        }
        else
        {
            [self showAlertwithTitle:@"" withMsg:parsedObject[@"message"]];
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
            NSLog(@"%@",[error localizedDescription]);
        }
    }
    else {
        NSLog(@"Error %@",[error userInfo]);
        
        NSUInteger location = [[error localizedDescription] rangeOfString:@" ("].location;
        if ([error localizedDescription].length>location)
        {
                NSLog(@"%@",[error localizedDescription]); 
                
            }
            else
            {
                NSRange rangeStr = [[error localizedDescription].lowercaseString rangeOfString:@"The Internet "];
                if(rangeStr.length)
                {
                    NSLog(@"Please make sure you are connected to the internet to continue using our services");
                }
                else
                {
                    NSLog(@"%@",[error localizedDescription]);
                }
                
            }
        
    }
}


- (void)parserData:(NSDictionary *)responseDictionary
{
    NSLog(@"%@",responseDictionary);
    if ([[responseDictionary valueForKey:@"code"]  isEqual: @"Success"])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[responseDictionary valueForKey:@"code"] message:[responseDictionary valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* item = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   [alertController dismissViewControllerAnimated:YES completion:nil];
                                   //do something here
                                   MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
                                   [self.navigationController pushViewController:mainMenuViewController animated:YES];
                               }];
        
        [alertController addAction:item];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter invalid details." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
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
