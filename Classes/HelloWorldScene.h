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




@end
