//
//  URLDownloaderOperation.h
//  MoreShowApp
//
//  Created by DenisDbv on 12.06.13.
//  Copyright (c) 2013 DenisDbv. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <LRResty/LRResty.h>
#import <JSONKit/JSONKit.h>

typedef void (^SuccessBlockDownloader)(LRRestyResponse *response);
typedef void (^FailedBlockDownloader)(void);

@interface URLDownloaderOperation : NSOperation
{
    NSString *url;
    
    BOOL _isExecuting;
    BOOL _isFinished;
}

@property (readonly, copy) NSString *url;

@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;

- (id)initWithUrlString:(NSString *)urlPath
       withSuccessBlock:(SuccessBlockDownloader) succesBlock
         andFailedBlock:(FailedBlockDownloader) failedBlock;

@end
