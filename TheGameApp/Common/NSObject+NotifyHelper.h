//
//  NSObject+NotifyHelper.h
//  HRExpertApp
//
//  Created by DenisDbv on 06.12.12.
//  Copyright (c) 2012 DenisDbv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NotifyHelper)

-(void)addNotification:(NSString*)notificationName;
-(void)removeNotifications;
-(void)raiseNotification:(NSString*)notificationName;
-(void)raiseNotification:(NSString*)notificationName WithObject:(id)object;

@end