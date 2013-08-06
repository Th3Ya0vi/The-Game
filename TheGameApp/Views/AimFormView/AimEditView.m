//
//  AimEditView.m
//  TheGameApp
//
//  Created by denisdbv@gmail.com on 26.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "AimEditView.h"
#import <SSToolkit/SSToolkit.h>
#import <QuartzCore/QuartzCore.h>
#import "TGImagePickerController.h"
#import "UIView+ViewController.h"
#import "TGPhotoEditViewController.h"

@interface AimEditView()
@property (nonatomic, retain) TGImagePickerController *imagePickerController;
@property (nonatomic, retain) UITextField *aimTitleField;
@property (nonatomic, retain) UITextView *aimTextView;
@property (nonatomic, retain) TGPhotoArea *photo;
@property (nonatomic, retain) NSString *photoPath;
@end

@implementation AimEditView
@synthesize delegate;
@synthesize imagePickerController;
@synthesize aimTitleField, aimTextView, photo, photoPath;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithPatternImage:[UIImage imageNamed:@"login-background@2x.png"]];
        
        [self initView];
    }
    return self;
}

-(void) dissapearView
{
    [self stopObservingNotifications];
}

-(void) initView
{
    aimTitleField = [[UITextField alloc] initWithFrame:CGRectMake(12, 15, self.frame.size.width-24-65, 25.0f)];
    aimTitleField.backgroundColor = [UIColor clearColor];
    aimTitleField.textAlignment = NSTextAlignmentLeft;
    aimTitleField.textColor = [UIColor blackColor];
    aimTitleField.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
    aimTitleField.placeholder = @"Введите цель";
    aimTitleField.autocorrectionType = UITextAutocorrectionTypeNo;
    aimTitleField.keyboardType = UIKeyboardTypeDefault;
    aimTitleField.returnKeyType = UIReturnKeyNext;
    aimTitleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    aimTitleField.delegate = (id)self;
    [self addSubview: aimTitleField];
    
    photo = [[TGPhotoArea alloc] initWithImage:nil byFrame:CGRectMake(self.frame.size.width-45-10, (55-45)/2, 45, 45)];
    photo.delegate = (id)self;
    [self addSubview:photo];
    
    SSLineView *lineView = [[SSLineView alloc] initWithFrame:CGRectMake(0, 55, self.frame.size.width, 2)];
    lineView.lineColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    
    aimTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 55, self.frame.size.width-24, self.frame.size.height)];
    aimTextView.backgroundColor = [UIColor clearColor];
    aimTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
    aimTextView.textColor = [UIColor blackColor];
    aimTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    aimTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    aimTextView.returnKeyType = UIReturnKeyDefault;
    [self addSubview:aimTextView];
    
    [self startObservingNotifications];
}

- (void)startObservingNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)stopObservingNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveKeyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    CGRect frame = aimTextView.frame;
    frame.size.height = self.frame.size.height - aimTextView.frame.origin.y - keyboardHeight;
    
    aimTextView.frame = frame;
}

- (void)didReceiveKeyboardWillHideNotification:(NSNotification *)notification {
    
    CGRect frame = aimTextView.frame;
    frame.size.height = self.frame.size.height;
    
    aimTextView.frame = frame;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:aimTitleField])
    {
        [aimTextView becomeFirstResponder];
    }
    
    return YES;
}

-(void) didClickOnPhotoArea:(UIView *)boxView
{
    imagePickerController = [[TGImagePickerController alloc] initWithStatus:kImagePickerOnlyPhoto];
    imagePickerController.tgDelegate = (id)self;
}

-(void) imagePickerActionSheetClick:(ActionSheetIndex)index
{
    [self.appName_viewController presentViewController:imagePickerController animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    TGPhotoEditViewController *editViewController = [[TGPhotoEditViewController alloc] initWithDictionary:info];
    editViewController.delegate = (id)self;
    [editViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self.appName_viewController.navigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.appName_viewController.navigationController pushViewController:editViewController animated:NO];
}

-(void) addDataFromPhotoEdit:(ALAsset*)asset
{
    NSString *assetURL = [asset.defaultRepresentation.url absoluteString];
    photoPath = assetURL;
    [photo updateImageByPath:assetURL];
    
    [self sendAboutChangeInView];
}

-(AimObject*) aimObjectFromView
{
    AimObject *aimObject = [[AimObject alloc] init];
    aimObject.aimTitle = aimTitleField.text;
    aimObject.aimDescription = aimTextView.text;
    aimObject.aimPhoto = photoPath;
    
    return aimObject;
}

-(void) setAimObject:(AimObject*)aimObject
{
    aimTitleField.text = aimObject.aimTitle;
    aimTextView.text = aimObject.aimDescription;
    photoPath = aimObject.aimPhoto;
    [photo updateImageByPath:aimObject.aimPhoto];
}

-(void) sendAboutChangeInView
{
    if([delegate respondsToSelector:@selector(didChangeContextInView)])
    {
        [delegate didChangeContextInView];
    }
}

@end
