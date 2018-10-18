//
//  ViewController.h
//  CodeDay2
//
//  Created by Rahman on 5/19/17.
//  Copyright © 2017 Ali Rahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SwiftySideMenuViewController.h"
#import "UIViewController+SwiftySideMenu.h"
#import "DFContinuousForceTouchGestureRecognizer.h"
#import "DTMHeatmap.h"
#import "DTMHeatmapRenderer.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSLex/AWSLex.h>

@import ISHHoverBar;

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, SwiftySideMenuViewControllerDelegate, DFContinuousForceTouchDelegate, AWSLexVoiceButtonDelegate> {
    IBOutlet MKMapView *homeMap;
    IBOutlet ISHHoverBar *toolBar;
    IBOutlet UILabel *predictedCrime;
    UIBarButtonItem *analyticsItem;
    BOOL viewCentered;
    IBOutlet AWSLexVoiceButton *lexVoiceButton;
}

@property(nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) NSDictionary *crimes;
@property (nonatomic, strong) DTMHeatmap *heatmap;


//-(IBAction)report:(id)sender;

@end

