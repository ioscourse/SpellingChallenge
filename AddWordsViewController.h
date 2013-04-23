//
//  AddWordsViewController.h
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AddWordsViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    //Declare Arrays
    NSMutableArray *listOfData;
    NSMutableArray *listOfNameID;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}
@property (retain, nonatomic) IBOutlet UIPickerView *AddWordsPicker;
@property (retain, nonatomic) IBOutlet UITextField *txtAddWords;
-(IBAction) doneEditing:(id) sender;
- (IBAction)btnAddWords:(id)sender;
@property (retain, nonatomic) IBOutlet UIScrollView *ScrollView;

//Audio Stuff
@property (retain, nonatomic) IBOutlet UIButton *recordAudio;
@property (retain, nonatomic) IBOutlet UIButton *playAudio;
@property (retain, nonatomic) IBOutlet UITableView *tblView;
- (IBAction)btnDelete:(id)sender;

-(IBAction)stopAudio:(id)sender;
-(IBAction)recordAudio:(id)sender;
-(IBAction)playAudio:(id)sender;
@end
