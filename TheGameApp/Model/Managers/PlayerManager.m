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

-(void) connectPlayer
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1234567" forKey:@"access_token"];
    [params setObject:@"dd@m.ru" forKey:@"email"];
    [params setObject:@"DD" forKey:@"name"];
    
    [[UpdateManager sharedInstance] addOperationPostJSONByURL:kTGPlayerUrl params:params itSession:kTGPlayerConnect];
}

-(void) listOfPlayers
{
    [[UpdateManager sharedInstance] addOperationDownloadingJSONByURL:kTGPlayerUrl itSession:kTGPlayerGetList];
}

@end
