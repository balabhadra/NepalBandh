//
//  OptionLayer.m
//  NepalBandh
//
//  Created by Rajan Maharjan on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OptionLayer.h"
#import "MenuLayer.h"


@implementation OptionLayer

- (id)init	 {
	if ( ( self = [super init] ) ) {
		CGSize winSize = [CCDirector sharedDirector].winSize;
		
		CCSprite *frontBackground = [CCSprite spriteWithFile:@"frontBackground.png"];
		
		frontBackground.position = ccp(winSize.width / 2, winSize.height / 2);
		
		[self addChild:frontBackground z:0];
		
		[CCMenuItemFont setFontName: @"Marker Felt"];
		[CCMenuItemFont setFontSize:28];
		CCMenuItemFont *title1 = [CCMenuItemFont itemFromString: @"Sound"];
		[title1 setIsEnabled:NO];
		[title1 setColor:ccWHITE];
		
		[CCMenuItemFont setFontSize:28];
		CCMenuItemToggle *item1 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallbackSound:) items:
								   [CCMenuItemFont itemFromString: @"On"],
								   [CCMenuItemFont itemFromString: @"Off"],
								   nil];
		item1.selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"sound"];
		
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:34];
		CCMenuItemLabel *back = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(backCallback:)];
		
		CCMenu *menu1 = [CCMenu menuWithItems:title1, nil]; 
		CCMenu *menu2 = [CCMenu menuWithItems:item1, nil];
		CCMenu *menu3 = [CCMenu menuWithItems:back,nil];
		
		menu1.position = ccp(winSize.width / 4, winSize.height / 2 + winSize.height / 4 - 50);
		menu2.position = ccp(winSize.width - winSize.width / 4, winSize.height / 2 + winSize.height / 4 - 50);
		menu3.position = ccp(winSize.width / 2, winSize.height / 2 - winSize.height / 4);
//		[menu1 alignItemsVerticallyWithPadding:20];
//		[menu2 alignItemsVerticallyWithPadding:20];
//		[menu3 alignItemsVertically];
		[self addChild: menu1 z:0];
		[self addChild: menu2 z:0];
		[self addChild: menu3 z:0];
	}
	return self;
}

- (void)backCallback:(id)sender {
	CCScene *menuScene = [CCScene node];
	MenuLayer *menuLayer = [MenuLayer node];
	[menuScene addChild:menuLayer z:0 tag:0];
	[[CCDirector sharedDirector] replaceScene:menuScene];
}

//changed sound option
-(void) menuCallbackSound: (id) sender{
//	if([GameResource sharedResource].isEffectOn)
//		[[SimpleAudioEngine sharedEngine] playEffect:[GameResource sharedResource].clickSound];
	[[NSUserDefaults standardUserDefaults] setInteger:[sender selectedIndex] forKey:@"sound"];
	[[NSUserDefaults standardUserDefaults] synchronize];
//	if([GameResource sharedResource].isMusicOn)
//		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:[GameResource sharedResource].themeSound];
//	else 
//		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

@end
