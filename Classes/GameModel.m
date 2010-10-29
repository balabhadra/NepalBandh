//
//  GameModel.m
//  NepalBandh
//
//  Created by Bala Bhadra Maharjan on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameModel.h"


@implementation GameModel

@synthesize level;
@synthesize lives;
@synthesize levelDuration;
@synthesize score;
@synthesize playerStatus;
@synthesize speed;
@synthesize collectableGenerationProbability;
@synthesize staticEnemyGenerationProbability;
@synthesize movingEnemyGenerationProbability;


-(id)init{
	if((self = [super init])){
		self.level = 0;
		self.lives = INITIAL_LIVES;
		self.score = 0;
		self.levelDuration = 0;
		self.speed = 0;
		self.playerStatus = PlayerStatusNil;
		self.collectableGenerationProbability = 0;
		self.staticEnemyGenerationProbability = 0;
		self.movingEnemyGenerationProbability = 0;
	}
	return self;
}

#pragma mark -
#pragma mark NSCoding protocol implementation
- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger:level forKey:@"level"];
	[coder encodeInteger:lives forKey:@"lives"];
	[coder encodeInteger:score forKey:@"score"];
	[coder encodeInteger:levelDuration forKey:@"levelDuration"];
	[coder encodeInteger:speed forKey:@"speed"];
	[coder encodeFloat:collectableGenerationProbability forKey:@"cgp"];
	[coder encodeFloat:staticEnemyGenerationProbability forKey:@"segp"];
	[coder encodeFloat:movingEnemyGenerationProbability forKey:@"megp"];
	
}

- (id)initWithCoder:(NSCoder *)coder{
    if((self = [super init])){
		self.level = [coder decodeIntegerForKey:@"level"];
		self.lives = [coder decodeIntegerForKey:@"lives"];
		self.score = [coder decodeIntegerForKey:@"score"];
		self.levelDuration = [coder decodeIntegerForKey:@"levelDuration"];
		self.speed = [coder decodeIntegerForKey:@"speed"];
		self.collectableGenerationProbability = [coder decodeFloatForKey:@"cgp"];
		self.staticEnemyGenerationProbability = [coder decodeFloatForKey:@"segp"];
		self.movingEnemyGenerationProbability = [coder decodeFloatForKey:@"megp"];
		self.playerStatus = PlayerStatusNil;
	}
	return (self);
}

#pragma mark -
#pragma mark NSCopying protocol implementation
- (id) copyWithZone: (NSZone *) zone { 
	GameModel * game = [[GameModel allocWithZone:zone] init]; 
	game.level = self.level;
	game.lives = self.lives;
	game.score = self.score;
	game.levelDuration = self.levelDuration;
	game.speed = self.speed ;
	game.collectableGenerationProbability = self.collectableGenerationProbability;
	game.staticEnemyGenerationProbability = self.staticEnemyGenerationProbability; 
	game.movingEnemyGenerationProbability = self.movingEnemyGenerationProbability;
	game.playerStatus = PlayerStatusNil;
	return game; 
} 

-(void) reset{
	self.level = 0;
	self.lives = INITIAL_LIVES;
	self.score = 0;
	self.levelDuration = 0;
	self.playerStatus = PlayerStatusNil;
}

-(void) nextLevel{
	level++;
	self.playerStatus = PlayerStatusNil;
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"LevelInfo" ofType:@"plist"];
	NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
	NSDictionary *levelInfo = [plistDict objectForKey:[NSString stringWithFormat:@"1 - %d",self.level]];
    self.levelDuration = [[levelInfo objectForKey:@"Duration"] intValue];
	self.speed = [[levelInfo objectForKey:@"Speed"] intValue];
	self.collectableGenerationProbability = [[levelInfo objectForKey:@"CollectableGenerationProbability"] floatValue];
	self.staticEnemyGenerationProbability = [[levelInfo objectForKey:@"StaticEnemyGenerationProbability"] floatValue];
	self.movingEnemyGenerationProbability = [[levelInfo objectForKey:@"MovingEnemyGenerationProbability"] floatValue];	
}

-(Enemies)getMovingEnemyType{
	if (movingEnemyGenerationProbability == 0) 
		return EnemyNil;
	
	NSInteger choice = 1/movingEnemyGenerationProbability;
	if (abs(arc4random() % choice) == 1) {
		return abs(arc4random() % NUM_MOVING_ENEMY) == 0 ? EnemyBrick : EnemyTyre;
	}
	return EnemyNil;
}

-(Enemies)getStaticEnemyType{
	if (staticEnemyGenerationProbability == 0) 
		return EnemyNil;
	
	NSInteger choice = 1/staticEnemyGenerationProbability;
	if (abs(arc4random() % choice) == 2) {
		switch (arc4random() % NUM_STATIC_ENEMY) {
			case 0:
				return EnemyStone;
				break;
			case 1:
				return EnemyThorn;
				break;
			case 2:
				return EnemyFire;
				break;
			default:
				break;
		}
	}
	return EnemyNil;
}

-(Collectables)getCollectableType{
	if (collectableGenerationProbability == 0) 
		return CollectableNil;
	
	NSInteger choice = 1/collectableGenerationProbability;
	if (abs(arc4random() % choice) == 3) {
		switch (arc4random() % NUM_COLLECTABLES) {
			case 0:
				return CollectableInvulnerability;
				break;
			case 1:
				return CollectableLife;
				break;
			case 2:
				return CollectableSpeed;
				break;
			case 3:
				return CollectableTime;
				break;
			default:
				break;
		}
	}
	return CollectableNil;
}
@end
