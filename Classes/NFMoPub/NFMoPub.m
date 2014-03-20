//
//  NFAnalytics.m
//
//  Created by William Locke on 3/5/13.
//
//

#import "NFParentalGate.h"

//static NFParentalGate *_sharedInstance;
NSString * const NFParentalGateSkinKeyBackground = @"NFParentalGateSkinKeyBackground";
NSString * const NFParentalGateSkinKeyBackgroundTexture = @"NFParentalGateSkinKeyBackgroundTexture";
NSString * const NFParentalGateSkinKeyClose = @"NFParentalGateSkinKeyClose";


@interface NFParentalGate(){
    UIView *_alertBoxView;
    UILabel *_instructionsLabel;
    NSDate *_touchStartedAt;
    
    NSMutableArray *_buttonImageNames;
    int _correctButtonIndex;
    
    NFParentalGateCompletionHandler _completionHandler;
    UIView *_view;
    
    UIButton *_backgroundButton;
    UIImage *_backgroundImage;
    UIImageView *_backgroundImageView;
    UIButton *_closeButton;
    
    NSDictionary *_defaultSkin;
    
    NSBundle *_bundle;
}
@end

@implementation NFParentalGate

+ (NFParentalGate *)sharedInstance
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
        _alertBoxView = [[UIView alloc] init];
        _instructionsLabel = [[UILabel alloc] init];
        _view = [[UIView alloc] init];
        _view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _backgroundButton = [[UIButton alloc] init];
        [_backgroundButton addTarget:self action:@selector(backgroundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _backgroundImageView = [[UIImageView alloc] init];
        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"NFParentalGate" ofType:@"bundle"];
//        NSBundle *bundle = [NSBundle bundleWithPath:path];
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"NFParentalGate" ofType:@"bundle"];
        _bundle = [NSBundle bundleWithPath:path];
        
        NSString *thePath = [_bundle pathForResource:@"fonts/JockeyOne-Regular" ofType:@"otf"];
        NSData *inData = [[NSData alloc] initWithContentsOfFile:thePath];
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
        CFRelease(font);
        CFRelease(provider);
        
        
        _defaultSkin = @{
                        NFParentalGateSkinKeyBackground:@"NFParentalGate.bundle/Images/background/background",
                        NFParentalGateSkinKeyBackgroundTexture:@"NFParentalGate.bundle/Images/textures/background",
                        NFParentalGateSkinKeyClose:@"NFParentalGate.bundle/Images/x_button/x_button"
                        };
        
        _skin = _defaultSkin;
        
    }
    return self;
}


-(void)show:(NFParentalGateCompletionHandler)completionHandler{
    _completionHandler = completionHandler;
    
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if ([rootViewController isKindOfClass:[UITabBarController class]]){
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        rootViewController = ((UINavigationController *)rootViewController).topViewController;
    }
    UIView *view = rootViewController.view;
    [self showInView:view completionHandler:completionHandler];
}

-(id)skinItemForKey:(NSString *)key{
    if(!_skin){
        return @"";
    }
    if(![_skin objectForKey:key]){
        return @"";
    }
    return [_skin objectForKey:key];
}

