//
//  NSObject+NotifyHelper.m
//  HRExpertApp
//
//  Created by DenisDbv on 06.12.12.
//  Copyright (c) 2012 DenisDbv. All rights reserved.
//

#import "NSObject+NotifyHelper.h"

@implementation NSObject (NotifyHelper)

-(void)addNotification:(NSString*)notificationName
{
    NSString* selStr = [NSString stringWithFormat:@"on%@:",notificationName];
    SEL sel = NSSelectorFromString(selStr);
    assert([self respondsToSelector:sel]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:sel
                                                 name:notificationName object:nil];
}

-(void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)raiseNotification:(NSString*)notificationName
{
    [self raiseNotification:notificationName WithObject:nil];
}

-(void)raiseNotification:(NSString*)notificationName WithObject:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:object];
}

@end
