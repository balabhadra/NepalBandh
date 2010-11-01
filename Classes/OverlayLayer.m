//
//  OverlayLayer.m
//
//  Created by Bala Bhadra Maharjan on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OverlayLayer.h"


@implementation OverlayLayer

-(id) init{
	if( (self=[super initWithColor:ccc4(0,0,0,100)] )) {
		self.isTouchEnabled = YES;
	}
	return self;
}
@end
