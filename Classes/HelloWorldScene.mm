//
//  HelloWorldScene.mm
//  NepalBandh
//
//  Created by Bala Bhadra Maharjan on 10/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


// Import the interfaces
#import "HelloWorldScene.h"
#import "OverlayLayer.h"
#import "BackgroundLayer.h"
#import "HouseLayer.h"
#import	"HUDLayer.h"
#import "MenuLayer.h"
#import "SimpleAudioEngine.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagActor = 1,
	kTagShield = 100,
	kTagLife = 102,
	kTagSpeed = 103,
	kTagTime = 104,
	kTagBrick = 200,
	kTagThorn = 201,
	kTagStone = 202,
	kTagTyre = 203,
	kTagFire = 204
};


// HelloWorld implementation
@implementation HelloWorld

@synthesize invulnerableTimer;
@synthesize fire;
@synthesize burning;
@synthesize run;
@synthesize jump;
@synthesize skate_boy_jump;
@synthesize skate_boy_run;

// initialize your instance here
-(id) init
{
	if( (self=[super init])) {
		game = [(NepalBandhAppDelegate *)[[UIApplication sharedApplication] delegate] game]; 
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"playsound.wav"];
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		//Cache the sprite frames and texture
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"jumping.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"running.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fire.plist"];
		
		// Array to save sprite frames
		
/*		NSMutableArray *fireFrameArray = [NSMutableArray array];
		for (int i = 0; i <= 6; i++) {
			[fireFrameArray addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"fire%d.png", i]]];
		}
*/		
		NSMutableArray *runFrameArray = [NSMutableArray array];
		for (int i = 1; i <= 10; i++) {
			[runFrameArray addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"running000%d.png", i]]];
		}
		
		NSMutableArray *jumpFrameArray = [NSMutableArray array];
		for (int i = 1; i <= 10; i++) {
			[jumpFrameArray addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"jump000%d.png", i]]];
		}
		
		// Creating Animation Object using above frames
//		CCAnimation *burnAnim = [CCAnimation animationWithName:@"burn" delay:0.1f frames:fireFrameArray];
		CCAnimation *runAnim = [CCAnimation animationWithName:@"run" delay:0.1f frames:runFrameArray];
		CCAnimation *jumpAnim = [CCAnimation animationWithName:@"jump" delay:0.1f frames:jumpFrameArray];
		
		//self.fire = [CCSprite spriteWithSpriteFrameName:@"fire0.png"];
//		self.skate_boy_run = [CCSprite spriteWithSpriteFrameName:@"running0001.png"];
//		self.skate_boy_jump = [CCSprite spriteWithSpriteFrameName:@"jump0001.png"];
//		
//	//	fire.position = ccp(screenSize.width / 2, screenSize.height / 2);
//		skate_boy_run.position = ccp(screenSize.width / 4, screenSize.height / 2);
//		skate_boy_jump.position = ccp(screenSize.width - screenSize.width / 4, screenSize.height / 2);
//		
//	//	self.burning = [CCRepeatForever actionWithAction:
//	//					   [CCAnimate actionWithAnimation:burnAnim restoreOriginalFrame:NO]];
//	//	[fire runAction:burning];
//		
//		[self addChild:fire z:0 tag:kTagFire];
//		
//		self.run = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:NO]];
//		[skate_boy_run runAction:run];
//		//[spriteSheetRunning addChild:skate_boy_run z:0];
//		[self addChild:skate_boy_run z:0];
//
//		self.jump = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:jumpAnim restoreOriginalFrame:NO]];
//		[skate_boy_jump runAction:jump];
//		//[spriteSheetJumping addChild:skate_boy_jump z:0];
//		[self addChild:skate_boy_jump z:0];
//
		
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -10.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = false;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		//world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
//		flags += b2DebugDraw::e_jointBit;
//		flags += b2DebugDraw::e_aabbBit;
//		flags += b2DebugDraw::e_pairBit;
//		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);		
		
		_contactListener = new MyContactListener();
		world->SetContactListener(_contactListener);
		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
		// bottom
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// top
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		
		// left
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// right
		groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		
		[self schedule: @selector(tick:)];
		[self schedule: @selector(spawnObjects:) interval:0.5f];
		[self schedule: @selector(increaseScore:) interval:0.2f];
		levelCompleteTimer = [[NSTimer scheduledTimerWithTimeInterval:game.levelDuration target:self selector:@selector(levelComplete) userInfo:nil repeats:NO] retain];
		
		//Protagonist
		
		self.skate_boy_run = [CCSprite spriteWithSpriteFrameName:@"running0001.png"];
		skate_boy_run.position = ccp(96, 100);
		self.run = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:NO]];
		[skate_boy_run runAction:run];
		
		[self addChild:skate_boy_run z:1 tag:kTagActor];
		
		b2BodyDef spriteBodyDef;
		spriteBodyDef.type = b2_dynamicBody;
		spriteBodyDef.position.Set(skate_boy_run.position.x/PTM_RATIO, skate_boy_run.position.y/PTM_RATIO);
		spriteBodyDef.userData = skate_boy_run;
		b2Body *spriteBody = world->CreateBody(&spriteBodyDef);
		
		b2PolygonShape spriteShape;
		NSInteger num = 4;
		b2Vec2 verts[] = {b2Vec2(43.0f / PTM_RATIO, -77.0f / PTM_RATIO),
			b2Vec2(8.0f / PTM_RATIO, 26.0f / PTM_RATIO),
			b2Vec2(-19.0f / PTM_RATIO, 8.0f / PTM_RATIO),
			b2Vec2(-32.0f / PTM_RATIO, -78.0f / PTM_RATIO)};
		spriteShape.Set(verts, num);
		b2FixtureDef spriteShapeDef;
		spriteShapeDef.shape = &spriteShape;
		spriteShapeDef.density = 10.0;
		spriteShapeDef.isSensor = true;
		
		spriteBody->CreateFixture(&spriteShapeDef);
			
	}
	return self;
}

