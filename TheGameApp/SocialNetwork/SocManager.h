//
//  VKManager.h
//  SocialClient
//
//  Created by Admin on 18.07.13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareItem.h"

extern NSString * const SocSendWillStartNotification;
extern NSString * const SocSendDidFinishNotification;
extern NSString * const SocAuthWillStartNotification;
extern NSString * const SocAuthDidFinishNotification;

typedef enum
{
    FacebookSocType,
    VkontakteSocType,
    LivejournalSocType
} SocType;

typedef void (^SocAuthHandler)(BOOL success);

@interface SocManager : NSObject

@property (nonatomic, readonly, copy) NSString* username;
@property (nonatomic, readonly, copy) NSString* userpic;

+(id)sharedManager;

-(void)auth:(SocType)socType complete:(SocAuthHandler)handler;

-(void)shareItem:(ShareItem*)item;

-(void)logout;

@end
