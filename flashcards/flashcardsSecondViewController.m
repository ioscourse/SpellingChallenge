//
//  flashcardsSecondViewController.m
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//

#import "flashcardsSecondViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface flashcardsSecondViewController ()
@end

@implementation flashcardsSecondViewController
@synthesize ScrollView;
@synthesize NameID;
@synthesize myButton;   
UITextField * textFieldRounded;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"cards.sqlite"];
    NSLog(@"Path: %@",path);
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
	// Do any additional setup after loading the view, typically from a nib.
   // NSString *WherePath = NameID;
   // NSString *sql = @"SELECT * FROM FlashWords WHERE NameID =";
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM FlashWords WHERE NameID = %@", NameID];
    
    //FMResultSet *results = [database executeQuery:sql, WherePath];
     FMResultSet *results = [database executeQuery:sql];
     NSLog(@"sql: %@",NameID);
   // FMResultSet *results = [database executeQuery:@"select * from MyWords where NameID= "@NameID];
     CGFloat row=0;
    while([results next]) {
        row = row + 40;
        NSLog(@"row is: %f",row);
        NSString *WordsID = [results stringForColumn:@"WordsID"] ;
        NSString *Word= [results stringForColumn:@"Word"];
     
        //Give the type of button. We can specify different types such as roundedRect, custom, info etc…
        //set the background to white color
        self.view.backgroundColor = [UIColor whiteColor];
        
        //create a rounded rectangle type button
        self.myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //create textfield
   
        //set the button size and position
       if (row==40){
        self.myButton.frame = CGRectMake(5.0f, 10, 140.0f, 37.0f);
            textFieldRounded  = [[UITextField alloc] initWithFrame:CGRectMake(170, 10, 140.0f, 37.0f)];
                      //create the text field
            row = 10;
        }
        else{
            self.myButton.frame = CGRectMake(5.0f, row, 140.0f, 37.0f);
            textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(170, row, 140.0f, 37.0f)];


        }
    
        //set the origin of the frame reference
                        
        //set the button title for the normal state
        [self.myButton setTitle:@"Press"
                       forState:UIControlStateNormal];
        //set the button title for when the finger is pressing it down
        [self.myButton setTitle:Word
                       forState:UIControlStateHighlighted];
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
        [textFieldRounded addTarget:self action:@selector(textIsDone:) forControlEvents:UIControlEventEditingDidEnd];
       
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return ScrollView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y);
    [ScrollView setContentOffset:scrollPoint animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [ScrollView setContentOffset:CGPointZero animated:YES];
}
- (void) textIsDone:(UITextField *)paramSender{
      NSString *TryWord = paramSender.accessibilityIdentifier;
     NSString *RealWord = paramSender.text;
     NSLog(@"TryWord is: %@",TryWord);
    if ([RealWord isEqualToString:TryWord])
    {
    paramSender.backgroundColor = [UIColor greenColor];
    }else{

         paramSender.backgroundColor = [UIColor redColor];
    }
    if ([RealWord isEqual:@""])
    {

        paramSender.backgroundColor = [UIColor whiteColor];
    }
}
- (void) buttonIsPressed:(UIButton *)paramSender{
 
            NSLog(@"WordsID is: %d",paramSender.tag);
            [self InitializeAudioFile: [NSString stringWithFormat:@"%d%@", paramSender.tag, @".m4a"]];
            [self PlayAudio];
}

- (void) buttonIsReleased:(UIButton *)paramSender{
    switch (paramSender.tag) {
        case 1:
            NSLog(@"Show Score");
           
            break;
        default:
           NSLog(@"Button Released for WordsID: %d",paramSender.tag);
            break;
    }
    
}
-(void)dismissKeyboard {
    [textFieldRounded resignFirstResponder];
     [textFieldRounded resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y);
    [ScrollView setContentOffset:scrollPoint animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [ScrollView setContentOffset:CGPointZero animated:YES];
}
- (IBAction)doneEditing:(id)sender
{
    [sender resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [textFieldRounded release];
    [ScrollView release];
    [super dealloc];
}
//Audio
//Function to load audio file
- (void) InitializeAudioFile:(NSString *)filename;
{
    // Disable Stop/Play button when application launches
 
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               filename,
                               nil];
    
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        NSLog(@"AudioPathIS: %@",outputFileURL);
   
    
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

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Got it?"
                                                    message: @"Now, Type in Word"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void) PlayAudio;
{
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
}
- (IBAction)stopAudio:(id)sender
{
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    
}


@end
