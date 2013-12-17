//
//  RecordNoteViewController.m
//  MinutesInSeconds
//
//  Created by ChintaN on 7/31/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import "RecordNoteViewController.h"
#import "GlobalClass.h"
#import "AppDelegate.h"
#import "ATMHud.h"
#import "KxMenu.h"
#import "DAL.h"
const unsigned char SpeechKitApplicationKey[] = {0xa4, 0x8b, 0x23, 0xc3, 0x2f, 0xec, 0x13, 0x67, 0xbe, 0x11, 0x83, 0x19, 0xbd, 0x3f, 0x18, 0x6c, 0xf1, 0x07, 0x9f, 0xb6, 0x88, 0x22, 0xf0, 0xf6, 0xf4, 0x19, 0x24, 0xf5, 0xe6, 0x47, 0xd6, 0x8a, 0xd2, 0xf9, 0x4d, 0x01, 0xe5, 0x60, 0x68, 0xa4, 0x71, 0xeb, 0xbd, 0x2e, 0x2a, 0xd5, 0x9a, 0x1b, 0xdc, 0x3a, 0xd1, 0x64, 0x5c, 0xc1, 0x5a, 0x50, 0xda, 0x7f, 0x45, 0xc0, 0xc6, 0x1c, 0x4a, 0x98};

@interface RecordNoteViewController ()

@end

@implementation RecordNoteViewController
@synthesize titleView;
@synthesize viewPlayer;
@synthesize scrollView;
@synthesize textView;
@synthesize imgViewMic;
@synthesize voiceSearch;
@synthesize arrOfLastObject;
@synthesize strUpdateItemId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        arrOfLastObject = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    VwRecordOverlay.hidden=YES;
    [super viewDidLoad];
    
    
    [SpeechKit setupWithID:APPID
                      host:APPHOST
                      port:APPPORT
                    useSSL:APPUSESSL
                  delegate:self];
    
    progressBar.value=0.0;
	// Set earcons to play
	SKEarcon* earconStart	= [SKEarcon earconWithName:@"earcon_listening.wav"];
	SKEarcon* earconStop	= [SKEarcon earconWithName:@"earcon_done_listening.wav"];
	SKEarcon* earconCancel	= [SKEarcon earconWithName:@"earcon_cancel.wav"];
	
	[SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
	[SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
	[SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
    
    ISRECORDING= NO;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"";
    textView.layer.borderColor= [[UIColor whiteColor]CGColor];
    textView.layer.borderWidth=2.0;
    textView.layer.cornerRadius= 12.0;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    strTitleViewCalling = DRAW_RECT_DONT_NEED;
    if ([strISRecordSoundChild isEqualToString:@"YES"]) {
        
        btnForChooseRecords.hidden=NO;
        /* To add Title View on Navigation Bar */
        CGRect Frame = CGRectMake(0, 0, 320, 44);
        titleView = [[NavigationSubclass alloc] initWithFrame:Frame navigationTitleName:@"Update Recording"];
        [self.navigationController.navigationBar addSubview:titleView];
        /**************************************************************/
        
    }else{
        btnForChooseRecords.hidden=YES;
        /* To add Title View on Navigation Bar */
        CGRect Frame = CGRectMake(0, 0, 320, 44);
        titleView = [[NavigationSubclass alloc] initWithFrame:Frame navigationTitleName:@"Start Recording"];
        [self.navigationController.navigationBar addSubview:titleView];
        /**************************************************************/
    }
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    viewPlayer.layer.borderWidth=1.0;
    viewPlayer.layer.cornerRadius = 9.0;
    viewPlayer.layer.borderColor = [[UIColor darkGrayColor] CGColor];

    if (IS_IPHONE_5)
    {
        scrollView.frame = CGRectMake(0, 0 , 320, 500);
        scrollView.contentSize= CGSizeMake(320, 500);
    }
    else
    {
            scrollView.frame = CGRectMake(0, 0 , 320, 409);
            scrollView.contentSize= CGSizeMake(320, 500);
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        scrollView.frame = CGRectMake(0,64,320,scrollView.frame.size.height);
        
      [self.navigationItem setHidesBackButton:YES];
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,50, 44)];
    btn.backgroundColor=[UIColor clearColor];
    [btn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 16, 25)];
    [backImage setImage:[UIImage imageNamed:@"backBtn.png"]];
    [btn addSubview:backImage];
    
    [titleView addSubview:btn];
}

-(void)backButtonPressed:(id)sender
{
    strISRecordSoundChild = @"NO";
//   [self.navigationController popViewControllerAnima/Applications/Xcode.appted:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.titleView removeFromSuperview];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickedOnMic:(id)sender{
    
    ISRECORDING = YES;
    [UIView beginAnimations:@"animation" context:nil];
    //[UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelegate:self];
    [imgViewMic setFrame:CGRectMake(192,20, 18,27)];
    imgViewMic.alpha=0.0;
    [UIView setAnimationDidStopSelector:@selector(reverse:)];
    [UIView commitAnimations];
}

