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
        
        self.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        
        if(image == nil)
        {
            contentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-icon-small@2x.png"]];
            contentImage.frame = CGRectMake((self.frame.size.width-contentImage.frame.size.width/2)/2,
                                            (self.frame.size.height-contentImage.frame.size.height/2)/2,
                                            contentImage.frame.size.width/2,
                                            contentImage.frame.size.height/2);
            [self addSubview: contentImage];
        }
    }
    return self;
}

@end
