//
//  TodayViewController.h
//  CaveatWidget
//
//  Created by Rahman on 5/27/17.
//  Copyright © 2017 Ali Rahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import <NotificationCenter/NotificationCenter.h>


@interface TodayViewController : UIViewController  <CLLocationManagerDelegate>{
    IBOutlet UILabel *predictedLabel;
    IBOutlet UILabel *severityLabel;
    IBOutlet UILabel *latlongLabel;
    NSMutableArray *categories;
    NSInteger totalCount;

}

@property(nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) NSDictionary *crimes;

@property (nonatomic, copy) void (^completionHandler)(NCUpdateResult);
@end

