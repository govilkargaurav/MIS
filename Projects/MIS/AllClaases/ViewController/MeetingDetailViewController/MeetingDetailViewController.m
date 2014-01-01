//
//  MeetingDetailViewController.m
//  MinutesInSeconds
//
//  Created by ChintaN on 8/1/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import "MeetingDetailViewController.h"
#import "GlobalClass.h"
#import "MeetingDetailCell.h"
@interface MeetingDetailViewController ()

@end

@implementation MeetingDetailViewController
@synthesize _tableView;
@synthesize scrlView;
@synthesize viewPlayerVw;
@synthesize textView;
@synthesize titleView;
@synthesize arrOfMeetings;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        arrOfMeetings = [NSMutableArray new];
        progressBar.value = 0.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    textView.layer.borderColor= [[UIColor whiteColor]CGColor];
    textView.layer.borderWidth=2.0;
    textView.layer.cornerRadius= 12.0;
    viewPlayerVw.layer.borderWidth=1.0;
    viewPlayerVw.layer.cornerRadius = 9.0;
    viewPlayerVw.layer.borderColor = [[UIColor darkGrayColor] CGColor];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    strTitleViewCalling = DRAW_RECT_DONT_NEED;
    /* To add Title View on Navigation Bar */
    CGRect Frame = CGRectMake(0, 0, 320, 44);
    titleView = [[NavigationSubclass alloc] initWithFrame:Frame navigationTitleName:@"Meeting Detail"];
    [self.navigationController.navigationBar addSubview:titleView];
    /**************************************************************/
    
    
    if (IS_IPHONE_5) {
        
        scrlView.frame = CGRectMake(0, 0 , 320, 500);
        scrlView.contentSize= CGSizeMake(320, 580);
        
    }else{
        scrlView.frame = CGRectMake(0, 0 , 320, 409);
        scrlView.contentSize= CGSizeMake(320, 580);
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,50, 44)];
    btn.backgroundColor=[UIColor clearColor];
    [btn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 16, 25)];
    [backImage setImage:[UIImage imageNamed:@"backBtn.png"]];
    [btn addSubview:backImage];

    [titleView addSubview:btn];
    
    [self.navigationItem setHidesBackButton:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.titleView removeFromSuperview];
    self.navigationItem.leftBarButtonItem=nil;
}

-(void)backButtonPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [arrOfMeetings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell)
    {
        cell = nil;
    }

    if(cell ==nil){
        NSDictionary *dictMeetingInfo = [arrOfMeetings objectAtIndex:indexPath.row];
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        MeetingDetailCell *detailCell = [[MeetingDetailCell alloc] initWithNibName:@"MeetingDetailCell" bundle:nil _dictMeetingInfo:dictMeetingInfo indexPath:indexPath.row];
        [cell addSubview:detailCell.view];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
	return cell;
}

/**Save and Play from Player **/
#pragma mark PLAYER DELEGATE MEHODS
/* These methods will save a clip from audio player and play from audio Player */
-(IBAction)playAudioRecorded :(id)sender{
    
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
    NSArray *arr = [cell subviews];
    
    for (UILabel *lbl in arr) {
        if ([lbl isKindOfClass:[UILabel class]]) {
            if (lbl.tag==([sender tag]+2000)) {
                timerLabel = lbl;
                 break;
            }
        }
    }
    
    for (UISlider *slider in arr) {
        if ([slider isKindOfClass:[UISlider class]]) {
            NSLog(@"([sender tag]+3000) : - > %d",[sender tag]);
            if (slider.tag==([sender tag]+3000)) {
                progressBar = slider;
                break;
            }
        }
    }
    
    
    NSDictionary *dictMeetingInfo = [arrOfMeetings objectAtIndex:[sender tag]-1000];
    if (ISplaying==YES && [sender tag]==[btnPlay tag]) {
        ISplaying=NO;
        [btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [audioPlayer stop];
        [playbackTimer invalidate];
    }else{
        btnPlay  = (UIButton *)sender;
        NSError *error;
        [btnPlay setImage:[UIImage imageNamed:@"pauseAudio.png"] forState:UIControlStateNormal];
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[dictMeetingInfo valueForKey:AUDIO_URL]] error:&error];
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
        
        [btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        //        toggleIsOn=NO;
        //[playbackTimer invalidate];
    }
}

- (void)sliderChanged:(UISlider *)sender {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