-(void)increaseScore:(ccTime)dt{
	game.score += game.level * game.lives + arc4random() % 20;
	HUDLayer *hud = (HUDLayer *)[self.parent getChildByTag:3];
	[hud updateScore:game.score];
}

-(void)levelComplete{
	levelCompleted = YES;
	[[SimpleAudioEngine sharedEngine] playEffect:@"levelComplete.wav"];
	for(CCSprite * spr in [[self.parent getChildByTag:1] children]){
		[spr stopAllActions];
	}
	
	for(CCSprite * spr in [self children]){
		[spr stopAllActions];
	}
	[self unschedule:@selector(tick:)];
	[self unschedule:@selector(increaseScore:)];
	[self unschedule:@selector(spawnObjects:)];
	CCLabelTTF *label1 = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"Level Completed"] fontName:@"Marker Felt" fontSize:40];
	label1.position = ccp(self.contentSize.width/2, self.contentSize.height/2 + 30);
	CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"(TAP to continue)" fontName:@"Marker Felt" fontSize:34];
	label2.position = ccp(self.contentSize.width/2, self.contentSize.height/2 - 30);
	
	CCNode *node = [OverlayLayer node];
	[node addChild:label1];
	[node addChild:label2];
	[self addChild:node];
}

-(void)addBoxBodyForCollectable:(CCSprite *)sprite{
	// Define the dynamic body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	
	bodyDef.position.Set(sprite.position.x/PTM_RATIO, sprite.position.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
	b2CircleShape circle;
	circle.m_radius = COLLECTABLE_RADIUS/PTM_RATIO;
	
	// Create shape definition and add to body
	b2FixtureDef ballShapeDef;
	ballShapeDef.shape = &circle;
	ballShapeDef.density = 0.0f;
	ballShapeDef.friction = 0.8f; 
	ballShapeDef.restitution = 0.25f;
	// Define the dynamic body fixture.
	body->CreateFixture(&ballShapeDef);
}

- (BOOL)spawnCollectable {
	NSString *spriteName;
	NSInteger sprite_tag;
	switch ([game getCollectableType]) {
		case CollectableSpeed:
			//No time for speed bonus. Change it to life
			spriteName = @"bonus_life.png";
			sprite_tag = kTagLife; 
			break;
		case CollectableLife:
			spriteName = @"bonus_life.png";
			sprite_tag = kTagLife; 
			break;
		case CollectableTime:
			//No time for time bonus. Change it to shield
			spriteName = @"bonus_shield.png";
			sprite_tag = kTagShield;
			break;
		case CollectableInvulnerability:
			spriteName = @"bonus_shield.png";
			sprite_tag = kTagShield;
			break;
		default:
			return NO;
	}
    CCSprite *collectableSprite = [CCSprite spriteWithFile:spriteName];
    collectableSprite.position = ccp(550, 220);
    collectableSprite.tag = sprite_tag;
	
	id action = [CCSequence actions: [CCMoveTo actionWithDuration:(1.0f/game.speed)*150 position:ccp(-24,220)], 
				 [CCCallFuncN actionWithTarget:self selector:@selector(spriteDone:)],nil];

    [collectableSprite runAction:action]; 
	[self addBoxBodyForCollectable:collectableSprite];
    [self addChild:collectableSprite z:0 tag:sprite_tag];
    return YES;
}

-(void)addBoxBodyForEnemy:(CCSprite *)sprite{
	b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    spriteBodyDef.position.Set(sprite.position.x/PTM_RATIO, sprite.position.y/PTM_RATIO);
    spriteBodyDef.userData = sprite;
    b2Body *spriteBody = world->CreateBody(&spriteBodyDef);

    if (sprite.tag == kTagStone) {
		b2PolygonShape spriteShape;
		NSInteger num = 6;
		b2Vec2 verts[] = {b2Vec2(59.0f / PTM_RATIO, -30.0f / PTM_RATIO),
			b2Vec2(60.0f / PTM_RATIO, -29.0f / PTM_RATIO),
			b2Vec2(17.0f / PTM_RATIO, 21.0f / PTM_RATIO),
			b2Vec2(-28.0f / PTM_RATIO, 23.0f / PTM_RATIO),
			b2Vec2(-51.0f / PTM_RATIO, 13.0f / PTM_RATIO),
			b2Vec2(-51.0f / PTM_RATIO, -30.0f / PTM_RATIO)};
		spriteShape.Set(verts, num);
		
		b2FixtureDef spriteShapeDef;
		spriteShapeDef.shape = &spriteShape;
		spriteShapeDef.density = 10.0;
		spriteShapeDef.isSensor = true;
		
		spriteBody->CreateFixture(&spriteShapeDef);
		return;
    } 
	else if(sprite.tag == kTagThorn) {
		b2PolygonShape spriteShape;
		NSInteger num = 5;
		b2Vec2 verts[] = {b2Vec2(11.0f / PTM_RATIO, -47.0f / PTM_RATIO),
			b2Vec2(12.0f / PTM_RATIO, 8.0f / PTM_RATIO),
			b2Vec2(10.0f / PTM_RATIO, 30.0f / PTM_RATIO),
			b2Vec2(-2.0f / PTM_RATIO, 40.0f / PTM_RATIO),
			b2Vec2(-13.0f / PTM_RATIO, -45.0f / PTM_RATIO)};
		spriteShape.Set(verts, num);
		
		b2FixtureDef spriteShapeDef;
		spriteShapeDef.shape = &spriteShape;
		spriteShapeDef.density = 10.0;
		spriteShapeDef.isSensor = true;
		
		spriteBody->CreateFixture(&spriteShapeDef);
		return;
		
    }
	else if(sprite.tag == kTagTyre) {
        
    }
	else if(sprite.tag == kTagFire){
		b2PolygonShape spriteShape;
		NSInteger num = 5;
		b2Vec2 verts[] = {b2Vec2(23.0f / PTM_RATIO, -46.0f / PTM_RATIO),
			b2Vec2(22.0f / PTM_RATIO, -10.0f / PTM_RATIO),
			b2Vec2(3.0f / PTM_RATIO, 41.0f / PTM_RATIO),
			b2Vec2(-23.0f / PTM_RATIO, -25.0f / PTM_RATIO),
			b2Vec2(-21.0f / PTM_RATIO, -45.0f / PTM_RATIO)};
		spriteShape.Set(verts, num);
		
		b2FixtureDef spriteShapeDef;
		spriteShapeDef.shape = &spriteShape;
		spriteShapeDef.density = 10.0;
		spriteShapeDef.isSensor = true;
		
		spriteBody->CreateFixture(&spriteShapeDef);
		return;
	}
	else if(sprite.tag == kTagBrick){
		
	}
}

- (BOOL)spawnMovingEnemy {
    return NO;
}

- (BOOL)spawnStaticEnemy {
    NSString *spriteName;
	NSInteger sprite_tag;
	switch ([game getStaticEnemyType]) {
		case EnemyStone:
			spriteName = @"enemy_stone.png";
			sprite_tag = kTagStone; 
			break;
		case EnemyThorn:
			spriteName = @"enemy_thorn.png";
			sprite_tag = kTagThorn;
			break;
		case EnemyFire:
		{	
			NSMutableArray *fireFrameArray = [NSMutableArray array];
			for (int i = 0; i <= 6; i++) {
				[fireFrameArray addObject:
				 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"fire%d.png", i]]];
			}
			CCAnimation *burnAnim = [CCAnimation animationWithName:@"burn" delay:0.1f frames:fireFrameArray];
			CCSprite *fireSprite = [CCSprite spriteWithSpriteFrameName:@"fire0.png"];
			fireSprite.position = ccp(550, 52);
			fireSprite.tag = kTagFire;
			id action= [CCSpawn actions: [CCMoveTo actionWithDuration:(1.0f/game.speed)*150 position:ccp(-64,52)],
						[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:burnAnim restoreOriginalFrame:NO] times:5], nil];
			id action1 = [CCSequence actions: action, 
						  [CCCallFuncN actionWithTarget:self selector:@selector(spriteDone:)],nil];
			[fireSprite runAction:action1];
			[self addBoxBodyForEnemy:fireSprite];
			[self addChild:fireSprite z:0 tag:kTagFire];
		}
			return YES;
			break;
		default:
			return NO;
	}
    CCSprite *enemySprite = [CCSprite spriteWithFile:spriteName];
    enemySprite.position = ccp(550, 52);
    enemySprite.tag = sprite_tag;
	
	id action = [CCSequence actions: [CCMoveTo actionWithDuration:(1.0f/game.speed)*150 position:ccp(-64,52)], 
				 [CCCallFuncN actionWithTarget:self selector:@selector(spriteDone:)],nil];
    [enemySprite runAction:action]; 
	[self addBoxBodyForEnemy:enemySprite];
    [self addChild:enemySprite z:0 tag:sprite_tag];
    return YES;
}

