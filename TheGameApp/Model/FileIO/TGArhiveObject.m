//
//  TGArhiveObject.m
//  TheGameApp
//
//  Created by DenisDbv on 05.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TGArhiveObject.h"
#import <HRCoder/HRCoder.h>

@implementation TGArhiveObject

+ (NSString *)documentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (BOOL) saveArhiveFromObject:(id)object toFile:(NSString*)fileName
{
    NSString *path = [[[self class] documentsDirectory] stringByAppendingPathComponent: fileName];
	return [HRCoder archiveRootObject:object toFile:path];
}

+ (id) unarhiveObjectFromFile:(NSString*)fileName
{
    NSString *path = [[self documentsDirectory] stringByAppendingPathComponent:fileName];
    return [HRCoder unarchiveObjectWithFile:path];
}

@end
