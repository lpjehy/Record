//
//  AudioManager.h
//  eCook
//
//  Created by 军辉 范 on 12-2-22.
//  Copyright (c) 2012年 Hangzhou Mo Chu Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


static NSString *SoundNameDefault = @"Default";

@interface AudioManager : NSObject < AVAudioPlayerDelegate> {
    
    AVAudioPlayer *defaultPlayer;
    
    NSString *duration;
    NSString *audioID;
    
    BOOL playerPaused;
}

@property(nonatomic, copy) NSString *duration;
@property(nonatomic, copy) NSString *audioID;

@property(nonatomic, readonly) AVAudioPlayer *defaultPlayer;

@property(nonatomic) BOOL playerPaused;


+ (AudioManager *)getInstance;


- (BOOL)playWithFilename:(NSString *)filename;


- (void)stopPlay;


+ (void)playShakeAudio;
+ (void)playPageAudio;
+ (void)playTimeUpAudio;
+ (void)playSentMessageAudio;
+ (void)playReceiveMessageAudio;
+ (void)playSentMailAudio;

+ (void)playBeginRecordAudio;
+ (void)playEndRecordAudio;


+ (void)testAudio:(NSInteger)i;
+ (void)playAudio;


@end