-(void)reverse:(id)sender
{
    if (ISRECORDING==YES) {
    imgViewMic.frame = CGRectMake(184, 16, 32, 34);
    imgViewMic.alpha=1.0;
   [self clickedOnMic:nil];
        
    }else{
        [UIView beginAnimations:@"animation" context:nil];
        imgViewMic.frame = CGRectMake(184, 16, 32, 34);
        imgViewMic.alpha=1.0;
        VwRecordOverlay.alpha=0.0;
        VwRecordOverlay.hidden=YES;
        [UIView commitAnimations];
    }
    
}

-(IBAction)stopRecording:(id)sender{
    
    ISRECORDING = NO;
    if (transactionState == TS_RECORDING) {
        transactionState = TS_IDLE;
        VwRecordOverlay.alpha=0.0;
        VwRecordOverlay.hidden=YES;
         [voiceSearch stopRecording];
        progressBar.maximumValue=0.0;
    }
}


#pragma mark -
#pragma mark Actions

- (IBAction)recordButtonAction: (id)sender {
    VwRecordOverlay.hidden=NO;
    VwRecordOverlay.alpha = 0.6;
    [self clickedOnMic:nil];
    if (transactionState == TS_RECORDING) {
        [voiceSearch stopRecording];
    }
    else if (transactionState == TS_IDLE) {
        SKEndOfSpeechDetection detectionType;
        NSString* recoType;
        NSString* langType;
        
        transactionState = TS_INITIAL;
        
		textView.text = @"Speech To Text...";
        
            
            /* 'Dictation' is selected */
            detectionType = SKNoEndOfSpeechDetection;
            recoType = SKDictationRecognizerType;
			langType = @"en_US";
		
        /* Nuance can also create a custom recognition type optimized for your application if neither search nor dictation are appropriate. */
        ////NSLog(@"Recognizing type:'%@' Language Code: '%@' using end-of-speech detection:%d.", recoType, langType, detectionType);
        
            [[AppDelegate appDelegate] prepareToRecordAudioStreamFile];
            voiceSearch = [[SKRecognizer alloc] initWithType:recoType
                                                   detection:detectionType
                                                    language:langType
                                                    delegate:self];
            App_DetectionType = detectionType;
    }
}

#pragma mark -
#pragma mark SKRecognizerDelegate methods

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    [[[AppDelegate appDelegate] audioRecorder] record];
    
    ////NSLog(@"Recording started.");
    
    transactionState = TS_RECORDING;
    
    duration =  [[NSDate date] timeIntervalSince1970];
    
    if (App_DetectionType  == SKNoEndOfSpeechDetection)
    {
        //[recordButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    else
    {
        //[recordButton setTitle:@"Recording..." forState:UIControlStateNormal];
    }
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording finished.");
    
    duration= [[NSDate date] timeIntervalSince1970] - duration;
    
    float duration_minutes = floor(duration / 60);
    float  duration_seconds = duration - (duration_minutes * 60);
    totalTime.text=[NSString stringWithFormat:@" %0.0f:%0.0f",duration_minutes,duration_seconds];
    timerLabel.text=[NSString stringWithFormat:@"0:0/%@",totalTime.text];
    [[[AppDelegate appDelegate] audioRecorder] stop];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateVUMeter) object:nil];
    transactionState = TS_PROCESSING;
//    [recordButton setTitle:@"Processing..." forState:UIControlStateNormal];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    
    ////NSLog(@"Got results.");
    ////NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    long numOfResults = [results.results count];
    
    transactionState = TS_IDLE;
    //[recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    if (numOfResults > 0){
        textView.text = [results firstResult];
        VwRecordOverlay.alpha=0.0;
        VwRecordOverlay.hidden=YES;
    }
    
	if (numOfResults > 1)
//		alternativesDisplay.text = [[results.results subarrayWithRange:NSMakeRange(1, numOfResults-1)] componentsJoinedByString:@"\n"];
    
    if (results.suggestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:results.suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
	voiceSearch = nil;
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    ////NSLog(@"Got error.");
    ////NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    transactionState = TS_IDLE;
    //[recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    if (suggestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    VwRecordOverlay.alpha=0.0;
    VwRecordOverlay.hidden=YES;
	voiceSearch = nil;
}



/**Save and Play from Player **/
#pragma mark PLAYER DELEGATE MEHODS
/* These methods will save a clip from audio player and play from audio Player */

