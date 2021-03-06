//
//  flashcardsSecondViewController.m
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//
// Called from SelectView Controller
#import "takeTestDetailViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface takeTestDetailViewController ()
@end

@implementation takeTestDetailViewController
@synthesize ScrollView;
@synthesize NameID;
@synthesize myButton;   
UITextField * textFieldRounded;

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Next three lines establish path to the documents sandbox
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cards.sqlite"];
    NSLog(@"2nd View Controller Path: %@",paths);
    NSLog(@"2nd View Controller Path: %@",docsPath);
    NSLog(@"2nd View Controller Path: %@",path);
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM FlashWords WHERE NameID = %@", NameID];
    FMResultSet *results = [database executeQuery:sql];
    NSLog(@"2nd View Controller results value %@",results);
    NSLog(@"2nd View Controller sql: %@",NameID);
    CGFloat row=0;
    while([results next])
        {
        row = row + 40;
        NSLog(@"2nd View Controller row is: %f",row);
        NSString *WordsID = [results stringForColumn:@"WordsID"] ;
        NSString *Word= [results stringForColumn:@"Word"];
     
        //Give the type of button. We can specify different types such as roundedRect, custom, info etc…
        //set the background to white color
        self.view.backgroundColor = [UIColor whiteColor];
        
        //create a rounded rectangle type button
        self.myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //create textfield
   
        //set the button size and position
    if (row==40)
        {
        self.myButton.frame = CGRectMake(5.0f, 10, 140.0f, 37.0f);
            textFieldRounded  = [[UITextField alloc] initWithFrame:CGRectMake(170, 10, 140.0f, 37.0f)];
                      //create the text field
            row = 10;
        }
    else
        {
            self.myButton.frame = CGRectMake(5.0f, row, 140.0f, 37.0f);
            textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(170, row, 140.0f, 37.0f)];
        }
    
        //set the origin of the frame reference
                        
        //set the button title for the normal state
        [self.myButton setTitle:@"Press"
                       forState:UIControlStateNormal];
        //set the button title for when the finger is pressing it down
        /*[self.myButton setTitle:Word
                         forState:UIControlStateHighlighted];
        */
        //add action to capture the button press down event
        [self.myButton addTarget:self
                          action:@selector(buttonIsPressed:)
                forControlEvents:UIControlEventTouchDown];
        //add action to capture when the button is released
        [self.myButton addTarget:self
                          action:@selector(buttonIsReleased:)
                forControlEvents:UIControlEventTouchUpInside];
        //set button tag
        [self.myButton setTag:[WordsID intValue]];
        //add the button to the view
        //[self.view addSubview:self.myButton];
        [ScrollView addSubview:self.myButton];
        //add the textfield to the view
        textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
        
        textFieldRounded.textColor = [UIColor blackColor]; //for showing  color of text
    
        textFieldRounded.font = [UIFont systemFontOfSize:17.0];  //for showing font size
        
        textFieldRounded.backgroundColor = [UIColor whiteColor]; //showing background color of textfield
        
        textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        
        textFieldRounded.delegate=self;
        
        textFieldRounded.keyboardType = UIKeyboardTypeDefault;  // typing from keyboard
        
        textFieldRounded.returnKeyType = UIReturnKeyDone;  // typing return key
        
        textFieldRounded.accessibilityIdentifier = Word;
        
        textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing; // has a clear ‘x’ button to the right
        
        //add action to capture the button press down event

        // editing ended:
        [textFieldRounded addTarget:self
                             action:@selector(textIsDone:)
                   forControlEvents:UIControlEventEditingDidEnd];
       
        //[self.view addSubview:textFieldRounded];
        [ScrollView addSubview:textFieldRounded];
    }
    ScrollView.minimumZoomScale = 1;
    ScrollView.maximumZoomScale = 3;
    ScrollView.delegate = self;
    [ScrollView setScrollEnabled:YES];
    ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+20);

    [results close]; //VERY IMPORTANT!
    [database close];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return ScrollView;
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y);
    [ScrollView setContentOffset:scrollPoint animated:YES];
}

// Why is this duplicated?
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [ScrollView setContentOffset:CGPointZero animated:YES];
}
-(void) textIsDone:(UITextField *)paramSender
{
    NSString *TryWord = paramSender.accessibilityIdentifier;
    NSString *RealWord = paramSender.text;
    NSLog(@"2nd View Controller TryWord is: %@",TryWord);
    if ([RealWord isEqualToString:TryWord])
    {
        paramSender.backgroundColor = [UIColor greenColor];
        //add scoring here
    }
    else
    {
    paramSender.backgroundColor = [UIColor redColor];
    }
    if ([RealWord isEqual:@""])
    {
    paramSender.backgroundColor = [UIColor whiteColor];
    }
}
-(void) buttonIsPressed:(UIButton *)paramSender
{
    NSLog(@"2nd View Controller WordsID is: %d",paramSender.tag);
    [self InitializeAudioFile: [NSString stringWithFormat:@"%d%@", paramSender.tag, @".m4a"]];
    [self PlayAudio];
}

-(void) buttonIsReleased:(UIButton *)paramSender
{
    switch (paramSender.tag)
    {
        case 1:
    NSLog(@"2nd View Controller Show Score");
        break;
        default:
    NSLog(@"2nd View Controller Button Released for WordsID: %d",paramSender.tag);
        break;
    }
}
-(void)dismissKeyboard
{
    [textFieldRounded resignFirstResponder];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y);
    [ScrollView setContentOffset:scrollPoint animated:YES];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [ScrollView setContentOffset:CGPointZero animated:YES];
}
-(IBAction)doneEditing:(id)sender
{
    [sender resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [textFieldRounded release];
    [ScrollView release];
    [super dealloc];
}
//Audio
//Function to load audio file
-(void) InitializeAudioFile:(NSString *)filename;
{
    // Disable Stop/Play button when application launches
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               filename,
                               nil];
    
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    NSLog(@"2nd View Controller AudioPathIS: %@",outputFileURL);
   
    
    // Setup audio sessio
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
}
-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
}
-(void) PlayAudio;
{
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
    [player setDelegate:self];
    [player play];
}
-(IBAction) stopAudio:(id)sender
{
    [recorder stop];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}
@end
