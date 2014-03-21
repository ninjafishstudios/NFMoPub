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
    [self showBannerAd:nil];
}


- (void)showBannerAd:(NSString *)label{
    [self.adView removeFromSuperview];
    
    if(label && [label isEqualToString:@"Remove Ads"]){
        return;
    }
    
    
    CGSize bannerSize;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        bannerSize = CGSizeMake(728, 90);
    }else{
        bannerSize = CGSizeMake(320, 50);
    }
    
    self.adView = [[MPAdView alloc] initWithAdUnitId:self.bannerAdUnitId
                                                size:bannerSize];
    self.adView.delegate = self;
    
    UIViewController *topViewController = [self applicationsCurrentTopViewController];
    UIView *view = topViewController.view;
    

    
    if(self.bannerAdPosition == NFMoPubBannerAdPositionBottom){
        self.bannerAdFrame = CGRectMake((view.bounds.size.width - bannerSize.width) * 0.5, view.bounds.size.height - bannerSize.height,
                                        bannerSize.width, bannerSize.height);
        self.adView.frame = CGRectOffset(self.bannerAdFrame, 0, self.bannerAdFrame.size.height);
        
        
    }else if(self.bannerAdPosition == NFMoPubBannerAdPositionTop){
        self.bannerAdFrame = CGRectMake((view.bounds.size.width - bannerSize.width) * 0.5, 0,
                                        bannerSize.width, bannerSize.height);
        self.adView.frame = CGRectOffset(self.bannerAdFrame, 0, -self.bannerAdFrame.size.height);
    }
    [view addSubview:self.adView];
    [self.adView loadAd];
}


#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return [self applicationsCurrentTopViewController];
}

- (void)adViewDidLoadAd:(MPAdView *)view
{
    NSLog(@"ad view did load");
    [UIView animateWithDuration:0.7 animations:^{
        self.adView.frame = self.bannerAdFrame;
    }completion:^(BOOL finished){
    }];
    
    [self makeSpaceForBannerAd];
}


-(void)makeSpaceForBannerAd{
    
    NSMutableArray *viewsToMove = [[NSMutableArray alloc] init];
    UIViewController *topViewController = [self applicationsCurrentTopViewController];
    UIView *view = topViewController.view;
    
    for(UIView *subview in view.subviews){
        if( (subview.frame.origin.x > self.adView.frame.origin.x && subview.frame.origin.x < (self.adView.frame.origin.x + self.adView.frame.size.width)) &&  abs(subview.frame.origin.y - self.adView.frame.origin.y) < self.adView.frame.size.height * 0.8){
            if(subview.frame.size.height < view.frame.size.height * 0.4 && subview != self.adView){
                [viewsToMove addObject:subview];
            }
        }
    }
    
    int directionToMoveViews = 1;
    
    if(self.adView.frame.origin.y > view.frame.size.height * 0.5){
        directionToMoveViews = -1;
    }
    
    
    [UIView animateWithDuration:0.7 animations:^{
        for (UIView *subview in viewsToMove){
            subview.frame = CGRectOffset(subview.frame, 0, self.adView.frame.size.height * directionToMoveViews);
        }
    }completion:nil];

}


@end
