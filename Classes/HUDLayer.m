//
//  HUDLayer.m
//  NepalBandh
//
//  Created by Bala Bhadra Maharjan on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HUDLayer.h"
#import "AlertLayer.h"
#import "MenuLayer.h"
#import "NepalBandhAppDelegate.h"
#import "GameModel.h"

@implementation HUDLayer

@synthesize score;
@synthesize gameLevel;
@synthesize timeRemainingLabel;


- (id)init	{
	if ( (self = [super	init]) ) {
		GameModel *game = [(NepalBandhAppDelegate *)[[UIApplication sharedApplication] delegate] game];
		livesValue = game.lives;
		timeValue = game.levelDuration;
		
		int margin = 5;
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		CCSprite *hudImage = [CCSprite spriteWithFile:@"hud.png"];
		hudImage.position = ccp(winSize.width / 2, winSize.height - hudImage.contentSize.height / 2);
		[self addChild:hudImage z:0];

		CCSprite *clockImage = [CCSprite spriteWithFile:@"clock.png"];
		clockImage.position = ccp (clockImage.contentSize.width / 2 + margin, clockImage.contentSize.height + margin);
		[self addChild:clockImage z:0];
		
		for (int i = 0; i < livesValue; i++) {
			CCSprite *heart = [CCSprite spriteWithFile:@"heart.png"];
			heart.position = ccp(winSize.width / 2 + winSize.width / 4 + i * heart.contentSize.width + 5, winSize.height - heart.contentSize.height / 2);
			
			[self addChild:heart z:1 tag:i+1];
		}
		
		gameLevel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", game.level]  
							  dimensions:CGSizeMake(20, 20) 
							   alignment:UITextAlignmentRight 
								fontName:@"Trebuchet MS" fontSize:18.0];
		
		score = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", game.score]  
									 dimensions:CGSizeMake(20, 20) 
									  alignment:UITextAlignmentRight 
									   fontName:@"Trebuchet MS" fontSize:18.0];
		
		timeRemaingLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", game.levelDuration]
											dimensions:CGSizeMake(20, 20)
											 alignment:UITextAlignmentCenter
											  fontName:@"Trebuchet MS" fontSize:18.0];
		
		
		gameLevel.color = ccc3( 255, 255, 255);
		score.color = ccc3(255, 255, 255);
		timeRemaingLabel.color = ccc3(255, 255, 255);

		gameLevel.position = ccp(gameLevel.contentSize.width / 2 + margin + 50, winSize.height - gameLevel.contentSize.height / 2 - 2);
		score.position = ccp(winSize.width / 2 - 50, winSize.height - score.contentSize.height / 2 - 2);		
		timeRemaingLabel.position = ccp(timeRemaingLabel.contentSize.width / 2 + margin + 8, timeRemaingLabel.contentSize.height / 2 + 2);
		
		[self addChild:gameLevel z:1];
		[self addChild:score z:1];
		[self addChild:timeRemaingLabel z:1 tag:8];
		
		CCMenuItemImage *pauseMenuItem = [CCMenuItemImage itemFromNormalImage:@"pauseButton.png" 
															   selectedImage:@"pauseButton_on.png"
																	  target:self
																	selector:@selector(showPauseMenu:)];
		CCMenu *menu = [CCMenu menuWithItems:pauseMenuItem, nil];
		menu.position = ccp(winSize.width - pauseMenuItem.contentSize.width / 2, pauseMenuItem.contentSize.height / 2);
		
		[self addChild:menu z:1 tag:6];
		
		[self schedule:@selector(updateTime:) interval:1];
	}
	return self;
}

- (void)showPauseMenu:(id)sender {
	NSLog(@"show pause menu!!\n");
	[[CCDirector sharedDirector] pause];
	AlertLayer *alert = [[[AlertLayer alloc] initWithMessage:@"Game Paused"
													 options:[NSArray arrayWithObjects:@"Resume",@"Main Menu",nil] target:self selector:@selector(optionSelected:)] autorelease];
	[self addChild:alert z:2 tag:7];
	[[self getChildByTag:6] setVisible:NO];
}

-(void)optionSelected:(id)sender{
//	if([[GameResource sharedResource] isEffectOn])
//		[[SimpleAudioEngine sharedEngine] playEffect:[GameResource sharedResource].clickSound];
	NSInteger choice = [(NSNumber *)sender intValue];
	switch (choice) {
		case 0:
			[[CCDirector sharedDirector] resume];
//			if([[GameResource sharedResource] isMusicOn]  && restoreBGMusic)
//				[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
			[[self getChildByTag:6] setVisible:YES];
//			[(CCLayer *)[self.parent getChildByTag:1] setIsTouchEnabled:YES];
//			[(CCLayer *)[self.parent getChildByTag:1] setVisible:YES];
//			[(CCLayer *)[self.parent getChildByTag:2] setVisible:YES];
			[self removeChildByTag:7 cleanup:YES];
			break;
		case 1:
		{
//			[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"SaveGame" object:nil];
//			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SavedData"];
			CCScene *menuScene = [CCScene node];
			MenuLayer *menuLayer = [MenuLayer node];
			[menuScene addChild:menuLayer z:0 tag:0];
			[[CCDirector sharedDirector] replaceScene:menuScene];
			[[CCDirector sharedDirector] resume];
			break;
		}
		default:
			break;
	}
}

- (void)increaseLives:(BOOL) addLivesStatus {
	NSInteger currentLives;
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	if (addLivesStatus) {
		// code to increase live
		if (livesValue < 5) {
			currentLives = livesValue;	
			if (currentLives == 5) return;
			livesValue++;
			
			NSLog(@"Update add Lives!");
			CCSprite *heart = [CCSprite spriteWithFile:@"heart.png"];
			heart.position = ccp(winSize.width / 2 + winSize.width / 4 + currentLives * heart.contentSize.width + 5, winSize.height - heart.contentSize.height / 2);
			[self addChild:heart z:livesValue tag:livesValue];
		}		
	}
	else {
		// code to decrease live
		if (livesValue > 0) {
			currentLives = livesValue;	
			if (currentLives == 0) return;
			livesValue--;
			NSLog(@"Update remove Lives!");
			[self removeChild:[self getChildByTag:currentLives] cleanup:YES];
		}
	}
}

- (void)updateScore:(NSInteger)setScore {
	[gameLevel setString:[NSString stringWithFormat:@"%d", setScore]];	
}

- (void)updateGameLevel:(NSInteger)level {
	[gameLevel setString:[NSString stringWithFormat:@"%d", level]];
}

- (void)updateTime:(ccTime)dt {
	if (timeValue != 0) {
		timeValue--;
		int margin = 5;
		[self removeChild:[self getChildByTag:8] cleanup:YES];
		timeRemaingLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", timeValue]
										dimensions:CGSizeMake(20, 20)
										 alignment:UITextAlignmentCenter
										  fontName:@"Trebuchet MS" fontSize:18.0];
		timeRemaingLabel.color = ccc3(255, 255, 255);
		timeRemaingLabel.position = ccp(timeRemaingLabel.contentSize.width / 2 + margin + 8, timeRemaingLabel.contentSize.height / 2 + 2);
		[self addChild:timeRemaingLabel z:1 tag:8];
	}
}

@end
