//
//  ScrollableLayer.h
//
//  Created by Bala Bhadra Maharjan on 4/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/**
 *	Supports vertical scrolling
 */

#import "cocos2d.h"

@interface ScrollableLayer : CCLayer {
	BOOL isDragging;
	CGFloat previousY;
	CGFloat YVelocity;
	NSInteger contentHeight;	
}

#define MAX_SCROLL_OFFSET	60
#define SCROLL_OFFSET_TIME	1
//Boolean value indicating if the layer is being dragged
@property (nonatomic, readonly) BOOL isDragging;

//the scroll height.
@property (nonatomic, assign) NSInteger contentHeight;
@end
