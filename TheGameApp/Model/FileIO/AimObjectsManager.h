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

-(BOOL) setFileHandler:(NSString*)accessHandler;
-(BOOL) addAimObject:(AimObject*)aimObject toIndex:(NSInteger)index;
-(AimObject*) aimObjectByIndex:(NSInteger)index;

@end
