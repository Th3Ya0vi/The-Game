//
//  Notifications.h
//  MoreShowApp
//
//  Created by DenisDbv on 10.06.13.
//  Copyright (c) 2013 DenisDbv. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Notifications are identified by global NSString objects whose names are composed in this way:
 [Name of associated class] + [Did | Will] + [UniquePartOfName] + Notification
 */

extern NSString *const didUploadAllServerSessionNotification;

extern NSString *const willUploadServerSessionNotification;

extern NSString *const didUploadServerSessionNotification;
