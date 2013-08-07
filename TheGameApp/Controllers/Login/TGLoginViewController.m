//
//  TGLoginViewController.m
//  TheGameApp
//
//  Created by DenisDbv on 22.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TGLoginViewController.h"
#import "AppDelegate.h"
#import "SocManager.h"

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

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authWillStart:)
                                                 name:SocAuthWillStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authDidFinish:)
                                                 name:SocAuthDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendWillStart:)
                                                 name:SocSendWillStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendDidFinish:)
                                                 name:SocSendDidFinishNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:SocAuthWillStartNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:SocAuthDidFinishNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:SocSendWillStartNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:SocSendDidFinishNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)authWillStart:(NSNotification*)sender
{
    NSLog(@"auth will start %@", sender.userInfo);
}

-(void)authDidFinish:(NSNotification*)sender
{
    NSLog(@"auth did finish %@", sender.userInfo);
}

-(void)sendWillStart:(NSNotification*)sender
{
    NSLog(@"send will start %@", sender.userInfo);
}

-(void)sendDidFinish:(NSNotification*)sender
{
    NSLog(@"send did finish %@", sender.userInfo);
}

-(IBAction)onFacebookClick:(id)sender
{
    /*[[SocManager sharedManager]auth:FacebookSocType complete:^(BOOL success){
        if (success){
            [self printUserData];
            [self openPreWizardController];
        }
    }];*/
    [self openPreWizardController];
}

-(IBAction)onLivejournalClick:(id)sender
{
    /*[[SocManager sharedManager]auth:LivejournalSocType complete:^(BOOL success){
        if (success){
            [self printUserData];
            [self openPreWizardController];
        }
    }];*/
    [self openPreWizardController];
}

-(IBAction)onVkontakteClick:(id)sender
{
    /*[[SocManager sharedManager]auth:VkontakteSocType complete:^(BOOL success){
        if (success){
            [self printUserData];
            [self openPreWizardController];
        }
    }];*/
    [self openPreWizardController];
}

-(void) printUserData
{
    SocManager* sm = [SocManager sharedManager];
    NSLog(@"********************");
    NSLog(@"Pic = %@", sm.userpic);
    NSLog(@"Name = %@", sm.username);
    NSLog(@"Country = %@", sm.country);
    NSLog(@"City = %@", sm.city);
    NSLog(@"********************");
}

-(void) openPreWizardController
{
    [self dismissViewControllerAnimated:YES completion:^{
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentAimWizardViewControllerAnimated:YES];
    }];
}

@end
