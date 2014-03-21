//
//  NFMoPub.h
//
//  Created by William Locke on 3/5/13.
//
//

#import <Foundation/Foundation.h>
#import "MPInterstitialAdController.h"
#import "MPAdView.h"


typedef enum {
    NFMoPubBannerAdPositionTop,
    NFMoPubBannerAdPositionBottom,
    }NFMoPubBannerAdPosition;

@interface NFMoPub : NSObject

@property (nonatomic, copy) NSString *interstialAdUnitId;
@property (nonatomic, copy) NSString *bannerAdUnitId;
@property (nonatomic, retain) MPInterstitialAdController *interstitial;
@property (nonatomic, retain) MPAdView *adView;
@property NFMoPubBannerAdPosition bannerAdPosition;
@property CGRect bannerAdFrame;

+ (NFMoPub *)sharedInstance;


- (void)showInterstitial:(NSString *)label;

@end
