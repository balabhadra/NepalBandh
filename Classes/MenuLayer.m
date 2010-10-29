//
//  MenuLayer.m
//  NepalBandh
//
//  Created by Bala Bhadra Maharjan on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "SimpleAudioEngine.h"

@implementation MenuLayer
//setup view for main menu
-(id) init{
	if((self=[super init])){
		// enable touches
		self.isTouchEnabled = YES;
		screenSize = [CCDirector sharedDirector].winSize;
		
		CCSprite *background =[CCSprite spriteWithFile:@"menuBackground.png"];
		background.position = ccp(screenSize.width/2,screenSize.height/2);
		[self addChild:background];
				
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menuSelected.plist"];
		
		CCSprite *menuSprite0= [CCSprite spriteWithSpriteFrameName:@"continue.png"];
		CCSprite *menuSprite1 = [CCSprite spriteWithSpriteFrameName:@"play.png"];
		CCSprite *menuSprite2 = [CCSprite spriteWithSpriteFrameName:@"options.png"];
		CCSprite *menuSprite3 = [CCSprite spriteWithSpriteFrameName:@"highscore.png"];
		CCSprite *menuSprite4 = [CCSprite spriteWithSpriteFrameName:@"help.png"];
		CCSprite *menuSprite6 = [CCSprite spriteWithSpriteFrameName:@"about.png"];
		
		CCSprite *menuSpriteSelected0= [CCSprite spriteWithSpriteFrameName:@"continueSelected.png"];
		CCSprite *menuSpriteSelected1 = [CCSprite spriteWithSpriteFrameName:@"playSelected.png"];
		CCSprite *menuSpriteSelected2 = [CCSprite spriteWithSpriteFrameName:@"optionsSelected.png"];
		CCSprite *menuSpriteSelected3 = [CCSprite spriteWithSpriteFrameName:@"highscoreSelected.png"];
		CCSprite *menuSpriteSelected4 = [CCSprite spriteWithSpriteFrameName:@"helpSelected.png"];
		CCSprite *menuSpriteSelected6 = [CCSprite spriteWithSpriteFrameName:@"aboutSelected.png"];
		
		CCMenuItem *item0 = nil;
		if([[NSUserDefaults standardUserDefaults] dataForKey:@"savedLevel"]){
			item0 = [CCMenuItemSprite itemFromNormalSprite:menuSprite0 
											selectedSprite:menuSpriteSelected0 target:self selector:@selector(onContinue:)];
			item0.scale = MENU_ITEM_SCALE_FACTOR;
		}
		CCMenuItem *item1 = [CCMenuItemSprite itemFromNormalSprite:menuSprite1 
													selectedSprite:menuSpriteSelected1 target:self selector:@selector(onPlay:)];
		CCMenuItem *item2 = [CCMenuItemSprite itemFromNormalSprite:menuSprite2 
													selectedSprite:menuSpriteSelected2 target:self selector:@selector(onOptions:)];
		CCMenuItem *item3 = [CCMenuItemSprite itemFromNormalSprite:menuSprite3 
													selectedSprite:menuSpriteSelected3 target:self selector:@selector(onHighScore:)];
		CCMenuItem *item4 = [CCMenuItemSprite itemFromNormalSprite:menuSprite4 
													selectedSprite:menuSpriteSelected4 target:self selector:@selector(onHelp:)];
		CCMenuItem *item6 = [CCMenuItemSprite itemFromNormalSprite:menuSprite6 
													selectedSprite:menuSpriteSelected6 target:self selector:@selector(onAbout:)];
		item1.scale = MENU_ITEM_SCALE_FACTOR;
		item2.scale = MENU_ITEM_SCALE_FACTOR;
		item3.scale = MENU_ITEM_SCALE_FACTOR;
		item4.scale = MENU_ITEM_SCALE_FACTOR;
		item6.scale = MENU_ITEM_SCALE_FACTOR;
		
		
		CCMenu *menu;
		if(![[NSUserDefaults standardUserDefaults] dataForKey:@"boardMatrix"]){
			menu = [CCMenu menuWithItems:item1, item2, item3, item4, item6, nil];
		}
		else {
			menu = [CCMenu menuWithItems:item0,item1, item2, item3, item4, item6, nil];
		}
		menu.position = ccp(375, 110);
		[menu alignItemsVerticallyWithPadding:2.5];
		[self addChild:menu z:0 tag:0];
		

		//if([GameResource sharedResource].isMusicOn && ![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
//			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:[GameResource sharedResource].themeSound];
		
	}
	return self;
}

