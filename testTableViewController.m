//
//  testTableViewController.m
//  flashcards
//
//  Created by Thomas Kinser on 4/26/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//
/*#import "testTableViewController.h"

@interface testTableViewController ()

@end

@implementation testTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
*/
#import "testTableViewController.h"
#import "flashcardsSecondViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface testTableViewController ()
{
    NSMutableArray *_objects;
}
@end

@implementation testTableViewController

@synthesize TableView;

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    listOfData = [[NSMutableArray alloc] init];
    listOfNameID = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cards.sqlite"];
    NSLog(@"SelectList ViewController Path: %@",path);
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    // Do any additional setup after loading the view, typically from a nib.
    FMResultSet *results = [database executeQuery:@"select * from FlashName"];
    NSLog(@"SelectList ViewController - While Loop Start");
    while([results next])
    {
        NSString *Nameid = [results stringForColumn:@"NameID"] ;
        NSString *title = [results stringForColumn:@"title"] ;
        NSString *StrTitles =  [NSString stringWithFormat:@"ID:%@  --- %@", Nameid, title];
        NSLog(@"SelectList ViewController Titles: %@",StrTitles);
        [listOfNameID addObject:Nameid];
        [listOfData addObject:StrTitles];
    }
    NSLog(@"SelectList ViewController - While Loop Done");
    [results close]; //VERY IMPORTANT!
    [database close];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// Not sure why this is here and return is set for 1
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"SelectList ViewController - Start NSInteger");
    return 1;
}


// Mandatory for the UITableViewDataSource Protocol per page 168.  Returns the number of rows in the section.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listOfData count];
    NSLog(@"SelectList ViewController - Stop NSInteger");
}

// Mandatory for the UITableViewDataSource Protocol per page 168.  Insert individual row into table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // Try to get a reusable cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Create new cell if no reusable cell is available
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc]
                initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellIdentifier]
                autorelease];
    }
    // Set the text to display for the cell
    cell.textLabel.text = [listOfData objectAtIndex:[indexPath row]];
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SelectList ViewController tableView Section Row Selected = %i",indexPath.row);
    
}

// Sends control to external storyboard.  Modal connection must be made on the storyboard|viewController|cell to that external storyboard
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try
    {
        [segue.destinationViewController  setNameID:[listOfNameID objectAtIndex:[self.tableView.indexPathForSelectedRow row]]];
        NSLog(@"SelectList ViewController @try section - prepareForSegue");
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception.reason);
    }
}

- (void)dealloc {
    [UITableView release];
    [super dealloc];
}

@end
