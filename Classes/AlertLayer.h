//
//  AlertLayer.h
//
//  Created by Bala Bhadra Maharjan on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCLabelTTF.h"

@interface AlertLayer : CCColorLayer {
	id target;
	SEL selector;
}
-(id) initWithMessage:(NSString *)message options:(NSArray *)options target:(id)aTarget selector:(SEL)aSelector;
@end
