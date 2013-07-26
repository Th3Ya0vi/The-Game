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

-(void) authPlayerByToken:(NSString*)access_token
            bySocialIndex:(SocialIndex)socialIndex
                   byName:(NSString*)name
                  byEmail:(NSString*)email
                byCountry:(NSString*)country
                   byCity:(NSString*)city
               byPhotoUrl:(NSString*)photoUrl

{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:access_token forKey:kTGUserAccessTokenKey];
    [params setObject:[NSNumber numberWithInteger:socialIndex] forKey:kTGUserSocialIDKey];
    [params setObject:name forKey:kTGUserNameKey];
    [params setObject:name forKey:kTGUserEmailKey];
    [params setObject:name forKey:kTGUserCountryKey];
    [params setObject:name forKey:kTGUserCityKey];
    [params setObject:name forKey:kTGUserAvaKey];
    
    [[UpdateManager sharedInstance] addOperationPostJSONByURL:kTGPlayerUrl params:params itSession:kTGPlayerConnect withSuccessOperation:^(LRRestyResponse *response) {
        //
    } andFailedOperation:^(LRRestyResponse *response) {
        //
    }];
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
