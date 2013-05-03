//
//  manageWordsViewController.h
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//
//Called from the 'Manage Word List' button
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface manageWordsViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    //Declare Arrays
    NSMutableArray *listOfData;
    NSMutableArray *listOfNameID;
//  AVAudioRecorder *recorder;
//  AVAudioPlayer *player;
}
@property (retain, nonatomic) IBOutlet UIPickerView *AddWordsPicker;
//@property (retain, nonatomic) IBOutlet UITextField *txtAddWords;
@property (retain, nonatomic) IBOutlet UIScrollView *ScrollView;
//-(IBAction)doneEditing:(id) sender;
//-(IBAction)btnAddWords:(id)sender;

//Audio Stuff
//@property (retain, nonatomic) IBOutlet UIButton *recordAudio;
//@property (retain, nonatomic) IBOutlet UIButton *playAudio;
//@property (retain, nonatomic) IBOutlet UITableView *tblView;
-(IBAction)btnDelete:(id)sender;
//-(IBAction)stopAudio:(id)sender;
//-(IBAction)recordAudio:(id)sender;
//-(IBAction)playAudio:(id)sender;
@end
