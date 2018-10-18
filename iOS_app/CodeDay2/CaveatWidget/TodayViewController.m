//
//  TodayViewController.m
//  CaveatWidget
//
//  Created by Rahman on 5/27/17.
//  Copyright © 2017 Ali Rahman. All rights reserved.
//

#import "TodayViewController.h"
#import "MKMapView+ZoomLevel.h"
#import <ChameleonFramework/Chameleon.h>

#define CLCOORDINATE_EPSILON 0.005f
#define CLCOORDINATES_EQUAL2( coord1, coord2 ) (fabs(coord1.latitude - coord2.latitude) < CLCOORDINATE_EPSILON && fabs(coord1.longitude - coord2.longitude) < CLCOORDINATE_EPSILON)

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController
@synthesize crimes;

- (void)viewDidLoad {
    [super viewDidLoad];
    // CLLocation manager will handle user location
    _manager = [[CLLocationManager alloc] init];
    [_manager setDelegate:self];
    [_manager requestWhenInUseAuthorization];
    [_manager startUpdatingLocation];
    
    
  /*  [pieChart setDataSource:self];
    [pieChart setStartPieAngle:M_PI_2];	//optional
    [pieChart setAnimationSpeed:1.0];	//optional
    [pieChart setLabelColor:[UIColor blackColor]];	//optional, defaults to white
    [pieChart setLabelRadius:80];	//optional
    [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];	//optional
    [pieChart setShowLabel:YES];
    [pieChart setShowPercentage:NO];
    */
}

-(void)viewDidLayoutSubviews {
    [severityLabel.layer setCornerRadius:severityLabel.frame.size.height/2];
    [severityLabel.layer setBorderWidth:5];
    [severityLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    self.completionHandler = completionHandler;
    
}

// CLLocation manager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocationCoordinate2D coord = [locations lastObject].coordinate;
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *afmanager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"http://10.1.107.50:4000/sevpred?lat=%f&long=%f", coord.latitude, coord.longitude];
    
    
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSURLRequest requestWithURL:URL] mutableCopy];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *dataTask = [afmanager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            crimes = (NSDictionary *)responseObject;

            [predictedLabel setText:[NSString stringWithFormat:@"Predicted Crime: %@", [[crimes objectForKey:@"predictedCrime"] objectForKey:@"genericType"]]];
            
            float sev = [[crimes objectForKey:@"severity"] floatValue];
            
            float percent = sev / 10.0;
            
            double resultRed = 81 + percent * (244 - 81);
            double resultGreen = 145 + percent * (75 - 145);
            double resultBlue = 247 + percent * (66 - 247);
            
            [severityLabel setText:[NSString stringWithFormat:@"%.2f", [[crimes objectForKey:@"severity"] floatValue] ]];
            [severityLabel setBackgroundColor:[UIColor colorWithRed:resultRed/255.0 green:resultGreen/255.0 blue:resultBlue/255.0 alpha:1.0]];
            [latlongLabel setText:[NSString stringWithFormat:@"Latitude: %f \nLongitude: %f", coord.latitude, coord.longitude]];
            self.completionHandler(NCUpdateResultNewData);
            
        }
    }];
    
    [dataTask resume];
    [manager stopUpdatingLocation];
    
    
    
}

@end
