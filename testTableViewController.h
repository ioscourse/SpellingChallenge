//
//  testTableViewController.h
//  flashcards
//
//  Created by Thomas Kinser on 4/26/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//
/* Original code
#import <UIKit/UIKit.h>

@interface testTableViewController : UIViewController

@end
*/
#import <UIKit/UIKit.h>

@interface testTableViewController : UITableViewController
{
    //Declare Arrays
    NSMutableArray *listOfData;
    NSMutableArray *listOfNameID;
}

@property (retain, nonatomic) IBOutlet UITableView *TableView;
@end