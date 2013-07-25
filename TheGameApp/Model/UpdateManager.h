//
//  UpdateManager.h
//  TheGameApp
//
//  Created by DenisDbv on 21.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ABMultiton/ABMultiton.h>
#import <ABMultiton/ABMultitonProtocol.h>
#import <LRResty/LRResty.h>

typedef void (^SuccessOperation)(LRRestyResponse *response);
typedef void (^FailedOperation)(LRRestyResponse *response);

@interface UpdateManager : NSObject <ABMultitonProtocol>
{
    NSOperationQueue * _queueReceive;
    NSOperationQueue * _queueEntry;
    NSOperationQueue * _queueEntryData;
}

-(void) addOperationDownloadingJSONByURL:(NSString*)url
                               itSession:(ServerSessionsList)sessionID
                                withSuccessOperation:(SuccessOperation) succesOperaion
                                andFailedOperation:(FailedOperation) failedOperation;

-(void) addOperationPostJSONByURL:(NSString*)url params:(NSDictionary*)params
                        itSession:(ServerSessionsList)sessionID
                        withSuccessOperation:(SuccessOperation) succesOperaion
                        andFailedOperation:(FailedOperation) failedOperation;

-(void) addOperationPostDataByURL:(NSString*)url
                           params:(id)data
                          headers:(id)header
                        itSession:(ServerSessionsList)sessionID
             withSuccessOperation:(SuccessOperation) succesOperaion
               andFailedOperation:(FailedOperation) failedOperation;

@end
