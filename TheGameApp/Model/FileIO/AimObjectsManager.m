//
//  AimObjectsManager.m
//  TheGameApp
//
//  Created by DenisDbv on 05.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "AimObjectsManager.h"
#import "AimObject.h"

@interface AimObjectsManager()
@property (nonatomic, retain) NSString *_accessHandler;
@property (nonatomic, retain) NSMutableArray *aimObjectsArray;
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
    if(aimObjectsArray.count == 0) {
        aimObjectsArray = [[NSMutableArray alloc] init];
        return NO;
    }
    
    return YES;
}

-(BOOL) addAimObject:(AimObject*)aimObject toIndex:(NSInteger)index
{
    if(index >= aimObjectsArray.count)
        [aimObjectsArray addObject:aimObject];
    else
        [aimObjectsArray replaceObjectAtIndex:index withObject:aimObject];
    
    return [[self class] saveArhiveFromObject:aimObjectsArray toFile:_accessHandler];
}

-(AimObject*) aimObjectByIndex:(NSInteger)index
{
    if(index >= aimObjectsArray.count)  {
        return [AimObject new];
    }
    else    {
        return [aimObjectsArray objectAtIndex:index];
    }
}

@end
