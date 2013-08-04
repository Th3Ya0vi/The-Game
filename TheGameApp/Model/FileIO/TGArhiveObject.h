//
//  TGArhiveObject.h
//  TheGameApp
//
//  Created by DenisDbv on 05.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGArhiveObject : NSObject

+ (BOOL) saveArhiveFromObject:(id)object toFile:(NSString*)fileName;
+ (id) unarhiveObjectFromFile:(NSString*)fileName;

@end
