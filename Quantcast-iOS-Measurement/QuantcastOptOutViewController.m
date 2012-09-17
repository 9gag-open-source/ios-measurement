//
// Copyright (c) 2012, Quantcast Corp.
// This software is licensed under the Quantcast Mobile API Beta Evaluation Agreement and may not be used except as permitted thereunder or copied, modified, or distributed in any case.
//

#ifndef __has_feature
#define __has_feature(x) 0
#endif
#ifndef __has_extension
#define __has_extension __has_feature // Compatibility with pre-3.0 compilers.
#endif

#if __has_feature(objc_arc) && __clang_major__ >= 3
#error "Quantcast Measurement is not designed to be used with ARC. Please add '-fno-objc-arc' to this file's compiler flags"
#endif // __has_feature(objc_arc)

#import <QuartzCore/QuartzCore.h>
#import "QuantcastOptOutViewController.h"
#import "QuantcastOptOutDelegate.h"
#import "QuantcastMeasurement.h"

@interface QuantcastMeasurement ()

-(void)setOptOutStatus:(BOOL)inOptOutStatus;

@end

@interface QuantcastOptOutViewController ()
@property (retain,nonatomic) IBOutlet UISwitch* enableMeasurementSwitch;
@property (retain,nonatomic) IBOutlet UITextView* privacyTextView;
@property (retain,nonatomic) QuantcastMeasurement* measurement;
@property (retain,nonatomic) id<QuantcastOptOutDelegate> delegate;

@end

@implementation QuantcastOptOutViewController
@synthesize enableMeasurementSwitch;
@synthesize measurement;
@synthesize delegate;

-(id)initWithMeasurement:(QuantcastMeasurement*)inMeasurement delegate:(id<QuantcastOptOutDelegate>)inDelegate {
    self = [super initWithNibName:@"QuantcastOptOutViewController" bundle:nil];
    
    if ( self ) {
        self.measurement = inMeasurement;
        self.delegate = inDelegate;
        
        _originalOptOutStatus = self.measurement.isOptedOut;
    }
    
return self;
}

-(void)dealloc {
    [measurement release];
    [delegate release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.enableMeasurementSwitch.on = !self.measurement.isOptedOut;
    
    NSString* textFormat = self.privacyTextView.text;
    NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];

    if ( nil == appName ) {
        appName = @"app's";
    }
    
    self.privacyTextView.text = [NSString stringWithFormat:textFormat,appName];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Dialog Status

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ( [self.delegate respondsToSelector:@selector(quantcastOptOutDialogWillAppear)] ) {
        [self.delegate quantcastOptOutDialogWillAppear];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ( [self.delegate respondsToSelector:@selector(quantcastOptOutDialogDidAppear)] ) {
        [self.delegate quantcastOptOutDialogDidAppear];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ( [self.delegate respondsToSelector:@selector(quantcastOptOutDialogWillDisappear)] ) {
        [self.delegate quantcastOptOutDialogWillDisappear];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ( [self.delegate respondsToSelector:@selector(quantcastOptOutDialogDidDisappear)] ) {
        [self.delegate quantcastOptOutDialogDidDisappear];
    }
    
    if ( _originalOptOutStatus != !self.enableMeasurementSwitch.on ) {
        
        [self.measurement setOptOutStatus:!self.enableMeasurementSwitch.on];

        if ( [self.delegate respondsToSelector:@selector(quantcastOptOutStatusDidChange:)] ) {
            [self.delegate quantcastOptOutStatusDidChange:self.measurement.isOptedOut];
        }
    }

}

#pragma mark - UI Interaction

-(IBAction)optOutStatusChanged:(id)inSender {
    // nothing to do here. actual state change occures are dismissal.
    
    
}

-(IBAction)reviewPrivacyPolicy:(id)inSender {
    NSURL* qcPrivacyURL = [NSURL URLWithString:@"http://www.quantcast.com/privacy/"];
    
    [[UIApplication sharedApplication] openURL:qcPrivacyURL];
    
}

-(IBAction)done:(id)inSender {
    
    
    [self dismissModalViewControllerAnimated:YES];
}


@end


@implementation QuantcastRoundedRectView

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit;
{
    CALayer *layer = self.layer;
    layer.cornerRadius  = 10.0f;
    layer.masksToBounds = YES;
    layer.borderColor = [UIColor grayColor].CGColor;
    layer.borderWidth = 1;
}

@end