-(void)showInView:(UIView *)view completionHandler:(NFParentalGateCompletionHandler)completionHandler
{
    
    _backgroundImage = [UIImage imageNamed:[self skinItemForKey:NFParentalGateSkinKeyBackground]];
    
    CGSize percentageSize;
    if(view.frame.size.width < view.frame.size.height){
        percentageSize = CGSizeMake(0.7, 0.3);
    }else{
        percentageSize = CGSizeMake(0.3, 0.7);
    }
    
    if(_backgroundImage){
        percentageSize = CGSizeMake(_backgroundImage.size.width / view.frame.size.width, _backgroundImage.size.height / view.frame.size.height);
    }
    
    for(UIView *subview in _view.subviews){
        [subview removeFromSuperview];
    }
    for(UIView *subview in _alertBoxView.subviews){
        [subview removeFromSuperview];
    }
    
    _view.frame = CGRectMake(0,0,view.frame.size.width, view.frame.size.height);
    [view addSubview:_view];
    _backgroundButton.frame = _view.frame;
    [_view addSubview:_backgroundButton];
    
    
    _alertBoxView.frame = CGRectMake(view.frame.size.width * ((1.0 - percentageSize.width)/2.0), view.frame.size.height * ((1.0 - percentageSize.height)/2.0), view.frame.size.width * percentageSize.width, view.frame.size.height * percentageSize.height);
    
    
    if(!_backgroundImage){
        _alertBoxView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[self skinItemForKey:NFParentalGateSkinKeyBackgroundTexture]]];
        _alertBoxView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:22/255.0 blue:150/255.0 alpha:1.0].CGColor;
        _alertBoxView.layer.borderWidth = _alertBoxView.frame.size.width * 0.03;
        _alertBoxView.layer.cornerRadius = _alertBoxView.frame.size.width * 0.05;
    }
    
    _backgroundImageView.frame = CGRectMake(0,0,_alertBoxView.frame.size.width,_alertBoxView.frame.size.height);
    _backgroundImageView.image = _backgroundImage;
    [_alertBoxView addSubview:_backgroundImageView];
    
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(_alertBoxView.frame.size.width * 0.17, _alertBoxView.frame.size.height * 0.2, _alertBoxView.frame.size.width * 0.66, _alertBoxView.frame.size.height * 0.3)];
    [_alertBoxView addSubview:buttonsView];
    int numberOfButtons = 3;
    CGSize buttonSize = CGSizeMake(buttonsView.frame.size.width / numberOfButtons, buttonsView.frame.size.height);
    _buttonImageNames = [[NSMutableArray alloc] initWithArray:@[@"Circle", @"Star", @"Triangle"]];
    
    
    NSInteger count = [_buttonImageNames count];
    for (NSInteger i = 0; i < count - 1; i++){
        NSInteger swap = random() % (count - i) + i;
        [_buttonImageNames exchangeObjectAtIndex:swap withObjectAtIndex:i];
    }
    for(int i=[_buttonImageNames count]-1; i >= numberOfButtons; i--){
        [_buttonImageNames removeObjectAtIndex:i];
    }
    
    for(int i=0; i < numberOfButtons; i++){
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(buttonSize.width * i, 0, buttonSize.width, buttonSize.height);
        [buttonsView addSubview:button];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        NSString *buttonImageName = [_buttonImageNames objectAtIndex:i];
        buttonImageName = [@"" stringByAppendingFormat:@"NFParentalGate.bundle/Images/shapes/%@", buttonImageName];
        
        [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(buttonPressedDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchCancel];

        [button setTag:i];
    }
    
    
    _instructionsLabel.frame = CGRectMake(_alertBoxView.frame.size.width * 0.1, _alertBoxView.frame.size.height * 0.49, _alertBoxView.frame.size.width * 0.8, _alertBoxView.frame.size.height * 0.4);
    _instructionsLabel.numberOfLines = 3;
    _instructionsLabel.backgroundColor = [UIColor clearColor];
    _correctButtonIndex = arc4random() % [_buttonImageNames count];
    NSString *shape = [_buttonImageNames objectAtIndex:_correctButtonIndex];
    shape = [[_bundle localizedStringForKey:shape value:shape table:nil] lowercaseString];
    
//    _instructionsLabel.text =[@"" stringByAppendingFormat:@"Press the %@ for 2 seconds", shape];
    _instructionsLabel.text = [@"" stringByAppendingFormat:[_bundle localizedStringForKey:@"Press" value:@"Press %@" table:nil], shape];
    
    _instructionsLabel.textAlignment = UITextAlignmentCenter;
    
    _instructionsLabel.font = [UIFont fontWithName:@"Jockey One" size:_alertBoxView.frame.size.width * 0.08];
//    _instructionsLabel.font = [UIFont fontWithName:@"Passion One" size:_alertBoxView.frame.size.width * 0.08];
    
    _instructionsLabel.numberOfLines = 3;
    _instructionsLabel.textColor = [UIColor colorWithRed:94/255.0 green:9/255.0 blue:91/255.0 alpha:1.0];
    

    [_alertBoxView addSubview:_instructionsLabel];
    
    [_view addSubview:_alertBoxView];
    
    UIImage *closeButtonImage = [UIImage imageNamed:[self skinItemForKey:NFParentalGateSkinKeyClose]];
    CGSize closeButtonSize = closeButtonImage.size;
    CGRect closeButtonFrame;
    
    if([[self skinItemForKey:NFParentalGateSkinKeyBackground] isEqualToString:[_defaultSkin objectForKey:NFParentalGateSkinKeyBackground]]){
        closeButtonFrame = CGRectMake(_alertBoxView.frame.origin.x + _alertBoxView.frame.size.width - closeButtonSize.width * 0.9, _alertBoxView.frame.origin.y - closeButtonSize.height * 0.0, closeButtonSize.width, closeButtonSize.height);
    }else{
        closeButtonFrame = CGRectMake(_alertBoxView.frame.origin.x + _alertBoxView.frame.size.width - closeButtonSize.width * 0.7, _alertBoxView.frame.origin.y - closeButtonSize.height * 0.3, closeButtonSize.width, closeButtonSize.height);        
    }
    _closeButton = [[UIButton alloc] initWithFrame:closeButtonFrame];
    [_closeButton setImage:closeButtonImage forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:_closeButton];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        NSLog(@"Running in IOS-6");
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: _instructionsLabel.attributedText];
        UIColor *shapeTextColor = [UIColor colorWithRed:62/255.0 green:170/255.0 blue:29/255.0 alpha:1];
        NSRange range = [_instructionsLabel.text rangeOfString:shape];
        [text addAttribute: NSForegroundColorAttributeName value:shapeTextColor range:range];
        [_instructionsLabel setAttributedText: text];
    }
    

}