-(void) spriteDone:(id)sender{
	CCSprite *sprite = (CCSprite *)sender;
	b2Body *body;
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			if (myActor == sprite) {
				body = b;
			}
		}	
	}
	world -> DestroyBody(body);
	NSLog(@"body destroyed");
	[self removeChild:sprite cleanup:YES];
}

-(void)collectableSpawnExpired{
	recentCollectableSpawn = NO;
}

-(void)movingEnemySpawnExpired{
	recentMovingEnemySpawn = NO;
}

-(void)staticEnemySpawnExpired{
	recentStaticEnemySpawn = NO;
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}

-(void) spawnObjects: (ccTime) dt{
	if(!recentCollectableSpawn){
		recentCollectableSpawn = [self spawnCollectable];
		if (recentCollectableSpawn) {
			[NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(collectableSpawnExpired) userInfo:nil repeats:NO];
		}
	}
	
	if(!recentMovingEnemySpawn){
		recentMovingEnemySpawn = [self spawnMovingEnemy];
		if (recentMovingEnemySpawn) {
			[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(movingEnemySpawnExpired) userInfo:nil repeats:NO];
		}
	}
	
	if(!recentStaticEnemySpawn) {
		recentStaticEnemySpawn = [self spawnStaticEnemy];
		if (recentStaticEnemySpawn) {
			[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(staticEnemySpawnExpired) userInfo:nil repeats:NO];
		}
	}
}

