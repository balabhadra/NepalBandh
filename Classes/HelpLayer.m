//
//  HelpLayer.m
//  NepalBandh
//
//  Created by Rajan Maharjan on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HelpLayer.h"
#import "MenuLayer.h"
#import "SimpleAudioEngine.h"


@implementation HelpLayer


- (id)init {
	
	if ( ( self = [super init] ) ) {
		
		currentPageNo = 1;
		
		CGSize winSize = [CCDirector sharedDirector].winSize;
		CCSprite *frontBackground = [CCSprite spriteWithFile:@"frontBackground.png"];
		
		frontBackground.position = ccp(winSize.width / 2, winSize.height / 2);
		
		[self addChild:frontBackground];
		
		// Pages
		
		CCLabelTTF *helpTextTitle = [CCLabelTTF labelWithString:@"Game Scenario" fontName:@"Marker Felt" fontSize:35];
		helpTextTitle.position = ccp(winSize.width / 2, winSize.height - helpTextTitle.contentSize.height);
		[self addChild:helpTextTitle z:0 tag:0];
		
		CCLabelTTF *gameTitle = [CCLabelTTF labelWithString:@"NEPAL BANDH\n"
								 " - The political strike! -\n" 
												 dimensions:CGSizeMake(210, 100)
												  alignment:UITextAlignmentCenter
												   fontName:@"Marker Felt" fontSize:23];
		gameTitle.position = ccp(winSize.width / 2, winSize.height -  gameTitle.contentSize.height - 15);
		[self addChild:gameTitle z:0 tag:1];
		
		CCLabelTTF *helpText = [CCLabelTTF labelWithString:@"A boy is on the way to his school to give his exam. On the way he heards\n"
								"about the Nepal Bandh. But he has to reach his school to give his exam on time."
								
												dimensions:CGSizeMake(winSize.width / 2 + winSize.width / 4, 200) 
												 alignment:UITextAlignmentCenter		
												  fontName:@"Marker Felt" fontSize:20];
		helpText.position = ccp(winSize.width / 2, winSize.height / 2 - 65);
		[self addChild:helpText z:0 tag:2];
		
		// Buttons 
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"<<" fontName:@"Marker Felt" fontSize:35];
		label.color = ccBLACK;
		CCMenuItemLabel *previousItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goPrevious:)];
		
		label = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:35];
		CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goBack:)];
		
		label = [CCLabelTTF labelWithString:@">>" fontName:@"Marker Felt" fontSize:35];
		//label.color = ccBLACK;
		CCMenuItemLabel *nextItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goNext:)];

		CCMenu *readHelp = [CCMenu menuWithItems:previousItem, backItem, nextItem, nil];
		readHelp.position = ccp (winSize.width / 2, label.contentSize.height + 10);
		[readHelp alignItemsHorizontallyWithPadding:350 / 3];
		[self addChild:readHelp z:1 tag:5 ];
		
	}
	return self;	
}

- (void)goBack:(id)sender {
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];	
	CCScene *menuScene = [CCScene node];
	MenuLayer *menuLayer = [MenuLayer node];
	[menuScene addChild:menuLayer z:0 tag:0];
	[[CCDirector sharedDirector] replaceScene:menuScene];
}

- (void)goPrevious:(id)sender {
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];	
	CGSize winSize = [CCDirector sharedDirector].winSize;
	
	if (currentPageNo > 0)
		currentPageNo--;
	else {
		return;
	}
	
	if (currentPageNo == 1) {
		
		[self removeChild:[self getChildByTag:2] cleanup:YES];		

		CCLabelTTF *helpText = [CCLabelTTF labelWithString:@"A boy is on the way to his school to give his exam. On the way he heards\n"
								"about the Nepal Bandh. But he has to reach his school to give his exam overcoming different obstacles."

								
												dimensions:CGSizeMake(winSize.width / 2 + winSize.width / 4, 200) 
												 alignment:UITextAlignmentCenter		
												  fontName:@"Marker Felt" fontSize:20];
		helpText.position = ccp(winSize.width / 2, winSize.height / 2 - 65);
		[self addChild:helpText z:0 tag:2];
		
		//Button System
		[self removeChild:[self getChildByTag:5] cleanup:YES];
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"<<" fontName:@"Marker Felt" fontSize:35];
		label.color = ccBLACK;		
		CCMenuItemLabel *previousItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goPrevious:)];
		
		label = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:35];
		CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goBack:)];
		
		label = [CCLabelTTF labelWithString:@">>" fontName:@"Marker Felt" fontSize:35];
		CCMenuItemLabel *nextItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goNext:)];
		
		CCMenu *readHelp = [CCMenu menuWithItems:previousItem, backItem, nextItem, nil];
		readHelp.position = ccp (winSize.width / 2, label.contentSize.height + 10);
		[readHelp alignItemsHorizontallyWithPadding:350 / 3];
		[self addChild:readHelp z:1 tag:5 ];
		
	}
	
	else if (currentPageNo == 2) {
		
		[self removeChild:[self getChildByTag:2] cleanup:YES];		
		
		CCLabelTTF *helpText = [CCLabelTTF labelWithString:@"Swipe up on the screen to Jump the Obstacles and grab the collectables!\n"
								
												dimensions:CGSizeMake(winSize.width / 2 + winSize.width / 4, 200) 
												 alignment:UITextAlignmentCenter		
												  fontName:@"Marker Felt" fontSize:20];
		helpText.position = ccp(winSize.width / 2, winSize.height / 2 - 65);
		[self addChild:helpText z:0 tag:2];
		
		// Remove sprites
		[self removeChild:[self getChildByTag:6] cleanup:YES];
		[self removeChild:[self getChildByTag:7] cleanup:YES];
		[self removeChild:[self getChildByTag:8] cleanup:YES];		
		[self removeChild:[self getChildByTag:9] cleanup:YES];				
		
		//Button System
		[self removeChild:[self getChildByTag:5] cleanup:YES];
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"<<" fontName:@"Marker Felt" fontSize:35];
		CCMenuItemLabel *previousItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goPrevious:)];
		
		label = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:35];
		CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goBack:)];
		
		label = [CCLabelTTF labelWithString:@">>" fontName:@"Marker Felt" fontSize:35];
		CCMenuItemLabel *nextItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goNext:)];
		
		CCMenu *readHelp = [CCMenu menuWithItems:previousItem, backItem, nextItem, nil];
		readHelp.position = ccp (winSize.width / 2, label.contentSize.height + 10);
		[readHelp alignItemsHorizontallyWithPadding:350 / 3];
		[self addChild:readHelp z:1 tag:5 ];
		
	}
}

