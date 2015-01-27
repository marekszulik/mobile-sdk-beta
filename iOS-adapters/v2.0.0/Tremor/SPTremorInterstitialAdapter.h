//
//  SPTremorInterstitialAdapter.m
//
//  Created on 24.06.2014.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPTremorNetwork.h"

@class SPTremorInterstitialAdapter;

/**
 Implementation of Tremor network for interstitials demand

 ## Version compatibility

 - Adapter version: 2.1.0
 - Fyber SDK version: 7.0.3
 - Tremor SDK version: 3.9

 */

@interface SPTremorInterstitialAdapter : NSObject<SPInterstitialNetworkAdapter>

@property (weak, nonatomic) SPTremorNetwork *network;

@end
