//
//  NFMoPub.h
//
//  Created by William Locke on 3/5/13.
//
//

#import <Foundation/Foundation.h>
#import "MPInterstitialAdController.h"
#import "MPAdView.h"
@class NFMoPub;

@protocol NFMoPubDelegate <NSObject>
@optional
-(void)adSdkInstance:(NFMoPub *)adSdkInstance didDisplayBannerAd:(UIView *)bannerAdView;
@optional
-(void)adSdkInstance:(NFMoPub *)adSdkInstance willDisplayBannerAd:(UIView *)bannerAdView;

@end



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
@property BOOL shouldAnimateBannerAdPresentation;

@property (nonatomic, unsafe_unretained) id<NFMoPubDelegate> delegate;


+ (NFMoPub *)sharedInstance;


- (void)showInterstitial:(NSString *)label;

- (void)showBannerAd;
- (void)showBannerAd:(NSString *)label;

@end
