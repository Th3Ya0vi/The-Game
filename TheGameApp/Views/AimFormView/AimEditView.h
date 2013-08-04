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

@interface AimEditView : UIView <TGPhotoAreaDelegate, TGImagePickerControllerDelegate>

-(void) dissapearView;

-(AimObject*) aimObjectFromView;

@end
