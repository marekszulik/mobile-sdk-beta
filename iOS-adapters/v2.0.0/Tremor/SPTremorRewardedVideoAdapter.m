//
//  SPTremorRewardedVideoAdapter.m
//
// Created on 28/11/14.
// Copyright 2011-2013 Fyber. All rights reserved.
//

#import "SPTremorRewardedVideoAdapter.h"
#import "SPTremorNetwork.h"
#import "SPLogger.h"

#ifndef LogInvocation
#define LogInvocation SPLogDebug(@"%s", __PRETTY_FUNCTION__)
#endif

@interface SPTremorRewardedVideoAdapter () <TremorVideoAdDelegate>
@property (nonatomic, copy) NSString *appId;
@end

@implementation SPTremorRewardedVideoAdapter

@synthesize delegate;

- (NSString *)networkName
{
    return self.network.name;
}

- (BOOL)startAdapterWithDictionary:(NSDictionary *)dict
{
    self.appId = dict[SPTremorRewardedVideoAppId];
    if (!self.appId.length) {
        SPLogError(@"Could not start %@ rewarded video adapter. %@ incorrect or missing.", self.network.name, SPTremorRewardedVideoAppId);
        return NO;
    }

    return YES;
}

- (void)checkAvailability
{
    [self.delegate adapter:self didReportVideoAvailable:[TremorVideoAd isAdReadyWithAppID:self.appId]];
}

- (void)playVideoWithParentViewController:(UIViewController *)parentVC
{
    LogInvocation;
    [TremorVideoAd setDelegate:self];
    [TremorVideoAd showAdWithAppID:self.appId onViewController:parentVC];
}

- (void)didAdComplete:(BOOL)adCompleted
{
    LogInvocation;
    if (adCompleted) {
        [self.delegate adapterVideoDidFinish:self];
        [self.delegate adapterVideoDidClose:self];
    } else {
        [self.delegate adapterVideoDidAbort:self];
    }
}

- (void)willLeaveApplicaton
{
    LogInvocation;
}

- (void)willPresentInterstitial
{
    LogInvocation;
    [self.delegate adapterVideoDidStart:self];
}

- (void)willDismissInterstitial
{
    LogInvocation;
}

@end
