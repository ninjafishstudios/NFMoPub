//
//  NFAnalytics.h
//
//  Created by William Locke on 3/5/13.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
@class NFParentalGate;

extern NSString * const NFParentalGateSkinKeyBackground;
extern NSString * const NFParentalGateSkinKeyBackgroundTexture;
extern NSString * const NFParentalGateSkinKeyClose;

typedef void (^ NFParentalGateCompletionHandler)(BOOL verified);

@interface NFParentalGate : NSObject

@property (nonatomic, strong) NSDictionary *skin;


+ (NFParentalGate *)sharedInstance;
-(void)show:(NFParentalGateCompletionHandler)completionHandler;



@end
