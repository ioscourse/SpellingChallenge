//
//  addWordViewController.h
//  flashcards
//
//  Created by Thomas Kinser on 5/1/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//
#import <AVFoundation/AVFoundation.h> // Added by Konkol
#import <UIKit/UIKit.h>

@interface addWordViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    //Declare Arrays
    NSMutableArray *listOfData;
    NSMutableArray *listOfNameID;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}
@property (retain, nonatomic) IBOutlet UITextField *txtAddWords;
@property (retain, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (nonatomic) int NameID;
-(IBAction)doneEditing:(id) sender;
-(IBAction)btnAddWords:(id)sender;

//Audio Stuff
@property (retain, nonatomic) IBOutlet UIButton *recordAudio;
@property (retain, nonatomic) IBOutlet UIButton *playAudio;
@property (retain, nonatomic) IBOutlet UITableView *tblView;
-(IBAction)btnDelete:(id)sender;
-(IBAction)stopAudio:(id)sender;
-(IBAction)recordAudio:(id)sender;
-(IBAction)playAudio:(id)sender;
@end