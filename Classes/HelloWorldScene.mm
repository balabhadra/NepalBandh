//
//  HelloWorldScene.mm
//  NepalBandh
//
//  Created by Bala Bhadra Maharjan on 10/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


// Import the interfaces
#import "HelloWorldScene.h"

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

// initialize your instance here
-(id) init
{
	if( (self=[super init])) {
		game = [(NepalBandhAppDelegate *)[[UIApplication sharedApplication] delegate] game]; 
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
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
		world->SetDebugDraw(m_debugDraw);
		
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
		[NSTimer scheduledTimerWithTimeInterval:game.levelDuration target:self selector:@selector(levelComplete) userInfo:nil repeats:NO];
	}
	return self;
}

-(void)levelComplete{
	
}

- (BOOL)spawnCollectable {
	NSString *spriteName;
	NSInteger sprite_tag;
	switch ([game getCollectableType]) {
		case CollectableSpeed:
			spriteName = @"bonus_speed.png";
			sprite_tag = kTagSpeed; 
			break;
		case CollectableLife:
			spriteName = @"bonus_life.png";
			sprite_tag = kTagLife; 
			break;
		case CollectableTime:
			spriteName = @"bonus_time.png";
			sprite_tag = kTagTime;
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

    [collectableSprite runAction:[CCMoveTo actionWithDuration:(1.0f/game.speed)*150 position:ccp(-24,220)]]; 
 //   [self addBoxBodyForSprite:car];
    [self addChild:collectableSprite z:0 tag:sprite_tag];
    return YES;
}

- (BOOL)spawnMovingEnemy {
    return NO;
}

- (BOOL)spawnStaticEnemy {
  //  NSString *spriteName;
//	NSInteger sprite_tag;
//	switch ([game getStaticEnemyType]) {
//		case EnemyStone:
//			spriteName = @"enemy_stone.png";
//			sprite_tag = kTagStone; 
//			break;
//		case EnemyThorn:
//			spriteName = @"enemy_thorn.png";
//			sprite_tag = kTagThorn;
//			break;
//		case EnemyFire:
//			spriteName = @"enemy_fire.png";
//			sprite_tag = kTagFire; 
//			break;
//		default:
//			return NO;
//	}
//    CCSprite *enemySprite = [CCSprite spriteWithFile:spriteName];
//    enemySprite.position = ccp(550, 52);
//    enemySprite.tag = sprite_tag;
//	
//    [enemySprite runAction:[CCMoveTo actionWithDuration:(1.0f/game.speed)*150 position:ccp(-24,220)]]; 
//	//   [self addBoxBodyForSprite:car];
//    [self addChild:enemySprite z:0 tag:sprite_tag];
//    return YES;
	return NO;
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
			[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(movingEnemySpawnExpired) userInfo:nil repeats:NO];
		}
	}
	
	if(!recentStaticEnemySpawn) {
		recentStaticEnemySpawn = [self spawnStaticEnemy];
		if (recentStaticEnemySpawn) {
			[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(staticEnemySpawnExpired) userInfo:nil repeats:NO];
		}
	}
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
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin(); pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        // Get the box2d bodies for each object
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            
            // Is sprite A a cat and sprite B a car?  If so, push the cat on a list to be destroyed...
            if (spriteA.tag == 1 || spriteB.tag == 1) {
                //Meaningful Collision
				NSLog(@"collision");
            } 
        }        
    }
	
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
				NSLog(@"jump");
				game.playerStatus = PlayerStatusJumping;
			}
			else {
				if(game.playerStatus != PlayerStatusDucking){
					//duck
					NSLog(@"duck");
					game.playerStatus = PlayerStatusDucking;
				}
			}
		}
		
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
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
