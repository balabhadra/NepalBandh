//
//  AboutLayer.m
//  NepalBandh
//
//  Created by Bala Bhadra Maharjan on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AboutLayer.h"
#import "ScrollableLayer.h"
#import "MenuLayer.h"
#import "SimpleAudioEngine.h"

@implementation AboutLayer

- (id)init	 {
	if ( ( self = [super init] ) ) {
		CGSize winSize = [CCDirector sharedDirector].winSize;
		
		CCSprite *frontBackground = [CCSprite spriteWithFile:@"frontBackground.png"];
		
		frontBackground.position = ccp(winSize.width / 2, winSize.height / 2);
		
		[self addChild:frontBackground];
		
		NSString *aboutContent = [NSString stringWithFormat: @"%@ Version %@\nDesigned by Hackathon Team.\n\n"
								  "© 2010 Sprout Services Ltd.\nAll Rights Reserved\n\n"
								  "Developers:\nBala, Rajan, Samesh, Roshan\n",

								  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
								  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
		CCLabelTTF *label = [CCLabelTTF labelWithString:aboutContent dimensions:CGSizeMake(300, 200) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:20];
		label.position = ccp(winSize.width / 2, winSize.height / 2 + 20);
		[self addChild:label];
		
		label = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:35];
		CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(onBack:)];
		
		CCMenu *backMenu = [CCMenu menuWithItems: backItem, nil];
		backMenu.position = ccp (winSize.width / 2, 40);
		[backMenu alignItemsVerticallyWithPadding:30];
		[self addChild:backMenu];
	}
	return self;
}

- (void)onBack:(id)sender {
	[[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
	CCScene *menuScene = [CCScene node];
	MenuLayer *menuLayer = [MenuLayer node];
	[menuScene addChild:menuLayer z:0 tag:0];
	[[CCDirector sharedDirector] replaceScene:menuScene];
	[[CCDirector sharedDirector] resume];	
}

@end
