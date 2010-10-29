//
//  BackgroundLayer.m
//  NepalBandh
//
//  Created by Bala Bhadra Maharjan on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"


@implementation BackgroundLayer
-(id) init{
	if((self=[super init])){
		// enable touches
		self.isTouchEnabled = NO;
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		CCSprite *background =[CCSprite spriteWithFile:@"Background.png"];
		background.position = ccp(screenSize.width/2,screenSize.height/2);
		[self addChild:background];
	}
	return self;
}

@end
