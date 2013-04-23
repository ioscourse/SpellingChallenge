//
//  flashcardsFirstViewController.m
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//

#import "flashcardsFirstViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"


@implementation flashcardsFirstViewController
@synthesize txtListName;
@synthesize scrollview;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //keyboard hooks
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];



}
-(IBAction) doneEditing:(id) sender {
    [sender resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [txtListName release];
    [super dealloc];
}
-(void)dismissKeyboard {
    [txtListName resignFirstResponder];
    [scrollview resignFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y);
    [scrollview setContentOffset:scrollPoint animated:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [scrollview setContentOffset:CGPointZero animated:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y);
    [scrollview setContentOffset:scrollPoint animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [scrollview setContentOffset:CGPointZero animated:YES];
}

- (IBAction)btnSave:(id)sender {
    [txtListName resignFirstResponder];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cards.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
	// Do any additional setup after loading the view, typically from a nib.
    [database executeUpdate:@"insert into FlashName(title) values(?)",
     txtListName.text];
    [database close];
    txtListName.text = @"";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success"
                                                    message: @"Word Added!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}
@end
