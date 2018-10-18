//
//  ReportCrimeViewController.h
//  CodeDay2
//
//  Created by Rahman on 5/20/17.
//  Copyright © 2017 Ali Rahman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCrimeViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate> {
    
    NSMutableArray *crimeOptionArray;
    NSMutableArray *searchArray;
    IBOutlet UISearchBar *optionsSearchBar;
    IBOutlet UICollectionView *crimeOptionCollectionView;
}


@end
