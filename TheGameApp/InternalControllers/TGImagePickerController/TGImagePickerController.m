//
//  TGImagePickerController.m
//  TheGameApp
//
//  Created by DenisDbv on 03.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TGImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface TGImagePickerController ()
@end

@implementation TGImagePickerController
{
    NSInteger imagePickerStatus;
    NSArray *actionSheetTitles;
}
@synthesize tgDelegate;

-(id) initWithStatus:(ImagePickerStatus)status
{
    self = [super init];
    if(self)    {
        imagePickerStatus = status;
        
        if(status == kImagePickerOnlyPhoto)
            actionSheetTitles = @[@"Снять фото", @"Выбрать фото"];
        else if(status == kImagePickerAll)
            actionSheetTitles = @[@"Снять фото", @"Снять видео", @"Выбрать фото"];
        
        [self showActionSheet];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) showActionSheet
{
    BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if (cameraDeviceAvailable && photoLibraryAvailable) {
        UIActionSheet *pickerActionSheet;
        
        if(imagePickerStatus == kImagePickerAll)    {
        
            pickerActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:(id)self
                                                   cancelButtonTitle:@"Отмена"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"Снять фото", @"Снять видео", @"Выбрать фото", nil];
        } else if(imagePickerStatus == kImagePickerOnlyPhoto)   {
            pickerActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:(id)self
                                                   cancelButtonTitle:@"Отмена"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"Снять фото", @"Выбрать фото", nil];
        }
        
        [pickerActionSheet showInView:self.view];
    } else {
        [self shouldPresentPhotoCaptureController];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(imagePickerStatus == kImagePickerAll)    {
        if (buttonIndex == 0) {
            [self shouldStartPhotoCameraController];
            [self actionSheetClick:kActionSheetPhoto];
        } else if (buttonIndex == 1) {
            [self shouldStartVideoCameraController];
            [self actionSheetClick:kActionSheetVideo];
        } else if (buttonIndex == 2) {
            [self shouldStartPhotoLibraryPickerController];
            [self actionSheetClick:kActionSheetLibrary];
        }
    }
    else if(imagePickerStatus == kImagePickerOnlyPhoto)
    {
        if (buttonIndex == 0) {
            [self shouldStartPhotoCameraController];
            [self actionSheetClick:kActionSheetPhoto];
        } else if (buttonIndex == 1) {
            [self shouldStartPhotoLibraryPickerController];
            [self actionSheetClick:kActionSheetLibrary];
        }
    }
}

-(void) actionSheetClick:(ActionSheetIndex)index
{
    if([tgDelegate respondsToSelector:@selector(imagePickerActionSheetClick:)])
    {
        [tgDelegate imagePickerActionSheetClick:index];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if([tgDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)])
    {
        [tgDelegate imagePickerControllerDidCancel:picker];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if([tgDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)])
    {
        [tgDelegate imagePickerController:picker didFinishPickingMediaWithInfo:info];
    }
}

- (BOOL)shouldPresentPhotoCaptureController {
    BOOL presentedPhotoCaptureController = [self shouldStartPhotoCameraController];
    
    if (!presentedPhotoCaptureController) {
        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
    }
    
    return presentedPhotoCaptureController;
}

- (BOOL)shouldStartPhotoCameraController {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        self.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    self.allowsEditing = YES;
    self.showsCameraControls = YES;
    self.delegate = (id)self;
    
    return YES;
}

- (BOOL)shouldStartVideoCameraController {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeMovie]) {
        
        self.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeMovie];
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.videoQuality = UIImagePickerControllerQualityTypeLow;
        
    } else {
        return NO;
    }
    
    self.showsCameraControls = YES;
    self.delegate = (id)self;
    
    return YES;
}

- (BOOL)shouldStartPhotoLibraryPickerController {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.mediaTypes = @[(NSString *) kUTTypeImage, (NSString *)kUTTypeMovie];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        self.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        self.mediaTypes = @[(NSString *) kUTTypeImage, (NSString *)kUTTypeMovie];
        
    } else {
        return NO;
    }
    
    self.allowsEditing = YES;
    self.delegate = (id)self;
    
    return YES;
}

@end
