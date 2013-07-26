//
//  RootWizardViewController.m
//  TheGameApp
//
//  Created by denisdbv@gmail.com on 24.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "RootWizardViewController.h"

@interface RootWizardViewController ()

@end

@implementation RootWizardViewController

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
    
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *onNextPageButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleBordered target:self action:@selector(onNextPage)];
    [self.navigationItem setRightBarButtonItem:onNextPageButton animated:YES];
    
    UIBarButtonItem *onCancelButton = [[UIBarButtonItem alloc] initWithTitle:@"x" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancel)];
    [self.navigationItem setLeftBarButtonItem:onCancelButton animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) onNextPage
{
    //
}

-(void) onCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
