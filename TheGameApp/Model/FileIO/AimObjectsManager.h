//
//  AimObjectsManager.h
//  TheGameApp
//
//  Created by DenisDbv on 05.08.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TGArhiveObject.h"
#import "ABMultiton.h"
#import "ABMultitonProtocol.h"
#import "AimObject.h"

@interface AimObjectsManager : TGArhiveObject <ABMultitonProtocol>

@property (readonly, retain) NSMutableArray *aimObjectsArray;

-(BOOL) setFileHandler:(NSString*)accessHandler;
-(BOOL) addAimObject:(AimObject*)aimObject;

@end
