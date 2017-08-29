//
//  AppDelegate.h
//  RoastChicken
//
//  Created by andrew glew on 20/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "dbManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSString *apikey;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property BOOL restrictRotation;

- (void)saveContext;


@end

