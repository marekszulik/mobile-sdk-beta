//
//  SPMediabrixNetwork.m
//
//  Created on 12/15/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

// Adapter versioning - Remember to update the header

#import "SPMediabrixNetwork.h"
#import "SPTPNGenericAdapter.h"
#import "SPSemanticVersion.h"
#import "SPLogger.h"
#import "MediaBrix.h"
#import <AdSupport/ASIdentifierManager.h>

static const NSInteger SPMediabrixVersionMajor = 2;
static const NSInteger SPMediabrixVersionMinor = 0;
static const NSInteger SPMediabrixVersionPatch = 0;

static NSString *const SPMediabrixAppId = @"SPMediabrixAppId";
static NSString *const SPMediabrixProperty = @"SPMediabrixProperty";
static NSString *const SPMediabrixBaseURL = @"SPMediabrixBaseURL";
static NSString *const SPMediabrixRescueZone = @"SPMediabrixRescueZone";
static NSString *const SPMediabrixFacebookAppId = @"SPMediabrixFacebookAppId";
static NSString *const SPMediabrixGeoEnabled = @"SPMediabrixGeoEnabled";
static NSString *const SPMediabrixCalendarEnabled = @"SPMediabrixCalendarEnabled";
static NSString *const SPMediabrixCameraEnabled = @"SPMediabrixCameraEnabled";
static NSString *const SPMediabrixUID = @"SPMediabrixUID";
static NSString *const SPMediabrixRewardText = @"SPMediabrixRewardText";
static NSString *const SPMediabrixRewardIconURL = @"SPMediabrixRewardIconURL";
static NSString *const SPMediabrixOptInMessageEnabled = @"SPMediabrixOptInMessageEnabled";
static NSString *const SPMediabrixOptInButtonText = @"SPMediabrixOptInButtonText";
static NSString *const SPMediabrixEnticeText = @"SPMediabrixEnticeText";
static NSString *const SPMediabrixRescueTitle = @"SPMediabrixRescueTitle";
static NSString *const SPMediabrixRescueText = @"SPMediabrixRescueText";


static NSString *const SPRewardedVideoAdapterClassName = @"SPMediabrixRewardedVideoAdapter";

#pragma mark - SPMediabrixPropertiesProvider

@interface SPMediabrixPropertiesProvider : NSObject

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *rescueZone;
@property (nonatomic, strong) NSString *facebookAppId;
@property (nonatomic, strong) NSNumber *geoEnabled;
@property (nonatomic, strong) NSNumber *calendarEnabled;
@property (nonatomic, strong) NSNumber *cameraEnabled;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *rewardText;
@property (nonatomic, strong) NSString *rewardIconURL;
@property (nonatomic, strong) NSNumber *optInMessageEnabled;
@property (nonatomic, strong) NSString *optInButtonText;
@property (nonatomic, strong) NSString *enticeText;
@property (nonatomic, strong) NSString *rescueTitle;
@property (nonatomic, strong) NSString *rescueText;

+ (id)sharedInstance;

@end

@implementation SPMediabrixPropertiesProvider

