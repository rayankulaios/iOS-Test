//
//  AnimationSectionViewController.h
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageToDrag.h"

@interface AnimationSectionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *animationImgView;

- (IBAction)btnSpinClicked:(id)sender;



@end
