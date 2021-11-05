//
//  AppDelegate.h
//  iTerrian
//
//  Created by Nicholas Krzemienski on 10/14/12.
//  Copyright (c) 2012 Nicholas Krzemienski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TerrainModelViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) UINavigationController *navCtrl;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
