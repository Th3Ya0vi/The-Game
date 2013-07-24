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

-(void) addOperationDownloadingJSONByURL:(NSString*)url
                               itSession:(ServerSessionsList)sessionID
                    withSuccessOperation:(SuccessOperation) succesOperaion
                      andFailedOperation:(FailedOperation) failedOperation
{
    NSMutableDictionary *notifyParam = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:sessionID], kTGSessionNameKey, nil];
    
    [self raiseNotification:willUploadServerSessionNotification WithObject:notifyParam];
        
    URLDownloaderOperation * operation = [[URLDownloaderOperation alloc] initWithUrlString:url withSuccessBlock:^(LRRestyResponse *response) {
        
        [notifyParam setObject:[NSNumber numberWithBool:YES] forKey:kTGSessionStatusKey];
        [self raiseNotification:didUploadServerSessionNotification WithObject:notifyParam];
        
        succesOperaion(response);
        
        //JSONKit
        //NSDictionary *resultJSON = [[response asString] objectFromJSONString];
        //NSLog(@"=>%@", resultJSON);
        
    } andFailedBlock:^(LRRestyResponse *response){
        [notifyParam setObject:[NSNumber numberWithBool:NO] forKey:kTGSessionStatusKey];
        [self raiseNotification:didUploadServerSessionNotification WithObject:notifyParam];
        
        failedOperation(response);
    }];
    
    [_queueReceive addOperation:operation];
}

-(void) addOperationPostJSONByURL:(NSString*)url params:(NSDictionary*)params
                        itSession:(ServerSessionsList)sessionID
             withSuccessOperation:(SuccessOperation) succesOperaion
               andFailedOperation:(FailedOperation) failedOperation
{
    NSMutableDictionary *notifyParam = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:sessionID], kTGSessionNameKey, nil];
    
    [self raiseNotification:willUploadServerSessionNotification WithObject:notifyParam];
    
    URLPostOperation * operation = [[URLPostOperation alloc] initWithUrlString:url andParam:params withSuccessBlock:^(LRRestyResponse *response) {
        
        [notifyParam setObject:[NSNumber numberWithBool:YES] forKey:kTGSessionStatusKey];
        [self raiseNotification:didUploadServerSessionNotification WithObject:notifyParam];
        
        //JSONKit
        //NSDictionary *resultJSON = [[response asString] objectFromJSONString];
        //NSLog(@"->%@", resultJSON);
        
    } andFailedBlock:^(LRRestyResponse *response){
        [notifyParam setObject:[NSNumber numberWithBool:NO] forKey:kTGSessionStatusKey];
        [self raiseNotification:didUploadServerSessionNotification WithObject:notifyParam];
        
        failedOperation(response);
    }];
    
    [_queueReceive addOperation:operation];
}

@end
