//
//  SPTremorRewardedVideoAdapter.h
//
//  Created by on 5/30/13.
//  Copyright 2011-2013 Fyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SPRewardedVideoNetworkAdapter.h"

@class SPTremorNetwork;

/**
 Implementation of Tremor network for Rewarded Video demand

 ## Version compatibility

 - Adapter version: 2.1.0
 - Fyber SDK version: 7.0.3
 - Tremor SDK version: 3.9

 */

@interface SPTremorRewardedVideoAdapter : NSObject<SPRewardedVideoNetworkAdapter>

@property (nonatomic, weak) SPTremorNetwork *network;

@end
