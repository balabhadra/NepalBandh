//
//  AlertLayer.m
//  AbyssIphone
//
//  Created by Bala Bhadra Maharjan on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlertLayer.h"

@implementation AlertLayer

-(id) initWithMessage:(NSString *)message options:(NSArray *)options target:(id)aTarget selector:(SEL)aSelector {
	if( (self = [super initWithColor:ccc4(0,0,0,140)] )) {
		CGSize winSize = [CCDirector sharedDirector].winSize;
		self.isTouchEnabled = YES;
		selector = aSelector;
		target = aTarget;
		CCMenu *menu = nil;
		for(NSString * menuName in options){
			CCLabelTTF *label = [CCLabelTTF labelWithString:menuName fontName:@"Marker Felt" fontSize:30];
			CCMenuItemLabel *item = [CCMenuItemLabel itemWithLabel:(CCNode *)label target:self selector:@selector(itemClicked:)];
			item.tag = [options indexOfObject:menuName];
			if(!menu)
				menu = [CCMenu menuWithItems:item,nil];
			else 
				[menu addChild:item];
		}
		[menu alignItemsVerticallyWithPadding:10];
		menu.position = ccp(winSize.width / 2, 130);
		[self addChild:menu];
		CCLabelTTF *label = [CCLabelTTF labelWithString:message dimensions:CGSizeMake(300,60) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:35];
		label.position = ccp(winSize.width / 2, 200 + 35*[options count] - 50);
		[self addChild:label];
	}
	return self;
}

-(void) itemClicked:(CCNode *)node{
	[target performSelector:selector withObject:[NSNumber numberWithInt:node.tag]];
}

@end
