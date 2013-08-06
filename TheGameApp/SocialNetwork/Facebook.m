//
//  Facebook.m
//  SocialClient
//
//  Created by Admin on 21.07.13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "Facebook.h"
#import <FacebookSDK/FacebookSDK.h>

typedef enum
{
    NoneOp,
    AuthOp,
    ShareOp
} Operation;


@implementation FacebookManager
{
    FBCompleteHandler _handler;
    Operation _op;
    BOOL _secondTry;
}

+(id)facebook
{
    static FacebookManager* x;
    if (x ==nil) x = [[FacebookManager alloc]init];
    return x;
}

-(void)autorizeWithHandler:(FBCompleteHandler)handler
{
    _handler = handler;
    _op = AuthOp;
    _secondTry = NO;
    [self auth];
}

-(void)auth
{
    FBSession* session = [[FBSession alloc]initWithPermissions:@[@"publish_actions"]];
    [FBSession setActiveSession:session];
    [session openWithBehavior:FBSessionLoginBehaviorForcingWebView
            completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
    }];
}

-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    if (_op == AuthOp){
        if (error != nil){
            NSLog(@"error %@", error);
            if (_secondTry){
                [self opComplete:NO];
            }else{
                id code = [error userInfo][FBErrorParsedJSONResponseKey][@"body"][@"error"][@"code"];
                if (code != nil && [code isKindOfClass:[NSNumber class]] && [code compare:@190] == NSOrderedSame){
                    _secondTry = YES;
                    [self auth];
                }else{
                    [self opComplete:NO];
                }
            }
        }else{
            NSLog(@"token %@", session.accessTokenData.accessToken);
            
            if (!FBSession.activeSession.isOpen){
                [self opComplete:NO];
            }else{
                [self getUserInfo];
            }
        }
    }
}

-(void)getUserInfo
{
    NSLog(@"get user info");
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error != nil){
            NSLog(@"error %@", error);
            [self opComplete:NO];
        }else{
            NSLog(@"user info %@", result);
            _username = result[@"name"];
            _userpic = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",result[@"id"]];
            [self opComplete:YES];
        }
    }];
}

-(void)opComplete:(BOOL)success
{
    _op = NoneOp;
    if (_handler) _handler(success);
    _handler = nil;
}

-(void)shareItem:(ShareItem*)item complete:(FBCompleteHandler)handler
{
    _op = ShareOp;
    _handler = handler;
    [self shareItem:item];
}

-(void)shareItem:(ShareItem*)item
{
    assert([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] != NSNotFound);

	NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //[params setObject:item.link forKey:@"link"];
    [params setObject:item.title forKey:@"name"];
    [params setObject:item.text forKey:@"message"];
    [params setObject:item.link forKey:@"picture"];
    //[params setObject:@"post description" forKey:@"description"];
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (error != nil){
                                  NSLog(@"error %@", error);
                                  [self opComplete:NO];
                              }else{
                                  NSLog(@"share complete %@", result);
                                  [self opComplete:YES];
                              }
                          }];
}

-(void)logout
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

-(NSString*)token
{
    return [FBSession activeSession].accessTokenData.accessToken;
}

@end
