//
//  flashcardsAppDelegate.h
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface flashcardsAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//database path
@property (strong, nonatomic)NSString *databasename;
@property (strong, nonatomic)NSString *databasepath;
@property (strong, nonatomic)NSArray *documentPaths;
@property (strong, nonatomic)NSString *documentsDir;
@property (strong, nonatomic)NSFileManager *appdelfilemanager;

@end
