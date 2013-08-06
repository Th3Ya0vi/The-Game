//
//  TGLoginViewController.m
//  TheGameApp
//
//  Created by DenisDbv on 22.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TGLoginViewController.h"
#import "AppDelegate.h"

@interface TGLoginViewController ()

@end

@implementation TGLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)onFacebookClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentAimWizardViewControllerAnimated:YES];
    }];
}

-(IBAction)onLivejournalClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentAimWizardViewControllerAnimated:YES];
}

-(IBAction)onVkontakteClick:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentAimWizardViewControllerAnimated:YES];
}

@end
