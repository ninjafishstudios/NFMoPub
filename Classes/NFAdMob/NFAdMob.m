//
//  NFAdMob.m
//
//  Created by William Locke on 3/5/13.
//
//

#import "NFAdMob.h"

#import "GADBannerView.h"

@interface NFAdMob()<GADBannerViewDelegate>{
    GADBannerView *_bannerView;
}
@end

@implementation NFAdMob

+ (NFAdMob *)sharedInstance
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
    
    self.adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    
    
    self.adView.delegate = self;
    
    self.adView.adUnitID = self.bannerAdUnitId;
    

    
    UIViewController *topViewController = [self applicationsCurrentTopViewController];
    UIView *view = topViewController.view;
    
    self.adView.rootViewController = topViewController;
    
    
    if(self.bannerAdPosition == NFAdMobBannerAdPositionBottom){
        self.bannerAdFrame = CGRectMake((view.bounds.size.width - bannerSize.width) * 0.5, view.bounds.size.height - bannerSize.height,
                                        bannerSize.width, bannerSize.height);
        self.adView.frame = CGRectOffset(self.bannerAdFrame, 0, self.bannerAdFrame.size.height);
        
        
    }else if(self.bannerAdPosition == NFAdMobBannerAdPositionTop){
        self.bannerAdFrame = CGRectMake((view.bounds.size.width - bannerSize.width) * 0.5, 0,
                                        bannerSize.width, bannerSize.height);
        self.adView.frame = CGRectOffset(self.bannerAdFrame, 0, -self.bannerAdFrame.size.height);
    }
    [view addSubview:self.adView];
    
    GADRequest *request =[GADRequest request];
    [request tagForChildDirectedTreatment:YES];
    [self.adView loadRequest:request];
}


-(void)removeBannerAd{
    [self.adView removeFromSuperview];
    
}


#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return [self applicationsCurrentTopViewController];
}




- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    if(self.shouldAnimateBannerAdPresentation){
        [UIView animateWithDuration:0.7 animations:^{
            self.adView.frame = self.bannerAdFrame;
        }completion:^(BOOL finished){
            if(self.delegate && [self.delegate respondsToSelector:@selector(adSdkInstance:didDisplayBannerAd:)]){
                [self.delegate adSdkInstance:self didDisplayBannerAd:self.adView];
            }
        }];
    }else{
        self.adView.frame = self.bannerAdFrame;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(adSdkInstance:willDisplayBannerAd:)]){
        [self.delegate adSdkInstance:self willDisplayBannerAd:self.adView];
    }
    
//    [self makeSpaceForBannerAd:self.adView animated:self.shouldAnimateBannerAdPresentation];
}


@end
