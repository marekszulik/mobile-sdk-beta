//
//  SPMediabrixRewardedVideoAdapter.m
//
//  Created on 07/05/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPMediabrixRewardedVideoAdapter.h"
#import "SPMediabrixNetwork.h"
#import "SPLogger.h"
#import "MediaBrix.h"

typedef NS_ENUM(NSInteger, SPMediabrixAdState) {
    SPMediabrixAdStateNotAvailable,
    SPMediabrixAdStateLoading,
    SPMediabrixAdStateAvailable
};

@interface SPMediabrixRewardedVideoAdapter ()

@property (nonatomic, assign) SPMediabrixAdState adState;
@property (nonatomic, assign) BOOL userRewarded;
@property (nonatomic, strong) NSString *rescueZone;
@property (nonatomic, weak) UIViewController<MediaBrixAdViewController> *viewController;

- (void)loadAd;

@end

@implementation SPMediabrixRewardedVideoAdapter

@synthesize delegate;

- (NSString *)networkName
{
    return self.network.name;
}

- (BOOL)startAdapterWithDictionary:(NSDictionary *)data
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adWillLoad:) name:kMediaBrixAdWillLoadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adDidLoad:) name:kMediaBrixAdDidLoadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adDidFail:) name:kMediaBrixAdFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adReady:) name:kMediaBrixAdReadyNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adShow:) name:kMediaBrixAdShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adClose:) name:kMediaBrixAdDidCloseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adRewardConfirmation:) name:kMediaBrixAdRewardNotification object:nil];
    
    if (!self.network.rescueZone.length) {
        SPLogError(@"[%@] Could not start MediaBrix Provider. `RescueZone` parameter for Rewarded Video is missing or empty", self.networkName);
        return NO;
    }
    
    [self loadAd];

    return YES;
}

- (void)loadAd
{
    self.adState = SPMediabrixAdStateLoading;
    NSDictionary *target = @{
                             kMediabrixTargetAdTypeKey: self.network.rescueZone,
                             kMediabrixTargetPropertyKey: self.network.appId
                             };
    [[MediaBrix sharedInstance] loadAdWithTarget:target];
}

- (void)checkAvailability
{
    if (self.adState == SPMediabrixAdStateNotAvailable) {
        [self loadAd];
    } else {
        [self.delegate adapter:self didReportVideoAvailable:YES];
    }
}

- (void)playVideoWithParentViewController:(UIViewController *)parentVC
{
    self.adState = SPMediabrixAdStateNotAvailable;
    [self.viewController showInViewController:parentVC];
}

#pragma mark - MediaBrix notifications

- (void)adWillLoad:(NSNotification *)notification
{
    NSLog(@"[MediaBrix] notification: adWillLoad %@", notification.object);
}

- (void)adDidLoad:(NSNotification *)notification
{
    NSLog(@"[MediaBrix] notification: adDidLoad %@", notification.object);
}

- (void)adDidFail:(NSNotification *)notification
{
    NSLog(@"[MediaBrix] notification: adDidFail, %@", notification);
    if (self.adState != SPMediabrixAdStateNotAvailable) {
        self.adState = SPMediabrixAdStateNotAvailable;
        [self.delegate adapter:self didFailWithError:nil];
    }
}

- (void)adReady:(NSNotification *)notification
{
    NSLog(@"[MediaBrix] notification: adReady %@", notification.object);
    self.viewController = [notification object];
    self.adState = SPMediabrixAdStateAvailable;
    [self.delegate adapter:self didReportVideoAvailable:YES];
}

- (void)adShow:(NSNotification *)notification
{
    NSLog(@"[MediaBrix] notification: adShow %@", notification.object);
    self.userRewarded = NO;
    [self.delegate adapterVideoDidStart:self];
}

- (void)adRewardConfirmation:(NSNotification *)notification
{
    NSLog(@"[MediaBrix] notification: adRewardConfirmation %@", notification.object);
    self.userRewarded = YES;
    [self.delegate adapterVideoDidFinish:self];
}

- (void)adClose:(NSNotification *)notification
{
    NSLog(@"[MediaBrix] notification: adClose %@", notification.object);
    if (self.userRewarded) {
        [self.delegate adapterVideoDidClose:self];
        
    } else {
        [self.delegate adapterVideoDidAbort:self];
    }
}

#pragma mark - lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
