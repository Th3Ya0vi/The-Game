//
//  UpdateManager.m
//  TheGameApp
//
//  Created by DenisDbv on 21.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "UpdateManager.h"
#import "URLDownloaderOperation.h"
#import "URLPostOperation.h"

@implementation UpdateManager

+ (id)sharedInstance
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}

-(id) init
{
    _queueReceive = [[NSOperationQueue alloc] init];
    [_queueReceive setMaxConcurrentOperationCount:1];
    
    _queueEntry = [[NSOperationQueue alloc] init];
    [_queueEntry setMaxConcurrentOperationCount:1];
    
    return [super init];
}

-(void) addOperationDownloadingJSONByURL:(NSString*)url itSession:(ServerSessionsList)sessionID
{
    NSDictionary *notifyParam = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:sessionID], @"session", nil];
    
    [self raiseNotification:willUploadServerSessionNotification WithObject:notifyParam];
        
    URLDownloaderOperation * operation = [[URLDownloaderOperation alloc] initWithUrlString:url withSuccessBlock:^(LRRestyResponse *response) {
        
        [self raiseNotification:didUploadServerSessionNotification WithObject:notifyParam];
        
        //JSONKit
        NSDictionary *resultJSON = [[response asString] objectFromJSONString];
        
        NSLog(@"=>%@", resultJSON);
        
    } andFailedBlock:^{
        [self raiseNotification:didUploadServerSessionNotification WithObject:notifyParam];
    }];
    
    [_queueReceive addOperation:operation];
}

-(void) addOperationPostJSONByURL:(NSString*)url params:(NSDictionary*)params itSession:(ServerSessionsList)sessionID
{
    NSDictionary *notifyParam = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:sessionID], @"session", nil];
    
    [self raiseNotification:willUploadServerSessionNotification WithObject:notifyParam];
    
    URLPostOperation * operation = [[URLPostOperation alloc] initWithUrlString:url andParam:params withSuccessBlock:^(LRRestyResponse *response) {
        
        [self raiseNotification:didUploadServerSessionNotification WithObject:notifyParam];
        
        //JSONKit
        NSDictionary *resultJSON = [[response asString] objectFromJSONString];
        
        NSLog(@"->%@", resultJSON);
        
    } andFailedBlock:^{
        NSLog(@"ERROR");
        [self raiseNotification:didUploadServerSessionNotification WithObject:notifyParam];
    }];
    
    [_queueReceive addOperation:operation];
}

@end
