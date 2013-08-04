//
//  AimObjectsManager.m
//  TheGameApp
//
//  Created by DenisDbv on 05.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "AimObjectsManager.h"

@interface AimObjectsManager()
@property (nonatomic, retain) NSString *_accessHandler;
@end

@implementation AimObjectsManager
@synthesize aimObjectsArray;
@synthesize _accessHandler;

+ (id)sharedInstance
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}

-(id) init
{
    aimObjectsArray = [[NSMutableArray alloc] init];
    
    return [super init];
}

-(BOOL) setFileHandler:(NSString*)accessHandler
{
    _accessHandler = [accessHandler copy];
    
    return [self updateDataFromFileHandler];
}

-(BOOL) updateDataFromFileHandler
{
    aimObjectsArray = [[self class] unarhiveObjectFromFile:_accessHandler];
    if(aimObjectsArray.count == 0) return NO;
    
    return YES;
}

-(BOOL) addAimObject:(AimObject*)aimObject
{
    [aimObjectsArray addObject:aimObject];
    
    return [[self class] saveArhiveFromObject:aimObjectsArray toFile:_accessHandler];
}

@end
