//
//  AimEditView.h
//  TheGameApp
//
//  Created by denisdbv@gmail.com on 26.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGPhotoArea.h"
#import "TGImagePickerController.h"
#import "AimObject.h"

@protocol AimEditViewDelegate <NSObject>
-(void) didChangeContextInView;
@end

@interface AimEditView : UIView <TGPhotoAreaDelegate, TGImagePickerControllerDelegate>

@property (nonatomic, retain) id<AimEditViewDelegate> delegate;

-(void) dissapearView;

-(AimObject*) aimObjectFromView;
-(void) setAimObject:(AimObject*)aimObject;

@end
