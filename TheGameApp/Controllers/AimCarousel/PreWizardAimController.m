//
//  PreWizardAimController.m
//  TheGameApp
//
//  Created by denisdbv@gmail.com on 24.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "PreWizardAimController.h"
#import "RootWizardViewController.h"

@interface PreWizardAimController ()
@property (nonatomic, strong) RootWizardViewController *rootWizardViewController;
@end

@implementation PreWizardAimController
@synthesize rootWizardViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction) addAims:(id)sender
{
    rootWizardViewController = [[RootWizardViewController alloc] init];
    
    [self.navigationController pushViewController:rootWizardViewController animated:YES];
}

@end
