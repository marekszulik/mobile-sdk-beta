//
//  SPTremorNetwork.m
//
//  Created on 24.06.2014.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPTremorNetwork.h"
#import "SPTremorInterstitialAdapter.h"
#import "SPLogger.h"
#import "SPSemanticVersion.h"
#import "SPTPNGenericAdapter.h"

NSString *const SPTremorInterstitialAppId = @"SPTremorInterstitialAppId";
NSString *const SPTremorRewardedVideoAppId = @"SPTremorRewardedVideoAppId";

static NSString *const SPInterstitialAdapterClassName = @"SPTremorInterstitialAdapter";
static NSString *const SPRewardedVideoAdapterClassName = @"SPTremorRewardedVideoAdapter";

static const NSInteger SPTremorVersionMajor = 2;
static const NSInteger SPTremorVersionMinor = 1;
static const NSInteger SPTremorVersionPatch = 0;

@interface SPTremorNetwork ()

@property (nonatomic, strong) SPTremorInterstitialAdapter *interstitialAdapter;
@property (nonatomic, strong) SPTPNGenericAdapter *rewardedVideoAdapter;

@end

@implementation SPTremorNetwork

@synthesize interstitialAdapter = _interstitialAdapter;
@synthesize rewardedVideoAdapter = _rewardedVideoAdapter;

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPTremorVersionMajor minor:SPTremorVersionMinor patch:SPTremorVersionPatch];
}

- (id)init
{
    self = [super init];
    if (self) {
        Class RewardedVideoAdapterClass = NSClassFromString(SPRewardedVideoAdapterClassName);
        if (RewardedVideoAdapterClass) {
            id<SPRewardedVideoNetworkAdapter> tremorRewardedVideoNetworkAdapter = [[RewardedVideoAdapterClass alloc] init];
            self.rewardedVideoAdapter = [[SPTPNGenericAdapter alloc] initWithVideoNetworkAdapter:tremorRewardedVideoNetworkAdapter];
            tremorRewardedVideoNetworkAdapter.delegate = self.rewardedVideoAdapter;
        }

        Class InterstitialAdapterClass = NSClassFromString(SPInterstitialAdapterClassName);
        if (InterstitialAdapterClass) {
            self.interstitialAdapter = [[InterstitialAdapterClass alloc] init];
        }
    }
    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_6_0) {
        SPLogError(@"Could not start Tremor Provider. Tremor SDK supports only iOS 6 or higher.");
        return NO;
    }
    
    NSString *interstitialAppId = data[SPTremorInterstitialAppId];
    NSString *rewardedVideoAppId = data[SPTremorRewardedVideoAppId];

    BOOL isInterstitialAppIdCorrect = [interstitialAppId isKindOfClass:[NSString class]] && [interstitialAppId length];
    BOOL isRewardedVideoAppIdCorrect = [rewardedVideoAppId isKindOfClass:[NSString class]] && [rewardedVideoAppId length];

    if (!isInterstitialAppIdCorrect && !isRewardedVideoAppIdCorrect) {
        SPLogError(@"Could not start %@ network. %@ and %@ incorrect or missing.", self.name, SPTremorRewardedVideoAppId, SPTremorInterstitialAppId);
        return NO;
    }
    NSArray *appIds = nil;
    if (isInterstitialAppIdCorrect && isRewardedVideoAppIdCorrect) {
        appIds = @[interstitialAppId, rewardedVideoAppId];
    } else if (interstitialAppId) {
        appIds = @[interstitialAppId];
    } else {
        appIds = @[rewardedVideoAppId];
    }
    
    [TremorVideoAd initWithAppIDList:appIds];
    [TremorVideoAd start];
    return YES;
}

@end