-(void)makeInvulnerable{
	[invulnerableTimer invalidate];
	invulnerable = YES;
	self.invulnerableTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeInvulnerable) userInfo:nil repeats:NO];
}

-(void)removeInvulnerable{
	invulnerable = NO;
}

-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	
	int32 velocityIterations = 6;
	int32 positionIterations = 6;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);

	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			//myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			//myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
			// Convert the Cocos2D position/rotation of the sprite to the Box2D position/rotation
            b2Vec2 b2Position = b2Vec2(myActor.position.x/PTM_RATIO,
                                       myActor.position.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(myActor.rotation);
            
            // Update the Box2D position/rotation to match the Cocos2D position/rotation
            b->SetTransform(b2Position, b2Angle);
		}	
	}
	
	// Loop through all of the box2d bodies that are currently colliding, that we have
    // gathered with our custom contact listener...
	std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
	HUDLayer *hud = (HUDLayer *)[self.parent getChildByTag:3]; 
    for(pos = _contactListener->_contacts.begin(); pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        // Get the box2d bodies for each object
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            
            CCSprite *collisionSprite;
			b2Body *collisionBody;
            if (spriteA.tag == 1) {
				collisionSprite = spriteB;
				collisionBody = bodyB;
            } 
			else if(spriteB.tag == 1){
				collisionSprite = spriteA;
				collisionBody = bodyA;
			}
			
			if (collisionSprite.tag >=200) {
				if(!invulnerable){
					[[SimpleAudioEngine sharedEngine] playEffect:@"Ouch.wav"];
					NSLog(@"Bad collision");
					game.lives--;
					[hud increaseLives:NO];
					if (game.lives < 1) {
						gameOver = YES;
						for(CCSprite * spr in [[self.parent getChildByTag:1] children]){
							[spr stopAllActions];
						}
						
						for(CCSprite * spr in [self children]){
							[spr stopAllActions];
						}
						[[self.parent getChildByTag:3] removeChildByTag:6 cleanup:YES];
						[self unschedule:@selector(tick:)];
						[self unschedule:@selector(spawnObjects:)];
						[self unschedule:@selector(increaseScore:)];
						[levelCompleteTimer invalidate];
						CCLabelTTF *label1 = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"Game Over"] fontName:@"Marker Felt" fontSize:40];
						label1.position = ccp(self.contentSize.width/2, self.contentSize.height/2 + 30);
						CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"(TAP to continue)" fontName:@"Marker Felt" fontSize:34];
						label2.position = ccp(self.contentSize.width/2, self.contentSize.height/2 - 30);
						
						[[self.parent getChildByTag:3] unschedule:@selector(updateTime:)];
						
						CCNode *node = [OverlayLayer node];
						[node addChild:label1];
						[node addChild:label2];
						
						[self addChild:node];
						printf("dead wave played");
						[[SimpleAudioEngine sharedEngine] playEffect:@"dead.wav"];
						
						[game reset];
						[game nextLevel];
						
					}
					else {
						CCLabelTTF *label = [CCLabelTTF labelWithString:@"Ouch !!!!" fontName:@"Marker Felt" fontSize:30];
						label.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
						[self addChild:label];
						id dl = [CCDelayTime actionWithDuration:1];
						[label runAction: [CCSequence actions:dl,[CCFadeOut actionWithDuration:2],nil]];
					}



					//for(CCSprite * spr in [[self.parent getChildByTag:1] children]){
