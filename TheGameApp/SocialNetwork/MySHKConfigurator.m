//
//  MySHKConfigurator.m
//  SocialClient
//
//  Created by Admin on 18.07.13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "MySHKConfigurator.h"

@implementation MySHKConfigurator

- (NSNumber *)isUsingCocoaPods {
    return [NSNumber numberWithBool:YES];
}

-(NSString *)vkontakteAppId
{
    return @"3176154";
}

-(NSNumber *)allowAutoShare
{
    return [NSNumber numberWithBool:true];
}

@end
