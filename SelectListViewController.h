//
//  SelectListViewController.h
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectListViewController : UITableViewController
{
    //Declare Arrays
    NSMutableArray *listOfData;
     NSMutableArray *listOfNameID;
}
@property (retain, nonatomic) IBOutlet UITableView *TableView;

@end
