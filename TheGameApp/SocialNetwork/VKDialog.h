//
//  SocDialog.h
//  SocialClient
//
//  Created by Admin on 28.07.13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VKDialog : UIView<UIWebViewDelegate>
{
    UIButton* _closeButton;
    UIInterfaceOrientation _orientation;
    BOOL _showingKeyboard;
    
    // Ensures that UI elements behind the dialog are disabled.
    UIView* _modalBackgroundView;
}

@property (nonatomic) id delegate;
@property (nonatomic, copy) NSString *appID;

@property(nonatomic) UIWebView* webView;
@property(nonatomic) UIActivityIndicatorView* spinner;

-(void)show;

+ (NSString*)stringBetweenString:(NSString*)start
                       andString:(NSString*)end
                     innerString:(NSString*)str;

@end