//						[[CCActionManager sharedManager] pauseTarget:spr]; 
//					}
					
					for(CCSprite * spr in [self children]){
						if (spr.tag == 1) {
							NSLog(@"sdfsd");
						}
						else{
							//[[CCActionManager sharedManager] pauseTarget:spr];
						}
					}
					//[self unschedule:@selector(spawnObjects:)];
					
					//stop further collision detection by changing the tag
					[self makeInvulnerable];
					//show falling animation
				}
			}
			else if (collisionSprite.tag >=100){
				[[SimpleAudioEngine sharedEngine] playEffect:@"bonus.wav"];
				NSLog(@"Good collision");
				if (collisionSprite.tag == kTagLife) {
					if (game.lives<5) {
						game.lives++;
						[hud increaseLives:YES];
					}
				}
				if (collisionSprite.tag == kTagSpeed) {
					
				}
				if (collisionSprite.tag == kTagTime) {
					
				}
				if (collisionSprite.tag == kTagShield) {
					for(int i=0;i<2;i++){
						CCParticleSystem *emitter = [[[CCParticleFlower alloc] initWithTotalParticles:15] autorelease];
						CCSprite *spr = (CCSprite *)[self getChildByTag:1];
						[spr addChild:emitter z:2];
						emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire-grayscale.png"];
						emitter.position = ccp(spr.contentSize.width/2,spr.contentSize.height/2);
						emitter.life = 2;
						emitter.duration = 2;
					}
					[self makeInvulnerable];
				}
				toDestroy.push_back(collisionBody);
			}  
		}
    }
	
	// Loop through all of the box2d bodies we wnat to destroy...
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;     
        
        // See if there's any user data attached to the Box2D body
        if (body->GetUserData() != NULL) {
            
            // We know that the user data is a sprite since we set
            // it that way, so cast it...
            CCSprite *sprite = (CCSprite *) body->GetUserData();
            
            // Remove the sprite from the scene
            [self removeChild:sprite cleanup:YES];
        }
        
        // Destroy the Box2D body as well
        world->DestroyBody(body);
    }
	
}