-(void)dismiss{
    [_view removeFromSuperview];
}


-(IBAction)backgroundButtonPressed:(id)sender{
    [self closeButtonPressed:sender];
}

-(IBAction)closeButtonPressed:(id)sender{
    [self dismiss];
    if(_completionHandler){
        _completionHandler(NO);
    }
}

-(IBAction)buttonPressedDown:(id)sender{
    NSLog(@"button pressed down");
    _touchStartedAt = [NSDate date];
    
    if([sender tag] != _correctButtonIndex){
        NSLog(@"incorrect button pressed");
        
//        if(_completionHandler){
//            [self dismiss];
//            _completionHandler(NO);
//        }
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(heldForTwoSeconds) object:nil];
    [self performSelector:@selector(heldForTwoSeconds) withObject:nil afterDelay:1.0];

}

-(void)heldForTwoSeconds{
    
    NSLog(@"touched for long enough");
    if(!_touchStartedAt){
        NSLog(@"no touch started at set");
        return;
    }
    if(_completionHandler){
        [self dismiss];
        _completionHandler(YES);
    }
    
}


-(IBAction)buttonReleased:(id)sender{
    NSLog(@"button released");
}

-(IBAction)buttonPressed:(id)sender{
    NSLog(@"button pressed");
    if(!_touchStartedAt){
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(heldForTwoSeconds) object:nil];
    
//    if(_completionHandler){
//        _completionHandler(NO);
//    }
//    [self dismiss];
    
    NSDate *touchFinishedAt = [NSDate date];
    NSTimeInterval executionTime = [touchFinishedAt timeIntervalSinceDate:_touchStartedAt];
    NSLog(@"Touch Time: %f", executionTime);
    _touchStartedAt = nil;
    
    
    
}

@end
