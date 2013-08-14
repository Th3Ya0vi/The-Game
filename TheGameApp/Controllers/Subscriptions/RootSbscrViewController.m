//
//  RootSbscrViewController.m
//  TheGameApp
//
//  Created by denisdbv@gmail.com on 14.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "RootSbscrViewController.h"

@interface RootSbscrViewController ()

@end

@implementation RootSbscrViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Tab Bar delegate methods

- (NSString *)tabTitle
{
	return @"Подписи";
}

-(NSString*)tabImageName
{
    return @"tabbar-eye-icon@2x.png";
}

@end
