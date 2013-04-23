//
//  flashcardsFirstViewController.h
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface flashcardsFirstViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *txtListName;
- (IBAction)btnSave:(id)sender;
-(IBAction) doneEditing:(id) sender;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollview;

@end
