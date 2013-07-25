//
//  PlayerManager.m
//  TheGameApp
//
//  Created by DenisDbv on 21.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "PlayerManager.h"

@implementation PlayerManager

+ (id)sharedInstance
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}

-(id) init
{
    return [super init];
}

-(void) authPlayer
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:43210] forKey:@"access_token"];
    [params setObject:@"dd@m.ru" forKey:@"email"];
    [params setObject:@"DD" forKey:@"name"];
    
    [[UpdateManager sharedInstance] addOperationPostJSONByURL:kTGPlayerUrl params:params itSession:kTGPlayerConnect withSuccessOperation:^(LRRestyResponse *response) {
        //
    } andFailedOperation:^(LRRestyResponse *response) {
        //
    }];
}

-(void) listOfPlayers
{
    //[[UpdateManager sharedInstance] addOperationDownloadingJSONByURL:kTGPlayerUrl itSession:kTGPlayerGetList];
}

-(void) uploadBinaryFile
{
    UIImage *testImage = [UIImage imageNamed:@"login-background@2x.png"];
    
    NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSDictionary *requestHeaders = [NSDictionary
                                    dictionaryWithObject: contentType forKey:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    [body appendData:[@"Content-Disposition: form-data; name=\"data\"; filename=\"picture.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation(testImage)]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [[UpdateManager sharedInstance] addOperationPostDataByURL:kTGImageUploadUrl params:body headers:requestHeaders itSession:kTGImageUpload withSuccessOperation:^(LRRestyResponse *response)
    {
        NSLog(@"SUCCESS: %@", response.asString);
    } andFailedOperation:^(LRRestyResponse *response) {
        NSLog(@"ERROR: %@", response.asString);
    }];
}

@end
