//
//  HelloWorldScene.h
//  NepalBandh
//
//  Created by Bala Bhadra Maharjan on 10/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MyContactListener.h"
#import "GameModel.h"
#import "NepalBandhAppDelegate.h"

#define SWIPE_DRAG_MIN			20
#define COLLECTABLE_RADIUS		20

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	CCSprite *fire;
	CCAction *burning;
	
	CCSprite *skate_boy_run;
	CCSprite *skate_boy_jump;	
	CCAction *run;
	CCAction *jump;
	
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	MyContactListener *_contactListener;
	CGPoint touchLocation;
	GameModel *game;
	BOOL recentCollectableSpawn;
	BOOL recentStaticEnemySpawn;
	BOOL recentMovingEnemySpawn;
	BOOL levelCompleted;
	BOOL invulnerable;
	BOOL gameOver;
	NSTimer *invulnerableTimer;
}

@property (nonatomic, retain) NSTimer *invulnerableTimer; 
@property (nonatomic, retain) CCSprite *fire;
@property (nonatomic, retain) CCSprite *skate_boy_run;
@property (nonatomic, retain) CCSprite *skate_boy_jump;
@property (nonatomic, retain) CCAction *burning;
@property (nonatomic, retain) CCAction *run;
@property (nonatomic, retain) CCAction *jump;




@end