-(void)jumpDone{
	game.playerStatus = PlayerStatusMoving;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	touchLocation = [touch locationInView: [touch view]];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if(game.playerStatus != PlayerStatusJumping){
		UITouch *touch = [touches anyObject];
		CGPoint location = [touch locationInView: [touch view]];
		
		double diffx = touchLocation.x - location.x + 0.1;  // adding 0.1 to avoid division by zero
		double diffy = touchLocation.y - location.y + 0.1; // adding 0.1 to avoid division by zero
		
		//vertical swipe
		if(abs(diffy / diffx) > 1 && abs(diffy) > SWIPE_DRAG_MIN){
			if (diffy > 0) {
				//jump
				[[SimpleAudioEngine sharedEngine] playEffect:@"jump.mp3"];
				NSLog(@"jump");
				game.playerStatus = PlayerStatusJumping;
				CCSprite *actor = (CCSprite *)[self getChildByTag:kTagActor];
				id action = [CCSequence actions: [CCJumpBy actionWithDuration:1.5 position:ccp(0,0) height:150 jumps:1], 
							 [CCCallFuncN actionWithTarget:self selector:@selector(jumpDone)],nil];
				[actor runAction:action];
			}
			else {
				if(game.playerStatus != PlayerStatusDucking){
					//duck
					[[SimpleAudioEngine sharedEngine] playEffect:@"dodge.mp3"];
					NSLog(@"duck");
					game.playerStatus = PlayerStatusDucking;
				}
			}
		}
		
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if(levelCompleted){
		if([game nextLevel]){
			self.isTouchEnabled = NO;
			CCScene *playScene = [CCScene node];
			BackgroundLayer *backgroundLayer = [BackgroundLayer node];
			HouseLayer *houseLayer = [HouseLayer node];
			HUDLayer *hudLayer = [HUDLayer node];
			HelloWorld *gameLayer = [HelloWorld node];
			
			[playScene addChild:backgroundLayer z:0 tag:0];
			[playScene addChild:houseLayer z:1 tag:1];
			[playScene addChild:gameLayer z:2 tag:2];
			[playScene addChild:hudLayer z:3 tag:3];
			
			[[CCDirector sharedDirector] replaceScene:playScene];
		}
		else {
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameModel"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			self.isTouchEnabled = NO;
			CCScene *finishScene = [CCScene node];
			BackgroundLayer *backgroundLayer = [BackgroundLayer node];
			CCLabelTTF *label1 = [CCLabelTTF labelWithString:[NSString stringWithFormat: @"Congratulation!! You completed the game"] fontName:@"Marker Felt" fontSize:25];
			label1.color = ccBLACK;
			label1.position = ccp(self.contentSize.width/2, self.contentSize.height/2 + 100);
			[backgroundLayer addChild:label1];
			
			CCLabelTTF *label = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:35];
			CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goBack:)];
			CCMenu *back = [CCMenu menuWithItems:backItem, nil];
			back.position = ccp (self.contentSize.width / 2, self.contentSize.height/2 - 100);
			[backgroundLayer addChild:back];
			[finishScene addChild:backgroundLayer z:0 tag:0];
			[[CCDirector sharedDirector] replaceScene:finishScene];
		}

	}
	if (gameOver) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameModel"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		CCScene *menuScene = [CCScene node];
		MenuLayer *menuLayer = [MenuLayer node];
		[menuScene addChild:menuLayer z:0 tag:0];
		[[CCDirector sharedDirector] replaceScene:menuScene];
	}
}

- (void)goBack:(id)sender {
	CCScene *menuScene = [CCScene node];
	MenuLayer *menuLayer = [MenuLayer node];
	[menuScene addChild:menuLayer z:0 tag:0];
	[[CCDirector sharedDirector] replaceScene:menuScene];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	delete _contactListener;
	delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
