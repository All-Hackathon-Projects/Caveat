//
//  ViewController.m
//  CodeDay2
//
//  Created by Rahman on 5/19/17.
//  Copyright © 2017 Ali Rahman. All rights reserved.
//

#import "ViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "MZFormSheetPresentationViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
@import AudioToolbox;
#define CLCOORDINATE_EPSILON 0.005f
#define CLCOORDINATES_EQUAL2( coord1, coord2 ) (fabs(coord1.latitude - coord2.latitude) < CLCOORDINATE_EPSILON && fabs(coord1.longitude - coord2.longitude) < CLCOORDINATE_EPSILON)

@interface ViewController ()

@end

@implementation ViewController
@synthesize crimes;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Cluster delegate
    /* NSArray *data = @[
     @{kLatitude:@37.787270, kLongitude:@-122.408955,  kTitle : @"Crime 1", kSubtitle : @"Aditya",            kIndex : @0},
     @{kLatitude:@37.787936, kLongitude:@-122.408386, kTitle : @"Crime 2", kSubtitle : @"Jerry",  kIndex : @1},
     @{kLatitude:@37.788314, kLongitude:@-122.406363,  kTitle : @"Crime 3", kSubtitle : @"Harsh",  kIndex : @2},
     ];
     */
    
    
    
    /*MKPointAnnotation *pt1 = [[MKPointAnnotation alloc]init];
     [pt1 setCoordinate:CLLocationCoordinate2DMake(37.787270, -122.408955)];
     [pt1 setTitle:@"Robbery"];
     [pt1 setSubtitle:@"1/2 12:30 pm"];
     
     MKPointAnnotation *pt2 = [[MKPointAnnotation alloc]init];
     [pt2 setCoordinate:CLLocationCoordinate2DMake(37.787936, -122.408386)];
     [pt2 setTitle:@"Assault"];
     [pt2 setSubtitle:@"12/22 4:30 pm"];
     
     
     MKPointAnnotation *pt3 = [[MKPointAnnotation alloc]init];
     [pt3 setCoordinate:CLLocationCoordinate2DMake(37.788314, -122.406363)];
     [pt3 setTitle:@"Mugging"];
     [pt3 setSubtitle:@"2/02 1:30 am"];
     
     [homeMap addAnnotations:@[pt1, pt2, pt3]];*/
    
    AWSLexInteractionKitConfig *chatConfig = [AWSLexInteractionKitConfig defaultInteractionKitConfigWithBotName:@"GetCrimeInArea" botAlias:@"ChicagoCrime"];
    
    chatConfig.autoPlayback = YES;
    
    [AWSLexInteractionKit registerInteractionKitWithServiceConfiguration:[[AWSServiceManager defaultServiceManager] defaultServiceConfiguration] interactionKitConfiguration:chatConfig forKey:@"chatConfig"];
    [AWSLexInteractionKit registerInteractionKitWithServiceConfiguration:[[AWSServiceManager defaultServiceManager] defaultServiceConfiguration] interactionKitConfiguration:chatConfig forKey:@"AWSLexVoiceButton"];
    
    [lexVoiceButton setDelegate:self];
    
    //AWS STUFF ENDS
    
    
    DFContinuousForceTouchGestureRecognizer* forceTouchRecognizer = [[DFContinuousForceTouchGestureRecognizer alloc] init];
    
    forceTouchRecognizer.forceTouchDelegate = self;
    [self.view addGestureRecognizer:forceTouchRecognizer];
    // Set custom map properties
    [homeMap setShowsUserLocation:YES];
    [homeMap setShowsCompass:YES];
    [homeMap setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    [homeMap setZoomEnabled:YES];
    [homeMap setDelegate:self];
    
    
    // CLLocation manager will handle user location
    _manager = [[CLLocationManager alloc] init];
    [_manager setDelegate:self];
    [_manager requestWhenInUseAuthorization];
    [_manager startUpdatingLocation];
    
    // Toolbar setup
    
    
    MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:homeMap];
    analyticsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Analytics.png"] style:UIBarButtonItemStylePlain target:self action:@selector(presentRegionAnalytics)];
    [toolBar setItems:@[buttonItem, analyticsItem]];
    viewCentered = NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// CLLocation manager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocationCoordinate2D coord = [locations lastObject].coordinate;
    //CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(41.7753368,-87.6590701);
    
    // CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(42.0054, -87.8133);
    if (!CLCOORDINATES_EQUAL2(homeMap.centerCoordinate, coord)) {
        if (!viewCentered) {
            [homeMap setCenterCoordinate:coord zoomLevel:12 animated:YES];
            viewCentered = YES;
        }
    }
    
    /* GETS SCREEN RANGE OF LATS AND LONGS
     if (homeMap.region.span.latitudeDelta < homeMap.region.span.longitudeDelta) {
     NSLog(@"%f", homeMap.region.span.latitudeDelta);
     }
     else {
     NSLog(@"%f", homeMap.region.span.longitudeDelta);
     
     }*/
    
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *afmanager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"http://10.1.107.50:4000/markers?lat=%f&long=%f", coord.latitude, coord.longitude];
    
    
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSURLRequest requestWithURL:URL] mutableCopy];
    [request setHTTPMethod:@"GET"];
    [analyticsItem setEnabled:NO];
    [SVProgressHUD showWithStatus:@"Pulling local crime data..."];
    NSURLSessionDataTask *dataTask = [afmanager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            crimes = (NSDictionary *)responseObject;
           [predictedCrime setText:[NSString stringWithFormat:@"Most Likely Crime: %@ at %@", [[crimes objectForKey:@"predictedCrime"] objectForKey:@"genericType"], [[crimes objectForKey:@"predictedCrime"] objectForKey:@"time"]]];
            // Draw overlay right here
            
            // INTEGRATING HEAT MAP API AQUI (Legacy commented out)
            /*NSArray *arr = homeMap.overlays;
             [homeMap removeOverlays:arr];
             
             MKCircle *sampleCircle = [MKCircle circleWithCenterCoordinate:coord radius:800];
             [homeMap addOverlay:sampleCircle];
             [analyticsItem setEnabled:NO];*/
            
            NSMutableDictionary *dataSet = [[NSMutableDictionary alloc] init];
            NSMutableArray *crimesInArea = [crimes objectForKey:@"crimesInArea"];
            for (NSDictionary *crimeObject in crimesInArea) {
                NSString *lat = [crimeObject objectForKey:@"lat"];
                NSString *lon = [crimeObject objectForKey:@"long"];
                NSString *wt = [crimeObject objectForKey:@"weight"];
                CLLocation *location = [[CLLocation alloc] initWithLatitude:lat.doubleValue
                                                                  longitude:lon.doubleValue];
                MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
                // [dataSet setObject:@(wt.integerValue) forKey:];
                NSValue *pointValue = [NSValue value:&point withObjCType:@encode(MKMapPoint) ];
                dataSet[pointValue] = @(wt.doubleValue / 10.0);
            }
            
            homeMap.delegate = self;
            self.heatmap = [[DTMHeatmap alloc] init];
            [self.heatmap setData:dataSet];
            
            NSArray *arr = homeMap.overlays;
            [homeMap removeOverlays:arr];
            
            
            [homeMap addOverlay:self.heatmap level:MKOverlayLevelAboveRoads];
            
            [SVProgressHUD dismissWithDelay:0.3];
        }
    }];
    [dataTask resume];
    [manager stopUpdatingLocation];
    
    
    
}

