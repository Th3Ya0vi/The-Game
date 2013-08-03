//
//  TGPhotoArea.h
//  TheGameApp
//
//  Created by DenisDbv on 03.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TGPhotoAreaDelegate <NSObject>
-(void) didClickOnPhotoArea:(UIView*)boxView;
@end

@interface TGPhotoArea : UIView

@property (nonatomic, strong) id delegate;

-(id) initWithImage:(UIImage*)image byFrame:(CGRect)frame;

@end