-(IBAction)saveIntoDatabseWithRecordingPath:(id)sender{

    if ([[[AppDelegate appDelegate] audioRecorder] url]!=nil && ![textView.text isEqualToString:@""]) {
        strAudioURLAbsoluteString = [NSString stringWithFormat:@"%@",[[[AppDelegate appDelegate] audioRecorder] url]];
        _dictURLwithSpeech = [[NSMutableDictionary alloc] init];
        [_dictURLwithSpeech setValue:strAudioURLAbsoluteString forKey:AUDIO_URL];
        [_dictURLwithSpeech setValue:textView.text forKey:SPEECH_TO_TEXT];
        
        
        NSLog(@"%@",strAudioURLAbsoluteString);
        
        NSLog(@"%@",[[[AppDelegate appDelegate] audioRecorder] url]);
        
        if ([strISRecordSoundChild isEqualToString:@"YES"] && ![btnForChooseRecords.titleLabel.text isEqualToString:@"Choose record for update"])
        {
    
            if (strUpdateItemId==nil)
            {
                NSString *str = [NSString stringWithFormat:@"where %@ = %@",MEETING_ID,[[arrOfLastObject objectAtIndex:0]valueForKey:MEETING_ID]];
                [DAL lookupChangeForSQLDictionary:_dictURLwithSpeech insertOrUpdate:@"update" ClauseAndCondition:str TableName:TBL_CREATE_MEETING];
            }
            else
            {
                NSString *str = [NSString stringWithFormat:@"where %@ = %@",SUBMEETING_ID,strUpdateItemId];
                [DAL lookupChangeForSQLDictionary:_dictURLwithSpeech insertOrUpdate:@"update" ClauseAndCondition:str TableName:TBL_SUB_MEETINGS];
            }
             [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
        }
       strISRecordSoundChild = @"NO";
    }else{
        [AppDelegate showalert:@"Please attach any sound message"];
    }
}

-(IBAction)playAudioRecorded :(id)sender{
    
    if (ISplaying==YES) {
        ISplaying=NO;
        [btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [audioPlayer stop];
        [playbackTimer invalidate];
    }else{
        NSError *error;
         [btnPlay setImage:[UIImage imageNamed:@"pauseAudio.png"] forState:UIControlStateNormal];
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[[AppDelegate appDelegate] audioRecorder] url] error:&error];
        
        playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(updateSlider)
                                                       userInfo:nil
                                                        repeats:YES];
        
        progressBar.maximumValue = audioPlayer.duration;
        
        [progressBar addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
    }
}
-(void)updateSlider
{
    float minutes = floor(audioPlayer.currentTime/60);
    float seconds = audioPlayer.currentTime - (minutes * 60);
    float duration_minutes = floor(audioPlayer.duration/60);
    float duration_seconds =
    audioPlayer.duration - (duration_minutes * 60);
    
    NSString *timeInfoString = [[NSString alloc]
                                initWithFormat:@"%0.0f:%0.0f / %0.0f:%0.0f",
                                minutes, seconds,
                                duration_minutes, duration_seconds];
    timerLabel.text = timeInfoString;
    //[timeInfoString release];
    ISplaying = YES;
    progressBar.value = audioPlayer.currentTime;
    float currenttime=floor(audioPlayer.currentTime);
    float totalDuration=floor(audioPlayer.duration);
    
    if(totalDuration-1.0==currenttime){
//        [play_pause_Button setImage:[UIImage imageNamed:@"playAudio.png"] forState:UIControlStateNormal];
//        toggleIsOn=NO;
        //[playbackTimer invalidate];
    }
    
}

- (void)sliderChanged:(UISlider *)sender{
    // Fast skip the music when user scroll the UISlider
    [audioPlayer stop];
    [audioPlayer setCurrentTime:progressBar.value];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

-(IBAction)stopAudio:(id)sender
{
    [playbackTimer invalidate];
    [audioPlayer stop];
    ISplaying=NO;
}

- (IBAction)showMenu:(UIButton *)sender
{
    NSLog(@"arrOfLastObject :::---> %lu",(unsigned long)[arrOfLastObject count]);
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<[arrOfLastObject count]; i++) {
        
     KxMenuItem *first1 =  [KxMenuItem menuItem:[[arrOfLastObject objectAtIndex:i] valueForKey:MEETING_TITLE]
                       image:[[arrOfLastObject objectAtIndex:i] valueForKey:SUBMEETING_ID]
                      target:self
                      action:@selector(pushMenuItem:)];
        [arr addObject:first1];
        
    }
    KxMenuItem *first = arr[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    [KxMenu showMenuInView:scrollView
                  fromRect:sender.frame
                 menuItems:arr];
}

-(void)pushMenuItem:(id)sender
{
    KxMenuItem *item = sender;
    btnForChooseRecords.titleLabel.text = item.title;
    strUpdateItemId = item.image;
}

@end
