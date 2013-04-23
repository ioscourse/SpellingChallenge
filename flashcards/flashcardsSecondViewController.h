//
//  flashcardsSecondViewController.h
//  flashcards
//
//  Created by Charles Konkol on 4/17/13.
//  Copyright (c) 2013 RVC Student. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>

@interface flashcardsSecondViewController : UIViewController  <AVAudioRecorderDelegate, AVAudioPlayerDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    NSString *NameID;
    AVAudioPlayer *player;
      AVAudioRecorder *recorder;
}
@property (retain, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) NSString *NameID;
@property (nonatomic, strong) UIButton *myButton;

-(IBAction) doneEditing:(id) sender;
//audio


@end