// MKMap Delegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay {
    
    /*
     NSString *severity = [crimes objectForKey:@"severity"];
     NSLog(@"%@",severity);
     NSString *radius = [crimes objectForKey:@"radius"];
     if ([radius isKindOfClass:[NSNull class]]) {
     radius = @"600";
     
     }
     MKCircle *circle = [MKCircle circleWithCenterCoordinate:overlay.coordinate radius:[radius floatValue]*1000];
     
     float percent;
     if ([severity isKindOfClass:[NSNull class]]) {
     percent = 0.4;
     }
     else percent = [severity floatValue];
     percent = (percent - 0.4)/0.1;
     double resultRed = 52 + percent * (211 - 52);
     double resultGreen = 173 + percent * (50 - 173);
     double resultBlue = 82 + percent * (50 - 82);
     
     MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:circle];
     
     [renderer setFillColor:[UIColor colorWithRed:resultRed/255.0 green:resultGreen/255.0 blue:resultBlue/255.0 alpha:1.0]];
     
     
     //    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:overlay]; // D E L E T E
     
     
     //   [renderer setFillColor:[UIColor redColor]];
     [renderer setAlpha:0.3];
     [renderer setStrokeColor:[UIColor orangeColor]];
     
     return renderer
     
     LEGACY RADIAL STUFF --> NOW ON HEAT MAPS :)
     
     
     
     */
    
    return [[DTMHeatmapRenderer alloc] initWithOverlay:overlay];
}


