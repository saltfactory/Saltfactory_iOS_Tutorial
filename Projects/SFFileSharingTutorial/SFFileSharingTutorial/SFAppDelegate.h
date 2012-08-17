//
//  SFAppDelegate.h
//  SFFileSharingTutorial
//
//  Created by SungKwang Song on 8/17/12.
//  Copyright (c) 2012 saltfactory.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
