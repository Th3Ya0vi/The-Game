//
//  UIView+ViewController.m
//  TheGameApp
//
//  Created by DenisDbv on 03.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)appName_viewController {
    /// Finds the view's view controller.
    
    // Take the view controller class object here and avoid sending the same message iteratively unnecessarily.
    Class vcc = [UIViewController class];
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: vcc])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}

@end
