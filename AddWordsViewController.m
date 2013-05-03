//
//  AddWordsViewController.m
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//
//Called from the 'Manage Word List' button
#import "AddWordsViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation AddWordsViewController
@synthesize txtAddWords;
@synthesize AddWordsPicker;
@synthesize ScrollView;
@synthesize playAudio;
@synthesize recordAudio;

int rows;
int intWordsID;
NSString *FilePath;
NSString *WordIDs;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadDB];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
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
    // ?? next line
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
-(void)dismissKeyboard {
    [txtAddWords resignFirstResponder];
}
-(IBAction) doneEditing:(id) sender {
    [sender resignFirstResponder];
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [AddWordsPicker release];
    [txtAddWords release];
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
-(void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (!row==0)
    {
     rows=row;
     WordIDs=[listOfNameID objectAtIndex:row];
     NSLog(@"Selected Flash Card: %@. Index of selected Flash Card: %i", WordIDs, row);
    }
}
-(IBAction)btnAddWords:(id)sender {
    if (rows>0)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent:@"cards.sqlite"];
        NSLog(@"Path: %@",path);
        FMDatabase *database = [FMDatabase databaseWithPath:path];
        [database open];
        NSLog(@"Path: %@",@"OPenEd DB");
        NSLog(@"Path: %@",@"OPenEd trans");
	    [database executeUpdate: @"INSERT INTO FlashWords (WordsID,Word,AudioName,NameID) VALUES (NULL,?,?,?)",txtAddWords.text, @"AudioFileName", WordIDs,nil];
        intWordsID =[database lastInsertRowId];
        [self InitializeAudioFile: [NSString stringWithFormat:@"%d%@", intWordsID, @".m4a"]];
        NSLog(@"WordsID: %d",intWordsID);
        [database close];
        txtAddWords.Text =@"";
        [self dismissKeyboard];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Record Time"
                                                        message: @"Now, Press Record and Speak the Name"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
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
//Function to load audio file
-(void) InitializeAudioFile:(NSString *)filename;
{
    // Disable Stop/Play button when application launches
    [playAudio setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],filename,nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    FilePath=[outputFileURL absoluteString];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}
//Audio
-(void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordAudio setTitle:@"Record" forState:UIControlStateNormal];
    [playAudio setEnabled:YES];
}
-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Recording Successful!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
-(IBAction)playAudio:(id)sender
{
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}
-(IBAction)recordAudio:(id)sender
{
    if (rows>0)
    {
         // Stop the audio player before recording
    if (player.playing)
    {
        [player stop];
    }
    
    if (!recorder.recording)
    {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [recordAudio setTitle:@"Pause" forState:UIControlStateNormal];
    }
    else
    {
        // Pause recording
        [recorder pause];
        [recordAudio setTitle:@"Record" forState:UIControlStateNormal];
    }

        [playAudio setEnabled:NO];
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
-(IBAction)stopAudio:(id)sender
{
    if (rows>0)
    {
         [recorder stop];
    //AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //[audioSession setActive:NO error:nil];
    if (!recorder.recording)
    {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
    }
     
}
@end
