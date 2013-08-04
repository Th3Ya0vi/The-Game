//
//  TGImagePickerController.h
//  TheGameApp
//
//  Created by DenisDbv on 03.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kImagePickerOnlyPhoto = 1,
    kImagePickerAll
}ImagePickerStatus;

typedef enum
{
    kActionSheetPhoto = 1,
    kActionSheetVideo,
    kActionSheetLibrary
}ActionSheetIndex;

@protocol TGImagePickerControllerDelegate <NSObject>
-(void) imagePickerActionSheetClick:(ActionSheetIndex)index;
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker;
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
@end

@interface TGImagePickerController : UIImagePickerController

@property (nonatomic, assign) id<TGImagePickerControllerDelegate> tgDelegate;

-(id) initWithStatus:(ImagePickerStatus)status;

@end