//clicked on yes when confirmation is shown for starting a new game if a previous game is saved. Starts a new game.
- (void)play{
//	[FlurryAPI logEvent: @"Play"];
//	CCScene *playScene = [CCScene node];
//	BoardMatrixLayer *boardMatrixLayer = [BoardMatrixLayer node];
//	BackgroundLayer *backgroundLayer = [BackgroundLayer node];
//	PearlLayer *pearlLayer = [[[PearlLayer alloc] initWithBoardMatrix:boardMatrixLayer.boardMatrix] autorelease];
//	PauseLayer *pauseLayer = [PauseLayer node];
//	pearlLayer.backgroundLayer = backgroundLayer;
//	[playScene addChild:backgroundLayer z:0 tag:0];
//	[playScene addChild:boardMatrixLayer z:1 tag:1];
//	[playScene addChild:pearlLayer z:2 tag:2];
//	[playScene addChild:pauseLayer z:3 tag:3];
//	[[CCDirector sharedDirector] replaceScene:playScene];
//	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

//clicked on continue menu item. Continues a saved game.
- (void)onContinue:(id)sender{
	//[FlurryAPI logEvent: @"Continue"];
//	NSData *boardMatrixData = [[NSUserDefaults standardUserDefaults] dataForKey:@"boardMatrix"];
//	BoardMatrix *savedBoardMatrix = (BoardMatrix *)[NSKeyedUnarchiver unarchiveObjectWithData:boardMatrixData];
//	if([GameResource sharedResource].isEffectOn)
//		[[SimpleAudioEngine sharedEngine] playEffect:[GameResource sharedResource].clickSound];
//	CCScene *playScene = [CCScene node];
//	BoardMatrixLayer *boardMatrixLayer = [[[BoardMatrixLayer alloc] initWithBoardMatrix:savedBoardMatrix isContinue:YES] autorelease];
//	BackgroundLayer *backgroundLayer = [BackgroundLayer node];
//	PearlLayer *pearlLayer = [[[PearlLayer alloc] initWithBoardMatrix:savedBoardMatrix isContinue:YES] autorelease];
//	PauseLayer *pauseLayer = [PauseLayer node];
//	pearlLayer.backgroundLayer = backgroundLayer;
//	
//	[playScene addChild:backgroundLayer z:0 tag:0];
//	[playScene addChild:boardMatrixLayer z:1 tag:1];
//	[playScene addChild:pearlLayer z:2 tag:2];
//	[playScene addChild:pauseLayer z:3 tag:3];
//	
//	[[CCDirector sharedDirector] replaceScene:playScene];
//	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

//clicked on play menu item. Shows confirmation if a game is previously saved otherwise starts a new game.
- (void)onPlay:(id)sender{
//	if([GameResource sharedResource].isEffectOn)
//		[[SimpleAudioEngine sharedEngine] playEffect:[GameResource sharedResource].clickSound];
//	if([[NSUserDefaults standardUserDefaults] dataForKey:@"boardMatrix"]){
//		AlertLayer *alert = [[[AlertLayer alloc] initWithMessage:@"Starting a new game will delete saved progress. Do you want to continue?"
//														 options:[NSArray arrayWithObjects:@"Yes",@"No",nil] target:self selector:@selector(optionSelected:)] autorelease];
//		[self.parent addChild:alert z:1 tag:1];
//		[(CCLayer *)[self getChildByTag:0] setIsTouchEnabled:NO];
//		[(CCLayer *)[self getChildByTag:0] setVisible:NO];
//	}
//	else {
//		[self play];
//	}
	
}

//clicked on options menu item. Shows option page.
- (void)onOptions:(id)sender{
//	if([GameResource sharedResource].isEffectOn)
//		[[SimpleAudioEngine sharedEngine] playEffect:[GameResource sharedResource].clickSound];
//	CCScene *optionsScene = [CCScene node];
//	OptionsLayer *optionsLayer = [OptionsLayer node];
//	AnimatingBackground *background = [AnimatingBackground node];
//	[optionsScene addChild:background z:0 tag:1];
//	[optionsScene addChild:optionsLayer z:0 tag:0];
//	[[CCDirector sharedDirector] replaceScene:optionsScene];
}

//clicked on high score menu item. Shows highscore page.
- (void)onHighScore:(id)sender{
//	if([GameResource sharedResource].isEffectOn)
//		[[SimpleAudioEngine sharedEngine] playEffect:[GameResource sharedResource].clickSound];
//	CCScene *highScoreScene = [CCScene node];
//	HighScoreLayer *highScoreLayer = [HighScoreLayer node];
//	AnimatingBackground *background = [AnimatingBackground node];
//	[highScoreScene addChild:background z:0 tag:1];
//	[highScoreScene addChild:highScoreLayer z:0 tag:0];
//	[[CCDirector sharedDirector] replaceScene:highScoreScene];
}

//clicked on help menu item. Shows help page.
- (void)onHelp:(id)sender{
//	if([GameResource sharedResource].isEffectOn)
//		[[SimpleAudioEngine sharedEngine] playEffect:[GameResource sharedResource].clickSound];
//	CCScene *helpScene = [CCScene node];
//	HelpLayer *helpLayer = [HelpLayer node];
//	AnimatingBackground *background = [AnimatingBackground node];
//	[helpScene addChild:background z:0 tag:1];
//	[helpScene addChild:helpLayer z:0 tag:0];
//	[[CCDirector sharedDirector] replaceScene:helpScene];
}

//clicked on about menu item. Shows about page.
- (void)onAbout:(id)sender{
//	if([GameResource sharedResource].isEffectOn)
//		[[SimpleAudioEngine sharedEngine] playEffect:[GameResource sharedResource].clickSound];
//	CCScene *aboutScene = [CCScene node];
//	AboutLayer *aboutLayer = [AboutLayer node];
//	AnimatingBackground *background = [AnimatingBackground node];
//	[aboutScene addChild:background z:0 tag:1];
//	[aboutScene addChild:aboutLayer z:0 tag:0];
//	[[CCDirector sharedDirector] replaceScene:aboutScene];
}

//confirmation delegate
- (void)optionSelected:(id)sender{
//	if([GameResource sharedResource].isEffectOn)
//		[[SimpleAudioEngine sharedEngine] playEffect:[GameResource sharedResource].clickSound];
//	NSInteger choice = [(NSNumber *)sender intValue];
//	switch (choice) {
//		case 0:
//			[self play];
//			break;
//		case 1:
//			[(CCLayer *)[self getChildByTag:0] setIsTouchEnabled:YES];
//			[(CCLayer *)[self getChildByTag:0] setVisible:YES];
//			[self.parent removeChildByTag:1 cleanup:YES];
//			break;
//		default:
//			break;
//	}
	
}



-(void)dealloc{
	[super dealloc];
}

@end
