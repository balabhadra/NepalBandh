//
//  HUDLayer.h
//  NepalBandh
//
//  Created by Bala Bhadra Maharjan on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HUDLayer : CCLayer {
	NSInteger livesValue;
	NSInteger timeValue;
	
	CCLabelTTF *score;
	CCLabelTTF *gameLevel;
	CCLabelTTF *timeRemaingLabel;
}

@property (nonatomic, retain) CCLabelTTF *score;
@property (nonatomic, retain) CCLabelTTF *gameLevel;
@property (nonatomic, retain) CCLabelTTF *timeRemainingLabel;

- (void)increaseLives:(BOOL) addLivesStatus;
- (void)updateScore:(NSInteger)setScore;
- (void)updateGameLevel:(NSInteger)level;
- (void)updateTime:(ccTime)dt;

@end
