//
//  Livejournal.h
//  SocialClient
//
//  Created by Admin on 19.07.13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareItem.h"
#import "XMLRPC.h"



@interface LJInfo : NSObject
@property (nonatomic, copy) NSString* login;
@property (nonatomic, copy) NSString* pass;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* userpic;
@end



@interface XMLRPCHelper : NSObject<XMLRPCConnectionDelegate>

@end


typedef void (^AuthHandler)(LJInfo* info);

@interface LJAuth : XMLRPCHelper
-(void)auth:(NSString*)login pass:(NSString*)pass complete:(AuthHandler)handler;
@end


typedef void (^CompleteHandler)(BOOL success);

@interface Livejournal : NSObject

@property (nonatomic, copy) NSString* login;
@property (nonatomic, copy) NSString* pass;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* userpic;

+(id)livejournal;

-(void)logout;

-(void)autorizeWithHandler:(CompleteHandler)handler;

-(void)shareItem:(ShareItem*)item complete:(CompleteHandler)handler;

-(void)onAuthSuccess:(LJInfo*)info;

@end