//Custom actions

-(IBAction)report:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"reportCrimeVC"];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:vc];
    
    formSheetController.presentationController.contentViewSize = CGSizeMake(self.view.frame.size.width - 40,self.view.frame.size.height - 80); // or pass in UILayoutFittingCompressedSize to size automatically with auto-layout=
    
    [formSheetController.presentationController setShouldDismissOnBackgroundViewTap:YES];
    [formSheetController.presentationController setShouldCenterVertically:YES];
    [self presentViewController:formSheetController animated:YES completion:nil];
}

-(void)presentRegionAnalytics {
    
    [self.swiftySideMenu toggleSideMenu];
    
}




// From the internet

- (void)addBlurToView:(UIView *)view {
    UIView *blurView = nil;
    
    if([UIBlurEffect class]) { // iOS 8
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = view.frame;
        
    } else { // workaround for iOS 7
        blurView = [[UIToolbar alloc] initWithFrame:view.bounds];
    }
    
    [blurView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [view addSubview:blurView];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(blurView)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(blurView)]];
}

#pragma DFContinuousForceTouchDelegate

- (void) forceTouchRecognized:(DFContinuousForceTouchGestureRecognizer*)recognizer {
    AudioServicesPlaySystemSound(1520); // Actuate `Pop` feedback (strong boom)
    CGPoint currentlocation = [recognizer locationInView:self.view];
    
    NSLog(@"Force Touch Recognized");
    CLLocationCoordinate2D coord = [homeMap convertPoint:currentlocation toCoordinateFromView:homeMap];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *afmanager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"http://10.1.107.50:4000/markers?lat=%f&long=%f", coord.latitude, coord.longitude];
    
    
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSURLRequest requestWithURL:URL] mutableCopy];
    [request setHTTPMethod:@"GET"];
    
    [analyticsItem setEnabled:NO];
    [SVProgressHUD showWithStatus:@"Pulling local crime data..."];
    
    NSURLSessionDataTask *dataTask = [afmanager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            crimes = (NSDictionary *)responseObject;
           [predictedCrime setText:[NSString stringWithFormat:@"Most Likely Crime: %@ at %@", [[crimes objectForKey:@"predictedCrime"] objectForKey:@"genericType"], [[crimes objectForKey:@"predictedCrime"] objectForKey:@"time"]]];            /*
             NSArray *arr = homeMap.overlays;
             [homeMap removeOverlays:arr];
             
             MKCircle *sampleCircle = [MKCircle circleWithCenterCoordinate:coord radius:800];
             [homeMap addOverlay:sampleCircle];
             [analyticsItem setEnabled:YES];*/
            
            
            NSMutableDictionary *dataSet = [[NSMutableDictionary alloc] init];
            NSMutableArray *crimesInArea = [crimes objectForKey:@"crimesInArea"];
            for (NSDictionary *crimeObject in crimesInArea) {
                NSString *lat = [crimeObject objectForKey:@"lat"];
                NSString *lon = [crimeObject objectForKey:@"long"];
                NSString *wt = [crimeObject objectForKey:@"weight"];
                CLLocation *location = [[CLLocation alloc] initWithLatitude:lat.doubleValue
                                                                  longitude:lon.doubleValue];
                MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
                // [dataSet setObject:@(wt.integerValue) forKey:];
                NSValue *pointValue = [NSValue value:&point withObjCType:@encode(MKMapPoint) ];
                dataSet[pointValue] = @(wt.integerValue);
            }
            
            homeMap.delegate = self;
            self.heatmap = [[DTMHeatmap alloc] init];
            
            [self.heatmap setData:dataSet];
            
            NSArray *arr = homeMap.overlays;
            [homeMap removeOverlays:arr];
            
            
            [homeMap addOverlay:self.heatmap level:MKOverlayLevelAboveRoads];
            
            
            [SVProgressHUD dismissWithDelay:0.3];
        }
    }];
    [dataTask resume];
    
}

- (void) forceTouchRecognizer:(DFContinuousForceTouchGestureRecognizer*)recognizer didStartWithForce:(CGFloat)force maxForce:(CGFloat)maxForce {
    //do something cool
}

