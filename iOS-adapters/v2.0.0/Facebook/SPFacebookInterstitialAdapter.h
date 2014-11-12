//
//  SPFacebookInterstitialAdapter.m
//
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPFacebookNetwork.h"

/**
 Implementation of FacebookAudienceNetwork network for Interstitial demand
 
 ## Version compatibility
 
 - Adapter version: 2.0.1
 - Fyber SDK version: 7.0.0
 - FacebookAudienceNetwork SDK version: 3.20
 
 */

@class SPFacebookInterstitialAdapter;

@interface SPFacebookInterstitialAdapter : NSObject <SPInterstitialNetworkAdapter>

@property (weak, nonatomic) SPFacebookAudienceNetworkNetwork *network;

@end