+ (id)sharedInstance
{
    static SPMediabrixPropertiesProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end

#pragma mark - SPMediabrixUserDefaults

@interface SPMediabrixUserDefaults : NSObject <MediaBrixUserDefaults>

@end

@implementation SPMediabrixUserDefaults

- (NSString *)appID
{
    return [[SPMediabrixPropertiesProvider sharedInstance] appId];
}

- (NSURL *)baseURL
{
    return [NSURL URLWithString:(NSString *)[[SPMediabrixPropertiesProvider sharedInstance] baseURL]];
}

- (NSString *)property
{
    return [[SPMediabrixPropertiesProvider sharedInstance] property];
}

- (NSDictionary *)defaultAdData
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MediaBrix" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSArray *adDataKeys = @[@"LogOutButton",
                            @"useMBbutton",
                            @"rescueTitle",
                            @"rescueText",
                            @"enticeText",
                            @"title",
                            @"confirmText",
                            @"iconURL",
                            @"showConfirmation",
                            @"rewardText",
                            @"rewardIcon",
                            @"optinbuttonText",
                            @"loadingText",
                            @"achievementText",
                            @"allowGeo",
                            @"allowCalendar",
                            @"allowCamera"
                            ];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [adDataKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *localizedString = [bundle localizedStringForKey:key value:nil table:nil];
        NSAssert1(localizedString, @"missing localized string for key: %@", key);
        [dict setObject:localizedString forKey:key];
    }];
    
    // SPMediabrixFacebookAppId
    if ([[SPMediabrixPropertiesProvider sharedInstance] facebookAppId]) {
        dict[@"facebookAppId"] = [[SPMediabrixPropertiesProvider sharedInstance] facebookAppId];
    }
    // SPMediabrixGeoEnabled
    if ([[SPMediabrixPropertiesProvider sharedInstance] geoEnabled]) {
        dict[@"allowGeo"] = [[[SPMediabrixPropertiesProvider sharedInstance] geoEnabled] boolValue] ? @"YES" : @"NO";
    }
    // SPMediabrixCalendarEnabled
    if ([[SPMediabrixPropertiesProvider sharedInstance] calendarEnabled]) {
        dict[@"allowCalendar"] = [[[SPMediabrixPropertiesProvider sharedInstance] calendarEnabled] boolValue] ? @"YES" : @"NO";
    }
    // SPMediabrixCameraEnabled
    if ([[SPMediabrixPropertiesProvider sharedInstance] cameraEnabled]) {
        dict[@"allowCamera"] = [[[SPMediabrixPropertiesProvider sharedInstance] cameraEnabled] boolValue] ? @"YES" : @"NO";
    }
    // SPMediabrixUID
    if ([[SPMediabrixPropertiesProvider sharedInstance] uid]) {
        dict[@"uid"] = [[SPMediabrixPropertiesProvider sharedInstance] uid];
    }
    else {
        NSUUID *advertiserId = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        if (advertiserId) {
            dict[@"uid"] = [advertiserId UUIDString];
        }
    }
    // SPMediabrixRewardText
    if ([[SPMediabrixPropertiesProvider sharedInstance] rewardText]) {
        dict[@"rewardText"] = [[SPMediabrixPropertiesProvider sharedInstance] rewardText];
    }
    else {
        dict[@"rewardText"] = @"Coins";
    }
    // SPMediabrixRewardIconURL
    if ([[SPMediabrixPropertiesProvider sharedInstance] rewardIconURL]) {
        dict[@"rewardIcon"] = [[SPMediabrixPropertiesProvider sharedInstance] rewardIconURL];
    }
    // SPMediabrixOptInMessageEnabled
    dict[@"useMBbutton"] = [[[SPMediabrixPropertiesProvider sharedInstance] optInMessageEnabled] boolValue] ? @"true" : @"false";
    // SPMediabrixOptInButtonText
    if ([[SPMediabrixPropertiesProvider sharedInstance] optInButtonText]) {
        dict[@"optinbuttonText"] = [[SPMediabrixPropertiesProvider sharedInstance] optInButtonText];
    }
    else {
        dict[@"optinbuttonText"] = @"Tap for your free coins";
    }
    // SPMediabrixEnticeText
    if ([[SPMediabrixPropertiesProvider sharedInstance] enticeText]) {
        dict[@"enticeText"] = [[SPMediabrixPropertiesProvider sharedInstance] enticeText];
    }
    else {
        dict[@"enticeText"] = @"Watch a short video and";
    }
    // SPMediabrixRescueTitle
    if ([[SPMediabrixPropertiesProvider sharedInstance] rescueTitle]) {
        dict[@"rescueTitle"] = [[SPMediabrixPropertiesProvider sharedInstance] rescueTitle];
    }
    else {
        dict[@"rescueTitle"] = @"Need more coins?";
    }
    // SPMediabrixRescueText
    if ([[SPMediabrixPropertiesProvider sharedInstance] rescueText]) {
        dict[@"rescueText"] = [[SPMediabrixPropertiesProvider sharedInstance] rescueText];
    }
    
    return dict;
}

@end

#pragma mark - NSDictionary (SPMediabrixUtils)

@interface NSDictionary (SPMediabrixUtils)

- (NSString *)stringForKey:(id)aKey;
- (NSNumber *)numberForKey:(id)aKey;

@end

@implementation NSDictionary (SPMediabrixUtils)

- (NSString *)stringForKey:(id)aKey
{
    if (!aKey) {
        return nil;
    }
    return [self[aKey] isKindOfClass:[NSString class]] ? ([self[aKey] length] ? self[aKey] : nil) : nil;
}

- (NSNumber *)numberForKey:(id)aKey
{
    if (!aKey) {
        return nil;
    }
    return [self[aKey] isKindOfClass:[NSNumber class]] ? self[aKey] : nil;
}

@end

#pragma mark - SPMediabrixNetwork

@interface SPMediabrixNetwork ()

@property (nonatomic, strong) SPTPNGenericAdapter *rewardedVideoAdapter;

@end

@implementation SPMediabrixNetwork

