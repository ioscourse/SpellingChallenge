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
@property (retain, nonatomic) IBOutlet UIScrollView *ScrollView;

-(IBAction)btnDelete:(id)sender;

@end
