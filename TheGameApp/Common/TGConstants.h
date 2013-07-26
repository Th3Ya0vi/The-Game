//
//  TGConstants.h
//  TheGameApp
//
//  Created by DenisDbv on 21.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#pragma mark - API
#pragma mark Players

typedef enum {
    kTGPlayerConnect = 1,
    kTGPlayerGetList,
    kTGImageUpload,
    kTGVideoUpload
} ServerSessionsList;

typedef enum {
    kTGSocialFacebookIndex = 1,
    kTGSocialVKIndex,
    kTGLivejournalIndex
} SocialIndex;

// Ключи для словаря информации пользователя при регистрации
extern NSString *const kTGUserNameKey;
extern NSString *const kTGUserEmailKey;
extern NSString *const kTGUserCountryKey;
extern NSString *const kTGUserCityKey;
extern NSString *const kTGUserAvaKey;
extern NSString *const kTGUserAccessTokenKey;
extern NSString *const kTGUserSocialIDKey;

// Ключи сессий для нотификации о начале/завершении скачивания/отсылки данных из/в бакенд
extern NSString *const kTGSessionNameKey;
extern NSString *const kTGSessionStatusKey;

// API
extern NSString *const kTGHostName;
extern NSString *const kTGPlayerUrl;
extern NSString *const kTGImageUploadUrl;
