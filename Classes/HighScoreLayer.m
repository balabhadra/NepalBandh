//
//  HighScoreLayer.m
//  NepalBandh
//
//  Created by Rajan Maharjan on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HighScoreLayer.h"
#import "MenuLayer.h"

@implementation HighScoreLayer

-(id)init{
	if((self = [super init])){
		
		CGSize winSize = [CCDirector sharedDirector].winSize;
		CCSprite *frontBackground = [CCSprite spriteWithFile:@"frontBackground.png"];
		
		frontBackground.position = ccp(winSize.width / 2, winSize.height / 2);
		
		[self addChild:frontBackground];
//		[FlurryAPI logEvent:[NSString stringWithFormat: @"High Scores"]];
		[self createHighScoreList];
		[self displayHighScoreList:NO];
	}
	return self;
}

-(id)initWithHighScore:(NSInteger)highScore {
	if( (self = [super init]) ){
		CGSize winSize = [CCDirector sharedDirector].winSize;
		CCSprite *frontBackground = [CCSprite spriteWithFile:@"frontBackground.png"];
		
		frontBackground.position = ccp(winSize.width / 2, winSize.height / 2);
		
		[self addChild:frontBackground];
//		[FlurryAPI logEvent:@"High Scores"];
		[self createHighScoreList];
		[self displayHighScoreList:[self editHighScoreList:highScore]];
	}
	return self;
}

//create default highscore if not already created.
- (void)createHighScoreList{
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"HighScores"] == nil){
#ifndef LITE_VERSION
		scoreArray = [[NSMutableArray arrayWithObjects:	[NSNumber numberWithInt:50000],
					   [NSNumber numberWithInt:45000],
					   [NSNumber numberWithInt:40000],
					   [NSNumber numberWithInt:35000],
					   [NSNumber numberWithInt:30000],
					   [NSNumber numberWithInt:25000],
					   [NSNumber numberWithInt:20000],	
					   [NSNumber numberWithInt:15000],	
					   [NSNumber numberWithInt:10000],	
					   [NSNumber numberWithInt:5000],nil] retain];
#else
		scoreArray = [[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:50000],
					   [NSNumber numberWithInt:40000],
					   [NSNumber numberWithInt:30000],
					   [NSNumber numberWithInt:20000],
					   [NSNumber numberWithInt:10000],
					   [NSNumber numberWithInt:5000],
					   [NSNumber numberWithInt:4000],	
					   [NSNumber numberWithInt:3000],	
					   [NSNumber numberWithInt:2000],	
					   [NSNumber numberWithInt:1000],nil] retain];
#endif		
		nameArray = [[NSMutableArray arrayWithObjects:   @"John",
					  @"William",
					  @"Jack",	
					  @"Jeff",
					  @"Betty",
					  @"Matt",	
					  @"Simon",
					  @"Sarah",
					  @"Doug",
					  @"Derek",nil] retain];

		[[NSUserDefaults standardUserDefaults] setObject:scoreArray forKey:@"HighScores"];
		[[NSUserDefaults standardUserDefaults] setObject:nameArray forKey:@"HighScorers"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else{
		scoreArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HighScores"] mutableCopy];
		nameArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HighScorers"] mutableCopy];
	}
}

//If a score makes it to highscore table, this method removes the lowest score and inserts the highscore to correct position. 
//At this point user has not entered his name. So name is set to blank.

