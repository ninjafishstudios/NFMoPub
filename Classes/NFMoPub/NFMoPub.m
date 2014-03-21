//
//  NFMoPub.m
//
//  Created by William Locke on 3/5/13.
//
//

#import "NFMoPub.h"

#import "MPInterstitialAdController.h"


@interface NFMoPub()<MPAdViewDelegate>{

}
@end

@implementation NFMoPub

+ (NFMoPub *)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



- (void)showInterstitial:(NSString *)label{
    
    self.interstitial = [MPInterstitialAdController
                         interstitialAdControllerForAdUnitId: self.interstialAdUnitId];
    
    // Fetch the interstitial ad.
    [self.interstitial loadAd];
}


-(UIViewController *)applicationsCurrentTopViewController{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UIViewController *topViewController = rootViewController;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]){
        topViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        topViewController = ((UINavigationController *)rootViewController).topViewController;
    }
    return topViewController;
}


- (void)showBannerAd{
    
    self.adView = [[MPAdView alloc] initWithAdUnitId:self.bannerAdUnitId
                                                size:MOPUB_BANNER_SIZE];
    self.adView.delegate = self;
    
    UIViewController *topViewController = [self applicationsCurrentTopViewController];
    UIView *view = topViewController.view;
    
    self.adView.frame = CGRectMake(0, view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    
    [view addSubview:self.adView];
    [self.adView loadAd];
    
}

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return [self applicationsCurrentTopViewController];
}



@end
