//
//  AnimationSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "AnimationSectionViewController.h"
#import "MainMenuViewController.h"

@interface AnimationSectionViewController ()
{
    NSInteger num;
    ImageToDrag *imgForAnimation;
}

@end

@implementation AnimationSectionViewController
@synthesize animationImgView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    num =0;
    
    imgForAnimation = [[ImageToDrag alloc] initWithImage:animationImgView.image];
    imgForAnimation.frame = animationImgView.frame;
    imgForAnimation.userInteractionEnabled = YES;
    [self.view addSubview:imgForAnimation];
    animationImgView.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    imgForAnimation.frame = CGRectMake(self.view.frame.size.width/2,(self.view.frame.size.height)/2+50, 100, 100);
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

- (IBAction)btnSpinClicked:(id)sender
{
    num = 1;
    [self rotateImageView];
}

- (void)rotateImageView
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [imgForAnimation setTransform:CGAffineTransformRotate(imgForAnimation.transform, M_PI_2)];
    }completion:^(BOOL finished){
        if (finished)
        {
            if (num>3)
            {
                
            }
            else
            {
                num = num+1;
                NSLog(@"%ld",num);
                [self rotateImageView];
            }
            
        }
    }];
}
@end
