//
//  URLPostOperation.m
//  TheGameApp
//
//  Created by DenisDbv on 21.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "URLPostOperation.h"

@implementation URLPostOperation
{
    SuccessBlockDownloader successBlockDownloader;
    FailedBlockDownloader failedBlockDownloader;
}

@synthesize url = _url;
@synthesize param = _param;

- (id)initWithUrlString:(NSString *)urlPath
               andParam:(NSDictionary*)params
       withSuccessBlock:(SuccessBlockDownloader) succesBlock
         andFailedBlock:(FailedBlockDownloader) failedBlock
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _url = [urlPath copy];
    _param = [params copy];
    successBlockDownloader = [succesBlock copy];
    failedBlockDownloader = [failedBlock copy];
    
    _isExecuting = NO;
    _isFinished = NO;
    
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
    NSLog(@"<UpdateManager> Post opeartion for <%@> started.", _url);
    
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self entryJSONToUrl:_url param:_param];
}

- (void)finish
{
    NSLog(@"<UpdateManager> Post operation for <%@> finished. ", _url);
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

-(void) entryJSONToUrl:(NSString*)urlString param:(NSDictionary*)parameters
{
    [[LRResty client] post:urlString payload:parameters headers:nil withBlock:^(LRRestyResponse *response) {
        if(response.status == 200)  {
            
            NSLog(@"-->%@", response.description);
            [self finish];
            successBlockDownloader(response);
        }
        else
        {
            NSLog(@"ERROR POST: %@", response.asString);
            [self finish];
            failedBlockDownloader();
        }
    }];
}

@end
