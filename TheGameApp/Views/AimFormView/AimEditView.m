//
//  AimEditView.m
//  TheGameApp
//
//  Created by denisdbv@gmail.com on 26.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "AimEditView.h"
#import <SSToolkit/SSToolkit.h>

@interface AimEditView()
@property (nonatomic, retain) UITextField *aimTitleField;
@property (nonatomic, retain) UITextView *aimTextView;
@end

@implementation AimEditView
@synthesize aimTitleField, aimTextView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login-background@2x.png"]];
        
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
    aimTitleField.textColor = [UIColor whiteColor];
    aimTitleField.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
    aimTitleField.placeholder = @"Введите цель";
    aimTitleField.autocorrectionType = UITextAutocorrectionTypeNo;
    aimTitleField.keyboardType = UIKeyboardTypeDefault;
    aimTitleField.returnKeyType = UIReturnKeyNext;
    aimTitleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    aimTitleField.delegate = (id)self;
    [self addSubview: aimTitleField];
    
    SSLineView *lineView = [[SSLineView alloc] initWithFrame:CGRectMake(0, 55, self.frame.size.width, 2)];
    lineView.lineColor = [UIColor whiteColor];
    [self addSubview:lineView];
    
    aimTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 55, self.frame.size.width-24, self.frame.size.height)];
    aimTextView.backgroundColor = [UIColor clearColor];
    aimTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
    aimTextView.textColor = [UIColor whiteColor];
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

@end
