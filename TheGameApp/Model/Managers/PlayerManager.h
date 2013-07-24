//
//  PlayerManager.h
//  TheGameApp
//
//  Created by DenisDbv on 21.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "UpdateManager.h"

@interface PlayerManager : UpdateManager <ABMultitonProtocol>

- (void) authPlayer;
-(void) listOfPlayers;

@end
