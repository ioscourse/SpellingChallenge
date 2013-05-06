//
//  manageWordsViewController.m
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//
//Called from the 'Manage Word List' button
#import "manageWordsViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation manageWordsViewController
@synthesize AddWordsPicker;
@synthesize ScrollView;

int rows;
int intWordsID;
NSString *FilePath;
NSString *WordIDs;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadDB];
}
-(void)LoadDB
{
    // 
    listOfData = [[NSMutableArray alloc] init];
    listOfNameID = [[NSMutableArray alloc] init];
	// Initializes the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cards.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    NSLog(@"Path: %@",path);
    [database beginTransaction];
    NSLog(@"Path: %@",@"OPenEd DB");
	// Do any additional setup after loading the view, typically from a nib.
    FMResultSet *results = [database executeQuery:@"select * from FlashName"];
    [listOfData addObject:@"Choose from List Below"];
    [listOfNameID addObject:@"list"];
    while([results next])
    {
        NSString *Nameid = [results stringForColumn:@"NameID"] ;
        NSString *title = [results stringForColumn:@"title"] ;
        NSString *StrTitles =  [NSString stringWithFormat:@"ID:%@  --- %@", Nameid, title];
        NSLog(@"Titles: %@",StrTitles);
        [listOfNameID addObject:Nameid];
        [listOfData addObject:StrTitles];
    }
    [results close]; //VERY IMPORTANT!
    [database commit];
    [database close];
    NSLog(@"Closed: %@",@"DBClosed");
    [AddWordsPicker reloadAllComponents];
    [AddWordsPicker selectRow:0 inComponent:0 animated:YES];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [AddWordsPicker release];
    [ScrollView release];
    [super dealloc];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y);
    [ScrollView setContentOffset:scrollPoint animated:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [ScrollView setContentOffset:CGPointZero animated:YES];
}
-(void)textViewDidBeginEditing:(UITextView *)textView {
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y);
    [ScrollView setContentOffset:scrollPoint animated:YES];
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    [ScrollView setContentOffset:CGPointZero animated:YES];
}
//PickerViewController.m
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}
//PickerViewController.m
-(NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [listOfData count];
}
//PickerViewController.m
-(NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [listOfData objectAtIndex:row];
}
//PickerViewController.m
-(void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     rows=row;
     WordIDs=[listOfNameID objectAtIndex:row];
     NSLog(@"Selected Flash Card: %@. Index of selected Flash Card: %i", WordIDs, row);
}

-(void) DeleteWordList
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cards.sqlite"];
    NSLog(@"Path: %@",path);
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    NSString *sql = [NSString stringWithFormat:@"Delete FROM FlashName WHERE NameID = %@", WordIDs,nil];
    [database executeUpdate:sql];
    [database close];
    
    //audio files deleted for wordlist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [database open];
    [database beginTransaction];
    // Do any additional setup after loading the view, typically from a nib.
    sql = [NSString stringWithFormat:@"select * FROM FlashWords WHERE NameID = %@", WordIDs,nil];
    FMResultSet *results = [database executeQuery:sql];
    NSString *AudioFileName;
    while([results next])
    {
        NSString *Nameid = [results stringForColumn:@"NameID"];
        AudioFileName = [NSString stringWithFormat:@"%@%@", Nameid,@".m4a"];
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   AudioFileName,
                                   nil];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        FilePath=[outputFileURL absoluteString];

        NSLog(@"Path: %@",FilePath);
        [fileManager removeItemAtPath:FilePath error:NULL];
    }
    [results close]; //VERY IMPORTANT!
    [database commit];
    [database close];
    [database open];
    
    sql = [NSString stringWithFormat:@"Delete FROM FlashWords WHERE NameID = %@", WordIDs,nil];
    [database executeUpdate:sql];
    
    [database close];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success!"
                                                    message: @"WordList Deleted"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)btnDelete:(id)sender
{
    if (rows>0)
    {
        [self DeleteWordList];
        [self LoadDB];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Select WordList"
                                                        message: @"Select WordList Above"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
@end
