//
//  NepalBandhAppDelegate.h
//  NepalBandh
//
//  Created by Bala Bhadra Maharjan on 10/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"

@class RootViewController;

@interface NepalBandhAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
	GameModel *game;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) GameModel *game;

@end
