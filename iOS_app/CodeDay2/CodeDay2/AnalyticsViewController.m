//
//  AnalyticsViewController.m
//  CodeDay2
//
//  Created by Rahman on 5/21/17.
//  Copyright © 2017 Ali Rahman. All rights reserved.
//

#import "AnalyticsViewController.h"
#import "ViewController.h"
#import <ChameleonFramework/Chameleon.h>

@interface AnalyticsViewController ()

@end

@implementation AnalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // OGVC
    [self.swiftySideMenu setDelegate:self];
    [pieChart setDelegate:self];
    [pieChart setDataSource:self];
    [pieChart setStartPieAngle:M_PI_2];	//optional
    [pieChart setAnimationSpeed:1.0];	//optional
    [pieChart setLabelColor:[UIColor blackColor]];	//optional, defaults to white
    [pieChart setLabelRadius:80];	//optional
    [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];	//optional
    [pieChart setShowLabel:YES];
    [pieChart setShowPercentage:NO];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

-(void)swiftSideMenu:(SwiftySideMenuViewController *)sideMenuController animationDidFinishInSide:(SwiftyMenuSide)side finished:(BOOL)finished {
    ViewController *ogvc = (ViewController *)self.swiftySideMenu.centerViewController;
    
    totalCount = [(NSArray *)[ogvc.crimes objectForKey:@"crimesInArea"] count];
    [crimeCount setText:[NSString stringWithFormat:@"Crime Count: %i", (int)totalCount]];
    
    categories = [[NSMutableArray alloc] initWithObjects:[NSMutableArray new], [NSMutableArray new], [NSMutableArray new], [NSMutableArray new], [NSMutableArray new], [NSMutableArray new], [NSMutableArray new], [NSMutableArray new], [NSMutableArray new], nil];
    
    NSMutableArray *monthCounts = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],nil];
    for (NSDictionary *crime in [ogvc.crimes objectForKey:@"crimesInArea"] ) {
        // Crime Type
        if ([[crime objectForKey:@"genericType"] isEqualToString:@"Homicide"]) {
            [[categories objectAtIndex:0] addObject:crime];
        }
        else if ([[crime objectForKey:@"genericType"] isEqualToString:@"Violence"]) {
            [[categories objectAtIndex:1] addObject:crime];
        }
        else if ([[crime objectForKey:@"genericType"] isEqualToString:@"Human Trafficking"]) {
            [[categories objectAtIndex:2] addObject:crime];
        }
        else if ([[crime objectForKey:@"genericType"] isEqualToString:@"Unlawful Firearm"]) {
            [[categories objectAtIndex:3] addObject:crime];
        }
        else if ([[crime objectForKey:@"genericType"] isEqualToString:@"Drug or Alcohol Offense"]) {
            [[categories objectAtIndex:4] addObject:crime];
        }
        else if ([[crime objectForKey:@"genericType"] isEqualToString:@"Property Offense"]) {
            [[categories objectAtIndex:5] addObject:crime];
        }
        else if ([[crime objectForKey:@"genericType"] isEqualToString:@"Personal Affront"]) {
            [[categories objectAtIndex:6] addObject:crime];
        }
        else if ([[crime objectForKey:@"genericType"] isEqualToString:@"Theft"]) {
            [[categories objectAtIndex:7] addObject:crime];
        }
        else if ([[crime objectForKey:@"genericType"] isEqualToString:@"Other"]) {
            [[categories objectAtIndex:8] addObject:crime];
        }
        
        // Crime Date
        NSString *date = [[crime objectForKey:@"date"] componentsSeparatedByString:@"/"][0];
        if ([date isEqualToString:@"01"]) {
            int a = [[monthCounts objectAtIndex:0] intValue];
            a++;
            [monthCounts setObject:[NSNumber numberWithInt:a] atIndexedSubscript:0];
        }
        else if ([date isEqualToString:@"02"]) {
            int a = [[monthCounts objectAtIndex:1] intValue];
            a++;
            [monthCounts setObject:[NSNumber numberWithInt:a] atIndexedSubscript:1];
        }
        else if ([date isEqualToString:@"03"]) {
            int a = [[monthCounts objectAtIndex:2] intValue];
            a++;
            [monthCounts setObject:[NSNumber numberWithInt:a] atIndexedSubscript:2];
        }
        else if ([date isEqualToString:@"04"]) {
            int a = [[monthCounts objectAtIndex:3] intValue];
            a++;
            [monthCounts setObject:[NSNumber numberWithInt:a] atIndexedSubscript:3];
        }
        else if ([date isEqualToString:@"05"]) {
            int a = [[monthCounts objectAtIndex:4] intValue];
            a++;
            [monthCounts setObject:[NSNumber numberWithInt:a] atIndexedSubscript:4];
        }
        else if ([date isEqualToString:@"06"]) {
            int a = [[monthCounts objectAtIndex:5] intValue];
            a++;
            [monthCounts setObject:[NSNumber numberWithInt:a] atIndexedSubscript:5];
        }
        else if ([date isEqualToString:@"07"]) {
            int a = [[monthCounts objectAtIndex:6] intValue];
            a++;
            [monthCounts setObject:[NSNumber numberWithInt:a] atIndexedSubscript:6];
        }
        else if ([date isEqualToString:@"08"]) {
            int a = [[monthCounts objectAtIndex:7] intValue];
            a++;
            [monthCounts setObject:[NSNumber numberWithInt:a] atIndexedSubscript:7];
        }
        else if ([date isEqualToString:@"09"]) {
            int a = [[monthCounts objectAtIndex:8] intValue];
            a++;
            [monthCounts setObject:[NSNumber numberWithInt:a] atIndexedSubscript:8];
        }
        else if ([date isEqualToString:@"10"]) {
            int a = [[monthCounts objectAtIndex:9] intValue];
            a++;
            [monthCounts setObject:[NSNumber numberWithInt:a] atIndexedSubscript:9];
        }
        else if ([date isEqualToString:@"11"]) {
            int a = [[monthCounts objectAtIndex:10] intValue];
            a++;
            [monthCounts setObject:[NSNumber numberWithInt:a] atIndexedSubscript:10];
        }
        else if ([date isEqualToString:@"12"]) {
            int a = [[monthCounts objectAtIndex:11] intValue];
            a++;
            [monthCounts setObject:[NSNumber numberWithInt:a] atIndexedSubscript:11];
        }
    }
    [pieChart reloadData];
    
    NSArray* months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];

    [lineChart clearChartData];
    
    lineChart.labelForIndex = ^(NSUInteger item) {
        return months[item];
    };
    
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%i crimes", (int)value];
    };
  
    [lineChart setChartData:monthCounts];
    

}

// PIE CHART DATA

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return 9;
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    return [(NSArray *)[categories objectAtIndex:index] count]/(totalCount*1.0);
    }
//- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index;	//optional
- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
    NSString *value;
    switch (index) {
        case 0:
            value = @"Homicide";
            break;
        
        case 1:
            value = @"Violence";
            break;
            
        case 2:
            value = @"Trafficking";
            break;
            
        case 3:
            value = @"Firearms";
            break;
        
        case 4:
            value = @"Drugs/Alcohol";
            break;
            
        case 5:
            value = @"Property Offense";
            break;
            
        case 6:
            value = @"Personal Affront";
            break;
            
        case 7:
            value = @"Theft";
            break;
            
        case 8:
            value = @"Other";
            break;
            
        default:
            value = @"Null";
            break;
            
    }
    return value;

}//optional
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    return  [UIColor colorWithRandomFlatColorOfShadeStyle:UIShadeStyleLight];

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
