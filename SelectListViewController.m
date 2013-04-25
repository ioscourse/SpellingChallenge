//
//  SelectListViewController.m
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//
//Called from the 'Play Word Game' button.
#import "SelectListViewController.h"
#import "flashcardsSecondViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface SelectListViewController ()
{
    NSMutableArray *_objects;
}
@end

@implementation SelectListViewController

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"SelectList ViewController - Start NSInteger");
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [listOfData count];
    NSLog(@"SelectList ViewController - Stop NSInteger");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [listOfData objectAtIndex:[indexPath row]];
    return cell;
}
#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SelectList ViewController tableView Section Row Selected = %i",indexPath.row);
    
}
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

@end
