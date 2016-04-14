//
//  AudioManager.m
//  eCook
//
//  Created by 军辉 范 on 12-2-22.
//  Copyright (c) 2012年 Hangzhou Mo Chu Technology Co., Ltd. All rights reserved.
//

#import "AudioManager.h"

#define MaxDuration 60


static SystemSoundID   shakeAudio = 0;
static SystemSoundID   pageAudio = 0;

static AudioManager *instance = nil;

static NSString *auditionID = @"auditionID";

@implementation AudioManager

@synthesize defaultPlayer;

@synthesize duration, audioID;

@synthesize playerPaused;

- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)activeSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session)
        [session setActive:YES error:nil];
    
    UInt32 doChangeDefaultRoute = 1;
    //AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    NSError* error;
    [session setPreferredIOBufferDuration:doChangeDefaultRoute error:&error];
}

- (void)cancelSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if(session)
        [session setActive:NO error:nil];
}

+ (AudioManager *)getInstance
{
    if (instance == nil) {
        instance = [[AudioManager alloc] init];
    }
    return instance;
}

#pragma mark - path

+ (NSString *)auditionID
{
    return auditionID;
}


#pragma mark - current data


#pragma mark - play
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.audioID = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioFinishedPlayingNotification" object:nil];
}

- (void)updatePlayerMeters
{
    if (defaultPlayer.playing) {
        [defaultPlayer updateMeters];
        
        float peakPower = [defaultPlayer peakPowerForChannel:0];
        
        float power = peakPower + 40;
        if (power < 0) {
            power = 0;
        }
        
        //NSTimeInterval secend = defaultPlayer.duration - defaultPlayer.currentTime;
        
        //[[MessageView getInstance] showRecordAudioWave:power / 40 second:secend];
        
        [self performSelector:@selector(updatePlayerMeters) withObject:nil afterDelay:0.05];
    } else {
        //[[MessageView getInstance] stopRecordAudioWave];
    }
}

- (void)resetPlayer
{
    if (defaultPlayer) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioFinishedPlayingNotification" object:nil];
        [defaultPlayer stop];
        defaultPlayer = nil;
    }
}

- (BOOL)playWithFilename:(NSString *)filename
{
    if ([filename isEqualToString:UILocalNotificationDefaultSoundName]) {
        [AudioManager playDefaultAudio];
        return YES;
    }
    
    NSString *string = [[NSBundle mainBundle] pathForResource:filename ofType:@"mp3"];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    
    NSError *playerError;
    defaultPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&playerError];
    
    
    [self activeSession];
    
    [defaultPlayer play];
    defaultPlayer.delegate = self;
    
    return YES;
}


- (void)stopPlay
{
    if (defaultPlayer.playing) {
        [defaultPlayer stop];
        [self cancelSession];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioFinishedPlayingNotification" object:nil];
    }
}


#pragma mark - record


#pragma mark - Audios
+ (void)playShakeAudio
{
    if (shakeAudio == 0) {
        CFURLRef audioFileURLRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("shake"), CFSTR("m4a"), NULL);
        AudioServicesCreateSystemSoundID(audioFileURLRef, &shakeAudio);
        CFRelease(audioFileURLRef);
    }
    
    AudioServicesPlaySystemSound(shakeAudio);
}

+ (void)playPageAudio
{
    if (pageAudio == 0) {
        CFURLRef audioFileURLRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("page"), CFSTR("mp3"), NULL);
        AudioServicesCreateSystemSoundID(audioFileURLRef, &pageAudio);
        CFRelease(audioFileURLRef);
    }
    
    AudioServicesPlaySystemSound(pageAudio);
}

+ (void)playDefaultAudio
{
    AudioServicesPlaySystemSound(1002);
}

+ (void)playTimeUpAudio
{
    AudioServicesPlaySystemSound(1360);
}

+ (void)playSentMessageAudio
{
    AudioServicesPlaySystemSound(1004);
}

+ (void)playReceiveMessageAudio
{
    AudioServicesPlaySystemSound(1301);
}

+ (void)playSentMailAudio
{
    AudioServicesPlaySystemSound(1001);
}

+ (void)playBeginRecordAudio
{
    AudioServicesPlaySystemSound(1113);
}

+ (void)playEndRecordAudio
{
    AudioServicesPlaySystemSound(1114);
}

+ (void)testAudio:(NSInteger)i
{
    static SystemSoundID soundID = 1000;
    
    soundID += i;
    
    //NSLog(@"%lu", soundID);
    AudioServicesPlaySystemSound(1360);
}

+ (void)playAudio
{
    AudioServicesPlaySystemSound(1001);
}

@end
