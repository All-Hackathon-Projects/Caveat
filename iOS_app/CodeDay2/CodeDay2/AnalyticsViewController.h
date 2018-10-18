//
//  AnalyticsViewController.h
//  CodeDay2
//
//  Created by Rahman on 5/21/17.
//  Copyright © 2017 Ali Rahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwiftySideMenuViewController.h"
#import "UIViewController+SwiftySideMenu.h"
#import "XYPieChart.h"
#import "FSLineChart.h"

@interface AnalyticsViewController : UIViewController <SwiftySideMenuViewControllerDelegate, XYPieChartDelegate, XYPieChartDataSource> {
    IBOutlet UILabel *crimeCount;
    IBOutlet XYPieChart *pieChart;
    IBOutlet FSLineChart *lineChart;
    NSMutableArray *categories;
    NSInteger totalCount;
}



@end
