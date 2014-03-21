//
//  NFMoPub.h
//
//  Created by William Locke on 3/5/13.
//
//

#import <Foundation/Foundation.h>
#import "MPInterstitialAdController.h"
#import "MPAdView.h"

@interface NFMoPub : NSObject

@property (nonatomic, copy) NSString *interstialAdUnitId;
@property (nonatomic, copy) NSString *bannerAdUnitId;
@property (nonatomic, retain) MPInterstitialAdController *interstitial;
@property (nonatomic, retain) MPAdView *adView;

+ (NFMoPub *)sharedInstance;


- (void)showInterstitial:(NSString *)label;

@end
