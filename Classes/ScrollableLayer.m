//
//  ScrollableLayer.m
//  AbyssIphone
//
//  Created by Bala Bhadra Maharjan on 4/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScrollableLayer.h"

@implementation ScrollableLayer
@synthesize isDragging, contentHeight;

- (id) init{
    if ((self = [super init])){
		isTouchEnabled_ = YES;
		isDragging = NO;
		previousY = 0.0f;
		YVelocity = 0.0f;
		self.contentHeight = 150;

		self.anchorPoint = ccp( 240, 160 );
		self.position = ccp( 0, 0 );
		[self schedule:@selector(moveTick:) interval:0.02f];
		
	}
    return self;	
}	

#pragma mark Scheduled Methods

- (void) moveTick: (ccTime)dt {
	float friction = 0.95f;
	if (!isDragging)
	{
		// inertia
		YVelocity *= friction;
		CGPoint pos = self.position;
		pos.y += YVelocity;
		
		if ( pos.y < -MAX_SCROLL_OFFSET ) {pos.y = -MAX_SCROLL_OFFSET;YVelocity =0;}
		if ( pos.y > contentHeight + MAX_SCROLL_OFFSET ) {pos.y = contentHeight + MAX_SCROLL_OFFSET;YVelocity=0;}
		if(fabs(YVelocity) < 3 &&  (pos.y < 0 || pos.y > contentHeight)){YVelocity = 0;}
		if (YVelocity == 0){
			if(pos.y<0){
				YVelocity = fabs(6.5 * pos.y/MAX_SCROLL_OFFSET);
			}
			if(pos.y>contentHeight){
				YVelocity = -6.5 * (pos.y - contentHeight)/MAX_SCROLL_OFFSET;
			}
		}
		self.position = pos;
	}
	else
	{
		YVelocity = ( self.position.y - previousY ) / 2;
		previousY = self.position.y;
	}
}

#pragma mark Touch Methods

- (void) ccTouchesBegan: (NSSet *)touches withEvent: (UIEvent *)event{
	isDragging = YES;
}

- (void) ccTouchesMoved: (NSSet *)touches withEvent: (UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint a = [[CCDirector sharedDirector] convertToGL:[touch previousLocationInView:touch.view]];
	CGPoint b = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
	CGPoint nowPosition = self.position;
	nowPosition.y += ( b.y - a.y );
	nowPosition.y = MAX( -MAX_SCROLL_OFFSET, nowPosition.y );
	nowPosition.y = MIN( contentHeight + MAX_SCROLL_OFFSET, nowPosition.y );
	self.position = nowPosition;
}

- (void) ccTouchesEnded: (NSSet *)touches withEvent: (UIEvent *)event{
	isDragging = NO;
}


@end
