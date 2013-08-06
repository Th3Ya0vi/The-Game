//
//  AimObject.m
//  TheGameApp
//
//  Created by DenisDbv on 05.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "AimObject.h"

@implementation AimObject
@synthesize aimDescription, aimTitle, aimPhoto;

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.aimDescription = [aDecoder decodeObjectForKey:@"aimDescription"];
        self.aimTitle = [aDecoder decodeObjectForKey:@"aimTitle"];
        self.aimPhoto = [aDecoder decodeObjectForKey:@"aimPhoto"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.aimDescription forKey:@"aimDescription"];
    [aCoder encodeObject:self.aimTitle forKey:@"aimTitle"];
    [aCoder encodeObject:self.aimPhoto forKey:@"aimPhoto"];
}

@end
