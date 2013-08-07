//
//  VKManager.m
//  SocialClient
//
//  Created by Admin on 18.07.13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "SocManager.h"
#import "AppDelegate.h"
//#import "UserViewController.h"

#import "SHKSharer.h"
#import "SHKFacebook.h"
#import "Vkontakte.h"
#import "SHK.h"
#import "Livejournal.h"
#import "Facebook.h"

#define SHKVkontakte Vkontakte

NSString * const SocSendWillStartNotification = @"SocSendWillStartNotification";
NSString * const SocSendDidFinishNotification = @"SocSendDidFinishNotification";
NSString * const SocAuthWillStartNotification = @"SocAuthWillStartNotification";
NSString * const SocAuthDidFinishNotification = @"SocAuthDidFinishNotification";


typedef enum
{
    SendTypeNone,
    SendTypeFBGetUseInfo,
    SendTypeVKGetUseInfo,
    SendTypeFBShare,
    SendTypeVKShare
} SendType;


@interface SocManager ()

@end

@implementation SocManager
{
    SendType _sendType;    
    SocAuthHandler _authHandler;
    SocType _socType;
}

+(id)sharedManager
{
    static SocManager* manager = nil;
    if (manager == nil) manager = [[SocManager alloc]init];
    return manager;
}

-(id)init
{
    self = [super init];
    if (self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendDidFinish:)
                                                     name:SHKSendDidFinishNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendDidFail:)
                                                     name:SHKSendDidFailWithErrorNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendDidCancel:)
                                                     name:SHKSendDidCancelNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendDidStart:)
                                                     name:SHKSendDidStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authDidFinish:)
                                                     name:SHKAuthDidFinishNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)notify:(NSString*)name useInfo:(NSDictionary*)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

-(void)notifyAuth:(BOOL)success :(NSString*)token
{
    if (token == nil) token = @"";
    NSDictionary* obj = @{@"kSocialIndex": @(_socType), @"kSocialAuthState": @(success), @"kSocialToken": token};
    [self notify:SocAuthDidFinishNotification useInfo:obj];
    if (_authHandler) _authHandler(success);
}

-(void)logout
{
    //[SHK logoutOfAll];
    [SHKVkontakte logout];
    //[SHKFacebook logout];
    [[FacebookManager facebook] logout];
    [[Livejournal livejournal] logout];

    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)auth:(SocType)socType complete:(SocAuthHandler)handler
{
    [self notify:SocAuthWillStartNotification useInfo:@{@"kSocialIndex": @(socType)}];
    
    _socType = socType;
    _authHandler = handler;
    
    if (_socType == FacebookSocType){
        [[FacebookManager facebook] autorizeWithHandler:^(BOOL success) {
            if (success){
                _username = [[FacebookManager facebook] username];
                _userpic = [[FacebookManager facebook] userpic];
            }          
            [self notifyAuth:success :[[FacebookManager facebook] token]];
        }];
    }
    if (_socType == VkontakteSocType){
        if ([SHKVkontakte isServiceAuthorized]){
            [self authCheck];
        }else{
            SHKSharer *service = [[SHKVkontakte alloc] init];
            [service authorize];
        }
    }
    if (_socType == LivejournalSocType){
        [[Livejournal livejournal]autorizeWithHandler:^(BOOL success) {
            if (success){
                _username = [[Livejournal livejournal] username];
                _userpic = [[Livejournal livejournal] userpic];
            }
            NSString* token = [_username stringByAppendingString:@".livejournal.com"];
            [self notifyAuth:success :token];
        }];
    }
}

-(void)authCheck
{
    NSLog(@"auth check");
    if (_socType == VkontakteSocType){
        if ([SHKVkontakte isServiceAuthorized]){
            _sendType = SendTypeVKGetUseInfo;
            [SHKVkontakte getUserInfo];
            return;
        }
    }
    [self notifyAuth:NO :@""];
}

-(void)shareItem:(ShareItem*)item
{
    NSDictionary* obj = @{@"kSocialIndex": @(_socType)};
    [self notify:SocSendWillStartNotification useInfo:obj];
    
    if (_socType == FacebookSocType){
        [[FacebookManager facebook] shareItem:item complete:^(BOOL success) {
            NSDictionary* obj = @{@"kSocialIndex": @(_socType), @"kSocialShareState": @(success)};
            [self notify:SocSendDidFinishNotification useInfo:obj];
            NSLog(@"fb share complete");
        }];
    }
    if (_socType == VkontakteSocType){
        _sendType = SendTypeVKShare;
        SHKItem* shkItem = [SHKItem text:item.text];
        shkItem.title = item.text;
        
        NSURL *url = [NSURL URLWithString:item.link];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        shkItem.image = img;
        shkItem.URL = url;
        shkItem.shareType = SHKShareTypeImage;
        [SHKVkontakte shareItem:shkItem];
    }
    if (_socType == LivejournalSocType){
        [[Livejournal livejournal] shareItem:item complete:^(BOOL success) {
            NSDictionary* obj = @{@"kSocialIndex": @(_socType), @"kSocialShareState": @(success)};
            [self notify:SocSendDidFinishNotification useInfo:obj];
            NSLog(@"lj share complete");
        }];
    }
}

-(void)sendDidFinish:(id)sender
{
    NSLog(@"send did finish");
    
    if (_sendType == SendTypeVKGetUseInfo){
        NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"kSHKVkontakteUserInfo"];
        NSLog(@"===>%@", userinfo);
        NSString *first_name = userinfo[@"first_name"];
        NSString *last_name = userinfo[@"last_name"];
        NSString *country = userinfo[@"country"];
        NSString *city = userinfo[@"city"];
        //NSString *photo = userinfo[@"photo"];
        NSString *photo_medium = userinfo[@"photo_medium"];
        _username = [NSString stringWithFormat:@"%@ %@",first_name, last_name];
        _userpic = photo_medium;
        _country = country;
        _city = city;
        
        NSString* token =[[NSUserDefaults standardUserDefaults] objectForKey:kSHKVkontakteAccessTokenKey];
        [self notifyAuth:YES :token];
    }
    
    if (_sendType == SendTypeVKShare){
        NSLog(@"vk share complete");
        NSDictionary* obj = @{@"kSocialIndex": @(_socType), @"kSocialShareState": @(YES)};
        [self notify:SocSendDidFinishNotification useInfo:obj];
    }

    _sendType = SendTypeNone;
}

-(void)sendDidFail:(id)sender
{
    NSLog(@"send did fail");

    _sendType = SendTypeNone;
}

-(void)sendDidStart:(id)sender
{
    NSLog(@"send did start");
}

-(void)sendDidCancel:(id)sender
{
    NSLog(@"send did cancel");
}

-(void)authDidFinish:(id)sender
{
    NSLog(@"auth did finish");
    
    [self performSelector:@selector(authCheck) withObject:nil afterDelay:0];
}

@end
