//
//  APISectionViewController.h
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginData.h"
#import "BaseParser.h"

@interface LoginSectionViewController : UIViewController<NSURLSessionDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtFldUserName;

@property (strong, nonatomic) IBOutlet UITextField *txtFldPassword;
@property (nonatomic, strong) NSMutableData *responseData;

- (IBAction)btnLoginClicked:(id)sender;






@end