- (BOOL)editHighScoreList:(NSInteger)highScore {
	NSAssert(highScore >= 0, @"HighScore is less than 0");
	BOOL isEdited = NO;
	for (NSNumber *score in scoreArray) {
		if(highScore > [score intValue]){
			indexToEdit = [scoreArray indexOfObject:score];
			isEdited = YES;
			break;
		}
	}
	
	if(isEdited){
		[scoreArray removeLastObject];
		[nameArray removeLastObject];

		[scoreArray insertObject:[NSNumber numberWithInt:highScore] atIndex:indexToEdit];
		[nameArray insertObject:@" " atIndex:indexToEdit];
		[[NSUserDefaults standardUserDefaults] setObject:scoreArray forKey:@"HighScores"];
		[[NSUserDefaults standardUserDefaults] setObject:nameArray forKey:@"HighScorers"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	return isEdited;
}

//Replace the blank name with the name entered by user
- (void)updateHighScoreWithUser:(NSString *)name{
	[nameArray replaceObjectAtIndex:indexToEdit withObject:name];
	[[NSUserDefaults standardUserDefaults] setObject:nameArray forKey:@"HighScorers"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

//Display the high score to the user. If the user made it to highscore top 10, this method will display a textfield for input.
- (void)displayHighScoreList:(BOOL)needsUserInput{
	CGSize winSize = [CCDirector sharedDirector].winSize;
	[CCMenuItemFont setFontName: @"Marker Felt"];
	[CCMenuItemFont setFontSize:26];
	CCMenu *nameMenu = [CCMenu menuWithItems:[CCMenuItemFont itemFromString: @"NAME"],nil];
	CCMenu *scoreMenu = [CCMenu menuWithItems:[CCMenuItemFont itemFromString: @"SCORE"],nil];
	
	CCLabelTTF *label = [CCLabelTTF labelWithString:@"Back" fontName:@"Marker Felt" fontSize:35];
	CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(onBack:)];
	
	CCMenu *backMenu = [CCMenu menuWithItems: backItem,nil];
	[CCMenuItemFont setFontSize:18];
	for (int i=0; i<[scoreArray count]; i++) {
		CCMenuItem *nameItem = [CCMenuItemFont itemFromString: [nameArray objectAtIndex:i]];
		CCMenuItem *scoreItem = [CCMenuItemFont itemFromString: [[scoreArray objectAtIndex:i] stringValue]];

		[nameItem setIsEnabled:NO];
		[scoreItem setIsEnabled:NO];

		[nameMenu addChild:nameItem z:0 tag:i*3];
		[scoreMenu addChild:scoreItem z:0 tag:i*3+1];
	}
	
	nameMenu.position = ccp(winSize.width / 4 + 55, winSize.height / 2 + winSize.height / 4 - 50 - 25);
	scoreMenu.position = ccp(winSize.width - winSize.width / 4 + 55, winSize.height / 2 + winSize.height / 4 - 50 - 25);
	backMenu.position = ccp(backItem.contentSize.width ,  backItem.contentSize.height);
	
	[nameMenu setColor:ccWHITE];
	[scoreMenu setColor:ccWHITE];
	
	[nameMenu alignItemsVerticallyWithPadding:5.0];
	[scoreMenu alignItemsVerticallyWithPadding:5.0];
	[backMenu alignItemsVerticallyWithPadding:0];
	
	[self addChild:nameMenu z:0 tag:NAME_MENU_TAG];
	[self addChild:scoreMenu z:0 tag:SCORE_MENU_TAG];
	[self addChild:backMenu];
	
//	CCSprite *frame =[CCSprite spriteWithFile:[GameResource sharedResource].frameFile];
//	CCParallaxNode *pNode1 = [CCParallaxNode node];
//	[pNode1 addChild:frame z:0 parallaxRatio:ccp(0,0) positionOffset:ccp(screenSize.width/2,screenSize.height/2)];
//	pNode1.position = ccp(screenSize.width/2,screenSize.height/2);
//	[self addChild:pNode1];
	
	if(needsUserInput){
		CCMenuItem * itemToChange = (CCMenuItem *)[nameMenu getChildByTag:3*indexToEdit];
		CGPoint pos = [nameMenu convertToWorldSpace:itemToChange.position];
		NSInteger offset = (pos.y < 280) ? (280- pos.y) : 0;
		UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(pos.x - 20, 480 - pos.y - offset -10, 150, 20)];
		nameField.delegate = self;
		nameField.textColor = [UIColor whiteColor];
		nameField.font = [UIFont fontWithName:@"Marker Felt" size:18];
		nameField.autocorrectionType = UITextAutocorrectionTypeNo;
		[[[[CCDirector sharedDirector] openGLView] window] addSubview:nameField];
		[nameField becomeFirstResponder];
		if(pos.y < 280)
			self.position= ccp(self.position.x,self.position.y + (280 - pos.y));
	}
}

#pragma mark -
#pragma mark UITextField delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
	[theTextField release];
	NSString *name = (theTextField.text == nil || [theTextField.text isEqual:@""]) ? @" " : theTextField.text;
	[self updateHighScoreWithUser:name];
	[(CCMenuItemFont *)[(CCMenu *)[self getChildByTag:NAME_MENU_TAG] getChildByTag:3*indexToEdit] setString:name];
	[self runAction:[CCMoveTo actionWithDuration:.5 position:ccp(0,0)]];
	[theTextField removeFromSuperview];
	return YES;	
}

//limit the username to 10 characters.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	if(textField.text.length >= 10 && string.length > 0)
		return NO;
	return YES;
}

//clicked on back to menu
- (void)onBack:(id)sender{
//	if([GameResource sharedResource].isEffectOn)
//		[[SimpleAudioEngine sharedEngine] playEffect:[GameResource sharedResource].clickSound];
	CCScene *menuScene = [CCScene node];
	MenuLayer *menuLayer = [MenuLayer node];
	[menuScene addChild:menuLayer z:0 tag:0];
    [[CCDirector sharedDirector] replaceScene:menuScene];	
}

- (void)dealloc{
	[scoreArray release];
	[nameArray release];
	[super dealloc];
}

@end
