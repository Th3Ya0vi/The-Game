//
//  PlayerManager.h
//  TheGameApp
//
//  Created by DenisDbv on 21.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "UpdateManager.h"

@interface PlayerManager : UpdateManager <ABMultitonProtocol>

-(void) authPlayerByToken:(NSString*)access_token
            bySocialIndex:(SocialIndex)socialIndex
                   byName:(NSString*)name
                  byEmail:(NSString*)email
                byCountry:(NSString*)country
                   byCity:(NSString*)city
               byPhotoUrl:(NSString*)photoUrl;

-(void) uploadBinaryFile;

@end
