//
//  SPFacebookNetwork.m
//
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPFacebookNetwork.h"
#import "SPFacebookInterstitialAdapter.h"
#import "SPSemanticVersion.h"
#import "SPSystemVersionChecker.h"
#import "SPLogger.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>

static const NSInteger SPFacebookVersionMajor = 2;
static const NSInteger SPFacebookVersionMinor = 0;
static const NSInteger SPFacebookVersionPatch = 1;

static NSString *const SPFacebookTestDevices = @"SPFacebookTestDevices";

@interface SPFacebookAudienceNetworkNetwork ()

@property (strong, nonatomic) SPFacebookInterstitialAdapter *interstitialAdapter;

@end

@implementation SPFacebookAudienceNetworkNetwork

@synthesize interstitialAdapter = _interstitialAdapter;

#pragma mark - Class Methods

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPFacebookVersionMajor
                                         minor:SPFacebookVersionMinor
                                         patch:SPFacebookVersionPatch];
}


#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        _interstitialAdapter = [[SPFacebookInterstitialAdapter alloc] init];
    }
    return self;
}


- (BOOL)startSDK:(NSDictionary *)data
{
    NSArray *testDevices = data[SPFacebookTestDevices];

    if (![SPSystemVersionChecker runningOniOS7OrNewer]) {
        SPLogError(@"Facebook adapter supports only iOS 7 or higher");
        return NO;
    }

    if (testDevices && [testDevices isKindOfClass:[NSArray class]]) {
        [FBAdSettings addTestDevices:testDevices];
    } else {
        SPLogWarn(@"%@ parameter is not an array.", SPFacebookTestDevices);
    }

    return YES;
}


- (void)startInterstitialAdapter:(NSDictionary *)data
{
    // Customize it when necessary
    // The data dictionary contains the SPNetworkParameters dictionary read from the plist file
    [super startInterstitialAdapter:data];
}

@end
