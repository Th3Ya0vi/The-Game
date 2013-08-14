//
//  AppDelegate.h
//  TheGameApp
//
//  Created by DenisDbv on 21.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *rootNavController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) int networkStatus;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)presentLoginViewControllerAnimated:(BOOL)animated;
- (void)presentAimWizardViewControllerAnimated:(BOOL)animated;
- (void)presentRootTabBarController;

@end