@synthesize rewardedVideoAdapter = _rewardedVideoAdapter;

- (instancetype)init
{
    self = [super init];
    if (self) {
        Class RewardedVideoAdapterClass = NSClassFromString(SPRewardedVideoAdapterClassName);
        if (RewardedVideoAdapterClass) {
            id<SPRewardedVideoNetworkAdapter> mediabrixRewardedVideoAdapter = [[RewardedVideoAdapterClass alloc] init];
            
            SPTPNGenericAdapter *mediabrixRewardedVideoAdapterWrapper = [[SPTPNGenericAdapter alloc] initWithVideoNetworkAdapter:mediabrixRewardedVideoAdapter];
            mediabrixRewardedVideoAdapter.delegate = mediabrixRewardedVideoAdapterWrapper;
            
            self.rewardedVideoAdapter = mediabrixRewardedVideoAdapterWrapper;
        }
    }
    return self;
}

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPMediabrixVersionMajor
                                         minor:SPMediabrixVersionMinor
                                         patch:SPMediabrixVersionPatch];
}

- (BOOL)startSDK:(NSDictionary *)data
{
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_6_0) {
        SPLogError(@"[%@] Could not start MediaBrix Provider. MediaBrix SDK supports only iOS 6 or higher.", self.name);
        return NO;
    }
    
    NSString *appId = [data stringForKey:SPMediabrixAppId];
    NSString *property = [data stringForKey:SPMediabrixProperty];
    NSString *baseURL = [data stringForKey:SPMediabrixBaseURL];
    
    if (!appId.length) {
        SPLogError(@"[%@] Could not start MediaBrix Provider. `AppId` parameter is missing or empty", self.name);
        return NO;
    }
    
    if (!property.length) {
        SPLogError(@"[%@] Could not start MediaBrix Provider. `Property` parameter is missing or empty", self.name);
        return NO;
    }
    
    if (!baseURL.length) {
        SPLogError(@"[%@] Could not start MediaBrix Provider. `BaseURL` parameter is missing or empty", self.name);
        return NO;
    }
    
    [[SPMediabrixPropertiesProvider sharedInstance] setAppId:appId];
    [[SPMediabrixPropertiesProvider sharedInstance] setProperty:property];
    [[SPMediabrixPropertiesProvider sharedInstance] setBaseURL:baseURL];
    [[SPMediabrixPropertiesProvider sharedInstance] setRescueZone:[data stringForKey:SPMediabrixRescueZone]];
    [[SPMediabrixPropertiesProvider sharedInstance] setFacebookAppId:[data stringForKey:SPMediabrixFacebookAppId]];
    [[SPMediabrixPropertiesProvider sharedInstance] setGeoEnabled:[data numberForKey:SPMediabrixGeoEnabled]];
    [[SPMediabrixPropertiesProvider sharedInstance] setCalendarEnabled:[data numberForKey:SPMediabrixCalendarEnabled]];
    [[SPMediabrixPropertiesProvider sharedInstance] setCameraEnabled:[data numberForKey:SPMediabrixCameraEnabled]];
    [[SPMediabrixPropertiesProvider sharedInstance] setUid:[data stringForKey:SPMediabrixUID]];
    [[SPMediabrixPropertiesProvider sharedInstance] setRewardText:[data stringForKey:SPMediabrixRewardText]];
    [[SPMediabrixPropertiesProvider sharedInstance] setRewardIconURL:[data stringForKey:SPMediabrixRewardIconURL]];
    [[SPMediabrixPropertiesProvider sharedInstance] setOptInMessageEnabled:[data numberForKey:SPMediabrixOptInMessageEnabled]];
    [[SPMediabrixPropertiesProvider sharedInstance] setOptInButtonText:[data stringForKey:SPMediabrixOptInButtonText]];
    [[SPMediabrixPropertiesProvider sharedInstance] setEnticeText:[data stringForKey:SPMediabrixEnticeText]];
    [[SPMediabrixPropertiesProvider sharedInstance] setRescueTitle:[data stringForKey:SPMediabrixRescueTitle]];
    [[SPMediabrixPropertiesProvider sharedInstance] setRescueText:[data stringForKey:SPMediabrixRescueText]];
    
    // starting MediaBrix SDK
    [MediaBrix setUserDefaultsClass:[SPMediabrixUserDefaults class]];
    [MediaBrix sharedInstance];
    
    return YES;
}

- (NSString *)appId
{
    return [[SPMediabrixPropertiesProvider sharedInstance] appId];
}

- (NSString *)rescueZone
{
    return [[SPMediabrixPropertiesProvider sharedInstance] rescueZone];
}

@end
