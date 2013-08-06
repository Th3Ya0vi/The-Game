//
//  LJDialog.h
//  SocialClient
//
//  Created by Admin on 28.07.13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LJDialog : UIView
{
    UIView* _webView;
    UITextField* _loginField;
    UITextField* _passField;
    UIButton* _logintButton;

    UIButton* _closeButton;
    UIInterfaceOrientation _orientation;
    BOOL _showingKeyboard;
    
    // Ensures that UI elements behind the dialog are disabled.
    UIView* _modalBackgroundView;
}

-(void)show;

@end
