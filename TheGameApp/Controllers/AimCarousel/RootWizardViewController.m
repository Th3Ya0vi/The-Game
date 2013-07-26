//
//  RootWizardViewController.m
//  TheGameApp
//
//  Created by denisdbv@gmail.com on 24.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "RootWizardViewController.h"
#import "AimEditView.h"

@interface RootWizardViewController ()

@end

@implementation RootWizardViewController
{
    NSInteger pageIndex;
}

@synthesize scrollContainerForAims;

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
    
    [self initCode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) initCode
{
    pageIndex = 0;
    
    [self addAimPage];
}

-(void) onNextPage
{
    [self addAimPage];
    
    [self scrollToIndex: pageIndex-1];
}

-(void) onCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) scrollToIndex:(NSInteger)index
{
    if (index <= 0) {
        index = 0;
    }
    
    [scrollContainerForAims scrollRectToVisible:CGRectMake(index * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.bounds.size.height) animated:YES];
}

-(void) addAimPage
{
    AimEditView *aimPage = [[AimEditView alloc] initWithFrame:self.view.bounds];
    aimPage.frame = CGRectMake(pageIndex*aimPage.frame.size.width, aimPage.frame.origin.y, aimPage.frame.size.width, aimPage.frame.size.height);
    
    scrollContainerForAims.contentSize = CGSizeMake( (pageIndex+1)*self.view.frame.size.width, self.view.bounds.size.height);
    [scrollContainerForAims addSubview:aimPage];
    
    pageIndex++;
}

@end
