//
//  SPFacebookNetwork.m
//
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPBaseNetwork.h"

/**
 Network class in charge of integrating FacebookAudienceNetwork library
 
 ## Version compatibility
 
 - Adapter version: 2.0.1
 
 */

@interface SPFacebookAudienceNetworkNetwork : SPBaseNetwork

@property (nonatomic, copy, readonly) NSString *placementId;

@end
