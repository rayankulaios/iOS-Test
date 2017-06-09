//
//  TableSectionTableViewCell.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell ()

@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;

@end

@implementation ChatCell


- (void)awakeFromNib
{
    // Initialization code
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
    self.userImageView.clipsToBounds = YES;
    
}

- (void)loadWithData:(ChatData *)chatData
{
    self.usernameLabel.text = chatData.username;
    self.messageTextView.text = chatData.message;
    self.userImageView.image= [self loadImageWithURL:[NSString stringWithFormat:@"%@",chatData.avatar_url] withImageView:self.userImageView];
}


-(UIImage *)loadImageWithURL:(NSString *)url withImageView:(UIImageView *)imageView
{
    UIImage *__block imageLoad;
    
    NSString *strMiscelleneousPath = [FileHandler getMiscelleneousDownloadedImageFilePathWithName:(NSMutableString *)url];
    if([FileHandler isFileExistsAtPath:strMiscelleneousPath])
    {
        imageLoad = [UIImage imageWithContentsOfFile:strMiscelleneousPath];
        if(imageLoad)
        {
            imageView.backgroundColor = [UIColor clearColor];
            
        }
        else
        {
            imageLoad = [UIImage imageNamed:@"photo"];
        }
        
        [imageView stopAnimating];
        imageView.animationImages = nil;
        imageView.image = imageLoad;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        return imageLoad;
    }
    
    UIImage *img1 = [UIImage imageNamed:@"photo"];
    
    imageView.image = img1;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView startAnimating];
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        
        NSData *__block imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        
        //this will set the image when loading is finished
        dispatch_sync(dispatch_get_main_queue(), ^{
            imageView.image = [UIImage imageNamed:@"photo"];
            imageLoad = [UIImage imageWithData:imageData];
            imageData = nil;
            
            
            
            if(imageLoad)
            {
                imageView.image = imageLoad;
                [FileHandler saveMiscelleneousImageInCache:imageLoad withName:(NSMutableString *)url completion:^(NSError *error) {
                    if(!error)
                    {
                        [imageView stopAnimating];
                        imageView.animationImages = nil;
                        imageView.image = imageLoad;
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        NSLog(@"miscelleneous image saved in cache");
                    }
                    else
                    {
                        NSLog(@"error occured while saving miscelleneous image in cache");
                    }
                }];
                
            }
            else
            {
                imageView.image = [UIImage imageNamed:@"photo"];
                
                [imageView startAnimating];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
            }
            //            [indicator stopAnimating];
            //            indicator = nil;
            
        });
    });
    
    return imageLoad;
}

@end
