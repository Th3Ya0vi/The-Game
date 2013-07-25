//
//  URLPostOperation.h
//  TheGameApp
//
//  Created by DenisDbv on 21.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <LRResty/LRResty.h>
#import <JSONKit/JSONKit.h>

typedef void (^SuccessBlockDownloader)(LRRestyResponse *response);
typedef void (^FailedBlockDownloader)(LRRestyResponse *response);

@interface URLPostOperation : NSOperation
{
    NSString *url;
    id param;
    id header;
    
    BOOL _isExecuting;
    BOOL _isFinished;
}

@property (readonly, copy) NSString *url;
@property (readonly, copy) id param;
@property (readonly, copy) id header;

@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;

- (id)initWithUrlString:(NSString *)urlPath
               andParam:(id)params
              andHeader:(id)headers
       withSuccessBlock:(SuccessBlockDownloader) succesBlock
         andFailedBlock:(FailedBlockDownloader) failedBlock;

@end
