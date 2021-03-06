//
//  AppDelegate.m
//  TheGameApp
//
//  Created by DenisDbv on 21.07.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "AppDelegate.h"
#import <Reachability/Reachability.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <AKTabBarController/AKTabBarController.h>

#import "TGWelcomeViewController.h"
#import "TGLoginViewController.h"
#import "PreWizardAimController.h"

#import "RootGameViewController.h"
#import "RootMessagesViewController.h"
#import "RootAddReportViewController.h"
#import "RootSbscrViewController.h"
#import "RootProfileViewController.h"

#import "MySHKConfigurator.h"
#import "SHKConfiguration.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate ()

@property (nonatomic, strong) TGWelcomeViewController *welcomeViewController;
@property (nonatomic, strong) PreWizardAimController *wizardViewController;
@property (nonatomic, strong) AKTabBarController *rootTabBarController;

@property (nonatomic, strong) RootGameViewController *rootGameVC;
@property (nonatomic, strong) RootMessagesViewController *rootMessagesVC;
@property (nonatomic, strong) RootAddReportViewController *rootAddReportVC;
@property (nonatomic, strong) RootSbscrViewController *rootSubscriptionVC;
@property (nonatomic, strong) RootProfileViewController *rootProfileVC;

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;

@end

@implementation AppDelegate

@synthesize welcomeViewController;
@synthesize wizardViewController;
@synthesize rootTabBarController;

@synthesize rootGameVC, rootMessagesVC, rootAddReportVC, rootSubscriptionVC, rootProfileVC;

@synthesize hostReach;
@synthesize internetReach;
@synthesize wifiReach;
@synthesize networkStatus;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DefaultSHKConfigurator *configurator = [[MySHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self setupAppearance];
    [self monitorReachability];
    
    //[[PlayerManager sharedInstance] uploadBinaryFile];
    
    self.welcomeViewController = [[TGWelcomeViewController alloc] init];
    
    self.rootNavController = [[UINavigationController alloc] initWithRootViewController:self.welcomeViewController];
    self.rootNavController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.rootNavController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                UITextAttributeTextColor: [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0],
                          UITextAttributeTextShadowColor: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4],
                         UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0.0f, 0.5f)]
     }];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
    /*  [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"toolbar-back-icon@2x.png"]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];*/
}

- (void)monitorReachability {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostname: @"thegame.radanisk.com"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}

- (void)reachabilityChanged:(NSNotification* )note {
    Reachability *curReach = (Reachability *)[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NSLog(@"Reachability changed: %@", curReach);
    networkStatus = [curReach currentReachabilityStatus];
    
    NSLog(@"Network status:%i", networkStatus);
    
    /*MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = @"Some message...";
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
    
	[hud hide:YES afterDelay:3];*/
}

- (void)presentLoginViewControllerAnimated:(BOOL)animated {
    TGLoginViewController *loginViewController = [[TGLoginViewController alloc] init];
    self.welcomeViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.welcomeViewController presentModalViewController:loginViewController animated:animated];
}

- (void)presentAimWizardViewControllerAnimated:(BOOL)animated   {
    wizardViewController = [[PreWizardAimController alloc] init];
    
    self.rootNavController.viewControllers = @[self.welcomeViewController, wizardViewController];
    self.rootNavController.visibleViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.rootNavController dismissViewControllerAnimated:YES completion:nil];
    //[self.welcomeViewController presentModalViewController:[[UINavigationController alloc] initWithRootViewController:wizardViewController] animated:animated];
}

- (void)presentRootTabBarController
{
    rootTabBarController = [[AKTabBarController alloc] initWithTabBarHeight:50];
    [rootTabBarController setMinimumHeightToDisplayTitle:40.0];
    
    rootGameVC = [[RootGameViewController alloc] init];
    rootMessagesVC = [[RootMessagesViewController alloc] init];
    rootAddReportVC = [[RootAddReportViewController alloc] init];
    rootSubscriptionVC = [[RootSbscrViewController alloc] init];
    rootProfileVC = [[RootProfileViewController alloc] init];
    
    UINavigationController *navigationRootGameVC = [[UINavigationController alloc] initWithRootViewController:rootGameVC];
    UINavigationController *navigationRootMessagesVC = [[UINavigationController alloc] initWithRootViewController:rootMessagesVC];
    UINavigationController *navigationRootAddReportVC = [[UINavigationController alloc] initWithRootViewController:rootAddReportVC];
    UINavigationController *navigationRootSubscriptionVC = [[UINavigationController alloc] initWithRootViewController:rootSubscriptionVC];
    UINavigationController *navigationRootProfileVC = [[UINavigationController alloc] initWithRootViewController:rootProfileVC];
    
    [rootTabBarController setViewControllers:[NSMutableArray arrayWithObjects:
                                              navigationRootGameVC,
                                              navigationRootMessagesVC,
                                              navigationRootAddReportVC,
                                              navigationRootSubscriptionVC,
                                              navigationRootProfileVC,
                                              nil]];
    
    self.rootNavController.viewControllers = @[self.welcomeViewController, rootTabBarController];
    [self.rootNavController dismissViewControllerAnimated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [FBSession.activeSession close];
    
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TheGameApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TheGameApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
