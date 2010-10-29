//
//  HouseLayer.m
//  NepalBandh
//
//  Created by Bala Bhadra Maharjan on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HouseLayer.h"


@implementation HouseLayer

@synthesize animDuration;

-(id) init{
	if((self=[super init])){
		// enable touches
		self.isTouchEnabled = NO;
		self.animDuration = 12;
		CCSprite *background =[CCSprite spriteWithFile:@"home_town.png"];
		CCSprite *background1 =[CCSprite spriteWithFile:@"home_town.png"];
		background.position = ccp(background.contentSize.width/2,background.contentSize.height/2);
		background1.position = ccp(background1.contentSize.width/2 + background1.contentSize.width, background1.contentSize.height/2);
	
		id action1 = [CCRepeatForever actionWithAction:[CCSequence actions:[CCMoveTo actionWithDuration:animDuration 
																							   position:ccp(-background.contentSize.width/2, background.contentSize.height/2)],
														[CCMoveTo actionWithDuration:0 
																			position:ccp(background.contentSize.width/2, background.contentSize.height/2)], nil]];
		
		id action2 = [CCRepeatForever actionWithAction:[CCSequence actions: [CCMoveTo actionWithDuration:animDuration
																								position:ccp(background1.contentSize.width/2, background1.contentSize.height/2)],
														[CCMoveTo actionWithDuration:0 
																			position:ccp(background1.contentSize.width/2 + background1.contentSize.width, background1.contentSize.height/2)],nil]];
		[background runAction:action1];
		[background1 runAction:action2];
		
		[self addChild:background];
		[self addChild:background1];
	}
	return self;
}

@end
