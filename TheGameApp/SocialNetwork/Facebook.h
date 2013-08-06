//
//  Facebook.h
//  SocialClient
//
//  Created by Admin on 21.07.13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareItem.h"

typedef void (^FBCompleteHandler)(BOOL success);

@interface FacebookManager : NSObject

@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* userpic;

+(id)facebook;

-(NSString*)token;

-(void)logout;

-(void)autorizeWithHandler:(FBCompleteHandler)handler;

-(void)shareItem:(ShareItem*)item complete:(FBCompleteHandler)handler;

@end
