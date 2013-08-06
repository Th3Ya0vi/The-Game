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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)onFacebookClick:(id)sender
{
    [[SocManager sharedManager]auth:FacebookSocType complete:^(BOOL success){
        if (success){
            //UserViewController* vc = [UserViewController new];
            //[self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

-(IBAction)onLivejournalClick:(id)sender
{
    [[SocManager sharedManager]auth:LivejournalSocType complete:^(BOOL success){
        if (success){
            //UserViewController* vc = [UserViewController new];
            //[self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

-(IBAction)onVkontakteClick:(id)sender
{
    [[SocManager sharedManager]auth:VkontakteSocType complete:^(BOOL success){
        if (success){
            //UserViewController* vc = [UserViewController new];
            //[self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end
