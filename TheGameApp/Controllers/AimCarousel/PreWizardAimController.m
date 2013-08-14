//
//  PreWizardAimController.m
//  TheGameApp
//
//  Created by denisdbv@gmail.com on 24.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "PreWizardAimController.h"
#import "RootWizardViewController.h"
#import "AppDelegate.h"

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
    UINavigationController *nnn  = [[UINavigationController alloc] initWithRootViewController:rootWizardViewController];
   
    [self presentViewController:nnn animated:YES completion:nil];
}

-(IBAction) onExit:(id)sender
{
    [[SocManager sharedManager] logout];
    
    /*[self dismissViewControllerAnimated:YES completion:^{
       [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentLoginViewControllerAnimated:YES];
    }];*/

    [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentLoginViewControllerAnimated:YES];
}

@end
