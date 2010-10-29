//
//  GameModel.h
//  NepalBandh
//
//  Created by Bala Bhadra Maharjan on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INITIAL_LIVES		5
#define NUM_MOVING_ENEMY	2
#define NUM_STATIC_ENEMY	3
#define NUM_COLLECTABLES	4

typedef enum PlayerStatus {
	PlayerStatusNil,
	PlayerStatusMoving,
	PlayerStatusJumping,
	PlayerStatusDucking,
	PlayerStatusFallen
} PlayerStatus;

typedef enum Enemies{
	EnemyNil,
	EnemyStone,
	EnemyFire,
	EnemyTyre,
	EnemyBrick,
	EnemyThorn
}Enemies;

typedef enum Collectables{
	CollectableNil,
	CollectableLife,
	CollectableTime,
	CollectableInvulnerability,
	CollectableSpeed
}Collectables;

@interface GameModel : NSObject {
	NSInteger level;
	NSInteger lives;
	NSInteger levelDuration;
	NSInteger score;
	NSInteger speed;
	PlayerStatus playerStatus;
	CGFloat collectableGenerationProbability;
	CGFloat staticEnemyGenerationProbability;
	CGFloat movingEnemyGenerationProbability;
}

@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger lives;
@property (nonatomic, assign) NSInteger levelDuration;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, assign) PlayerStatus playerStatus;
@property (nonatomic, assign) CGFloat collectableGenerationProbability;
@property (nonatomic, assign) CGFloat staticEnemyGenerationProbability;
@property (nonatomic, assign) CGFloat movingEnemyGenerationProbability;

-(void) reset;
-(void) nextLevel;
-(Enemies)getMovingEnemyType;
-(Enemies)getStaticEnemyType;
-(Collectables)getCollectableType;


@end
