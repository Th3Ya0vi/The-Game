//
//  RootWizardViewController.h
//  TheGameApp
//
//  Created by denisdbv@gmail.com on 24.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AimEditView.h"

@interface RootWizardViewController : UIViewController <AimEditViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollContainerForAims;

@end
