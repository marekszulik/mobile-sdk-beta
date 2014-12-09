//
//  SPTremorInterstitialAdapter.m
//
//  Created on 24.06.2014.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPTremorInterstitialAdapter.h"
#import "SPTremorNetwork.h"
#import "SPLogger.h"

#ifndef LogInvocation
#define LogInvocation SPLogDebug(@"%s", __PRETTY_FUNCTION__)
#endif
@interface SPTremorInterstitialAdapter () <TremorVideoAdDelegate>
@property (weak, nonatomic) id<SPInterstitialNetworkAdapterDelegate> delegate;
@property (nonatomic, copy) NSString *appId;
@end

@implementation SPTremorInterstitialAdapter

@synthesize offerData;

- (NSString *)networkName
{
    return [self.network name];
}

- (BOOL)startAdapterWithDict:(NSDictionary *)dict
{
    LogInvocation;
    self.appId = dict[SPTremorInterstitialAppId];
    if (!self.appId.length) {
        SPLogError(@"Could not start %@ interstital adapter. %@ incorrect or missing.", self.network.name, SPTremorInterstitialAppId);
        return NO;
    }
    return YES;
}

#pragma mark - SPInterstitialNetworkAdapter protocol

- (BOOL)canShowInterstitial
{
    LogInvocation;
    return [TremorVideoAd isAdReadyWithAppID:self.appId];
}

- (void)showInterstitialFromViewController:(UIViewController *)viewController
{
    LogInvocation;
    [TremorVideoAd setDelegate:self];
    [TremorVideoAd showAdWithAppID:self.appId onViewController:viewController];
}

- (void)willPresentInterstitial
{
    [self.delegate adapterDidShowInterstitial:self];
}

#pragma mark - TremorVideoAdDelegate

- (void)didAdComplete
{
    LogInvocation;
    [self.delegate adapter:self didDismissInterstitialWithReason:SPInterstitialDismissReasonUserClosedAd];
}

@end
