//
//  createTestViewController.h
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//
//Called from the 'Add Word List' button
#import <UIKit/UIKit.h>

@interface createTestViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *txtListName;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollview;
-(IBAction)btnSave:(id)sender;
-(IBAction)doneEditing:(id)sender;

@end
