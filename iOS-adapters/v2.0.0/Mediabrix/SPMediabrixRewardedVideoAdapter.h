//
//  SPMediabrixRewardedVideoAdapter.m
//
//  Created on 07/05/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPRewardedVideoNetworkAdapter.h"

@class SPMediabrixNetwork;

@interface SPMediabrixRewardedVideoAdapter : NSObject <SPRewardedVideoNetworkAdapter>

@property (nonatomic, weak) SPMediabrixNetwork *network;

@end