- (void)goNext:(id)sender {
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];	
	CGSize winSize = [CCDirector sharedDirector].winSize;

	if (currentPageNo < 3)
		currentPageNo++;
	else {
		return;
	}

	if (currentPageNo == 2) {
		
		[self removeChild:[self getChildByTag:2] cleanup:YES];		
		
		CCLabelTTF *helpText = [CCLabelTTF labelWithString:@"Swipe up on the screen to Jump the Obstacles and grab the collectables!\n"
								"Swipe down on the screen to dodge down from the bricks."
								
												dimensions:CGSizeMake(winSize.width / 2 + winSize.width / 4, 200) 
												 alignment:UITextAlignmentCenter		
												  fontName:@"Marker Felt" fontSize:20];
		helpText.position = ccp(winSize.width / 2, winSize.height / 2 - 65);
		[self addChild:helpText z:0 tag:2];
		
		
		
		
		//Button System
		[self removeChild:[self getChildByTag:5] cleanup:YES];
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"<<" fontName:@"Marker Felt" fontSize:35];
		CCMenuItemLabel *previousItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goPrevious:)];
		
		label = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:35];
		CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goBack:)];
		
		label = [CCLabelTTF labelWithString:@">>" fontName:@"Marker Felt" fontSize:35];
		CCMenuItemLabel *nextItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goNext:)];
		
		CCMenu *readHelp = [CCMenu menuWithItems:previousItem, backItem, nextItem, nil];
		readHelp.position = ccp (winSize.width / 2, label.contentSize.height + 10);
		[readHelp alignItemsHorizontallyWithPadding:350 / 3];
		[self addChild:readHelp z:1 tag:5];
		
	}
	
	else if (currentPageNo == 3) {
		[self removeChild:[self getChildByTag:2] cleanup:YES];		
		
		CCLabelTTF *helpText = [CCLabelTTF labelWithString:@"Life Bonus    "
								"	Shield     "
								
												dimensions:CGSizeMake(winSize.width / 2 + winSize.width / 3 + 20, 190) 
												 alignment:UITextAlignmentLeft		
												  fontName:@"Marker Felt" fontSize:20];
		helpText.position = ccp(winSize.width / 2 + 20, winSize.height / 2 - 65);
		[self addChild:helpText z:0 tag:2];

		// Add icons 
		int spaceOffset = 100;
		int margin = 15;
		int leftOffset = 25;
		
		CCSprite *lifeBonus = [CCSprite spriteWithFile:@"bonus_life.png"];
		lifeBonus.position = ccp(lifeBonus.contentSize.width + margin + leftOffset, winSize.height / 2 - 25);
		[self addChild:lifeBonus z:1 tag:6];
		
		CCSprite *shieldBonus = [CCSprite spriteWithFile:@"bonus_shield.png"];
		shieldBonus.position = ccp(lifeBonus.contentSize.width + margin + leftOffset + spaceOffset - 15, winSize.height / 2 - 25);
		[self addChild:shieldBonus z: 1 tag:7];
		
//		CCSprite *speedBonus = [CCSprite spriteWithFile:@"bonus_speed.png"];
//		speedBonus.position = ccp(lifeBonus.contentSize.width + margin + leftOffset + 3 * spaceOffset - 15, winSize.height / 2 - 25);
//		[self addChild:speedBonus z: 1 tag:8];
//
//		CCSprite *timeBonus = [CCSprite spriteWithFile:@"bonus_time.png"];
//		timeBonus.position = ccp(lifeBonus.contentSize.width + margin + leftOffset + spaceOffset, winSize.height / 2 - 25);
//		[self addChild:timeBonus z: 1 tag:9];
		
		
		// Buttons
		[self removeChild:[self getChildByTag:5] cleanup:YES];
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"<<" fontName:@"Marker Felt" fontSize:35];
		CCMenuItemLabel *previousItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goPrevious:)];
		
		label = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:35];
		CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goBack:)];
		
		label = [CCLabelTTF labelWithString:@">>" fontName:@"Marker Felt" fontSize:35];
		label.color = ccBLACK;
		CCMenuItemLabel *nextItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goNext:)];
		
		CCMenu *readHelp = [CCMenu menuWithItems:previousItem, backItem, nextItem, nil];
		readHelp.position = ccp (winSize.width / 2, label.contentSize.height + 10);
		[readHelp alignItemsHorizontallyWithPadding:350 / 3];
		[self addChild:readHelp z:1 tag:5 ];
	}
}

@end
