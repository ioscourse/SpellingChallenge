//
//  addWordViewController.m
//  flashcards
//
//  Created by Thomas Kinser on 5/1/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//


#import "addWordViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
@implementation addWordViewController
@synthesize txtAddWords;
@synthesize ScrollView;
@synthesize playAudio;
@synthesize recordAudio;
@synthesize NameID;

int rows = 1;
int row = 1;
NSString *FilePath;
NSString *WordIDs;
int intWordsID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NameID = (NameID);
    //[self LoadDB];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}
-(void)dismissKeyboard {
    [txtAddWords resignFirstResponder];
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
    //[AddWordsPicker release];
    [txtAddWords release];
    [ScrollView release];
    [super dealloc];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y);
    [ScrollView setContentOffset:scrollPoint animated:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [ScrollView setContentOffset:CGPointZero animated:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y);
    [ScrollView setContentOffset:scrollPoint animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [ScrollView setContentOffset:CGPointZero animated:YES];
}
- (IBAction)btnAddWords:(id)sender {
    rows = 1;
    row = 1;
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
        NSLog(@"nameID: %d",NameID);
	    //[database executeUpdate:@"insert into FlashName(title) values(?)",txtListName.text];
        [database executeUpdate: @"INSERT INTO FlashWords (Word,AudioName,NameID) VALUES (?,?,?)",txtAddWords.text, @"AudioFileName", [NSNumber numberWithInt:NameID]];
        NSLog(@"WordsID: %d",intWordsID);
        intWordsID =[database lastInsertRowId];
        NSLog(@"WordsID: %d",intWordsID);
        [self InitializeAudioFile: [NSString stringWithFormat:@"%d%@", intWordsID, @".m4a"]];
        [database close];
        txtAddWords.Text =@"";
        [self dismissKeyboard];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Record Time"
                                                        message: @"Now, Press 'Record' and Speak the Name.  Press 'Stop' when Finished."
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

//Function to load audio file
- (void) InitializeAudioFile:(NSString *)filename;
{
    // Disable Stop/Play button when application launches
    
    [playAudio setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               filename,
                               nil];
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
- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordAudio setTitle:@"Record" forState:UIControlStateNormal];
    
    
    [playAudio setEnabled:YES];
}
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Recording Successful!.  Press 'Record' again to redo recording, otherwise type in new word to add another word or press 'Done' to complete adding this word list."
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (IBAction)playAudio:(id)sender
{
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}
- (IBAction)recordAudio:(id)sender
{
    rows = 1;
    row = 1;
    if (rows>0)
    {
        // Stop the audio player before recording
        if (player.playing) {
            [player stop];
        }
        
        if (!recorder.recording) {
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setActive:YES error:nil];
            
            // Start recording
            [recorder record];
            [recordAudio setTitle:@"Pause" forState:UIControlStateNormal];
            
        } else {
            
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
- (IBAction)stopAudio:(id)sender
{
    rows = 1;
    row = 1;
    if (rows>0)
    {
        [recorder stop];
        
        //AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //[audioSession setActive:NO error:nil];
        
        if (!recorder.recording){
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
            [player setDelegate:self];
            [player play];
        }
        
    }
    
}

@end