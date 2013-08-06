//
//  TGPhotoArea.m
//  TheGameApp
//
//  Created by DenisDbv on 03.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TGPhotoArea.h"

@implementation TGPhotoArea
{
    UIImageView *contentImage;
}

-(id) initWithImage:(UIImage*)image byFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        
        if(image == nil)
        {
            contentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-icon-small@2x.png"]];
            contentImage.userInteractionEnabled = YES;
            contentImage.frame = CGRectMake((self.frame.size.width-contentImage.frame.size.width/2)/2,
                                            (self.frame.size.height-contentImage.frame.size.height/2)/2,
                                            contentImage.frame.size.width/2,
                                            contentImage.frame.size.height/2);
            [self addSubview: contentImage];
        }
        
        CALayer *layer = [self layer];
        layer.cornerRadius = 4.0f;
        layer.masksToBounds = YES;
    }
    return self;
}

-(void) updateImageByPath:(NSString*)url
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library assetForURL:[NSURL URLWithString:url] resultBlock:^(ALAsset *asset) {
        
        CGImageRef thumbnailImageRef = [asset thumbnail];
        
        if(thumbnailImageRef != nil)    {
            /*ALAssetRepresentation *representation = [asset defaultRepresentation];
             CGImageRef originalImage = [representation fullResolutionImage];
             UIImage *original = [UIImage imageWithCGImage:originalImage];*/
            
            UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];

            contentImage.image = thumbnail;
            contentImage.frame = CGRectMake(0, 0,
                                            45,
                                            45);
        } else  {
            contentImage.image = [UIImage imageNamed:@"photo-icon-small@2x.png"];
            contentImage.frame = CGRectMake((self.frame.size.width-contentImage.image.size.width/2)/2,
                                            (self.frame.size.height-contentImage.image.size.height/2)/2,
                                            contentImage.image.size.width/2,
                                            contentImage.image.size.height/2);
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"asset failture");
    }];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self.delegate respondsToSelector:@selector(didClickOnPhotoArea:)])
    {
        [self.delegate didClickOnPhotoArea:self];
    }
}

@end
