//
//  HighScoreLayer.h
//  NepalBandh
//
//  Created by Rajan Maharjan on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define NAME_MENU_TAG	101
#define SCORE_MENU_TAG	102
#define PEARL_MENU_TAG	103


@interface HighScoreLayer : CCLayer <UITextFieldDelegate> {
	NSInteger indexToEdit;
	NSMutableArray *scoreArray, *nameArray;

}

- (id)initWithHighScore:(NSInteger)score;
- (void)createHighScoreList;
- (BOOL)editHighScoreList:(NSInteger)highScore;
- (void)displayHighScoreList: (BOOL)needsUserInput;
- (void)updateHighScoreWithUser:(NSString *)name;

@end