- (void) forceTouchRecognizer:(DFContinuousForceTouchGestureRecognizer*)recognizer didMoveWithForce:(CGFloat)force maxForce:(CGFloat)maxForce {
    //do something cool
}

- (void) forceTouchRecognizer:(DFContinuousForceTouchGestureRecognizer*)recognizer didCancelWithForce:(CGFloat)force maxForce:(CGFloat)maxForce {
    //reset cool effects
}

- (void) forceTouchRecognizer:(DFContinuousForceTouchGestureRecognizer*)recognizer didEndWithForce:(CGFloat)force maxForce:(CGFloat)maxForce {
    //reset cool effects
}

- (void) forceTouchDidTimeout:(DFContinuousForceTouchGestureRecognizer*)recognizer {
    //reset cool effects
}


// AWS LEX INTERACTION DELEGATE

-(void)voiceButton:(AWSLexVoiceButton *)button onResponse:(AWSLexVoiceButtonResponse *)response {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *afmanager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"http://api.geocod.io/v1/geocode?api_key=1bb1bb1c1a7b99eb2977c9a5c9c91205c2abc51&street=%@&city=Chicago&state=Illinois", response.slots[@"Location"]];
    NSURL *URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSURLRequest requestWithURL:URL] mutableCopy];
    [request setHTTPMethod:@"GET"];
    
    
    NSURLSessionDataTask *dataTask = [afmanager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
        
        else {
            
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSArray *results = [dict objectForKey:@"results"];
            NSDictionary *location = [results[0] objectForKey:@"location"];
            NSLog(@"%@, %@", location[@"lat"], location[@"lng"]);
            
            // Replace this BS with an actual method for christs sake you've used it 3 times
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSString *urlString = [NSString stringWithFormat:@"http://10.1.107.50:4000/markers?lat=%@&long=%@", location[@"lat"], location[@"lng"]];
            
            
            NSURL *URL = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [[NSURLRequest requestWithURL:URL] mutableCopy];
            [request setHTTPMethod:@"GET"];
            NSURLSessionDataTask *dataTask = [afmanager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    crimes = (NSDictionary *)responseObject;
                    [predictedCrime setText:[NSString stringWithFormat:@"Most Likely Crime: %@ at %@", [[crimes objectForKey:@"predictedCrime"] objectForKey:@"genericType"], [[crimes objectForKey:@"predictedCrime"] objectForKey:@"time"]]];            /*
                                                                                                                                                                                                                                                            NSArray *arr = homeMap.overlays;
                                                                                                                                                                                                                                                            [homeMap removeOverlays:arr];
                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                            MKCircle *sampleCircle = [MKCircle circleWithCenterCoordinate:coord radius:800];
                                                                                                                                                                                                                                                            [homeMap addOverlay:sampleCircle];
                                                                                                                                                                                                                                                            [analyticsItem setEnabled:YES];*/
                    
                    
                    NSMutableDictionary *dataSet = [[NSMutableDictionary alloc] init];
                    NSMutableArray *crimesInArea = [crimes objectForKey:@"crimesInArea"];
                    for (NSDictionary *crimeObject in crimesInArea) {
                        NSString *lat = [crimeObject objectForKey:@"lat"];
                        NSString *lon = [crimeObject objectForKey:@"long"];
                        NSString *wt = [crimeObject objectForKey:@"weight"];
                        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat.doubleValue
                                                                          longitude:lon.doubleValue];
                        MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
                        // [dataSet setObject:@(wt.integerValue) forKey:];
                        NSValue *pointValue = [NSValue value:&point withObjCType:@encode(MKMapPoint) ];
                        dataSet[pointValue] = @(wt.integerValue);
                    }
                    
                    homeMap.delegate = self;
                    self.heatmap = [[DTMHeatmap alloc] init];
                    
                    [self.heatmap setData:dataSet];
                    
                    NSArray *arr = homeMap.overlays;
                    [homeMap removeOverlays:arr];
                    
                    
                    [homeMap addOverlay:self.heatmap level:MKOverlayLevelAboveRoads];
                }
                
            }];
            [dataTask resume];

        }
    }];
    [dataTask resume];
    
    //  AWSLexAudioPlayer *player = [[AWSLexAudioPlayer alloc] initWithData:response.audioStream];
    // [player start];
}

-(void)voiceButton:(AWSLexVoiceButton *)button onError:(NSError *)error {
    NSLog(@"%@", error.description);
}

@end
