//
//  ReportCrimeViewController.m
//  CodeDay2
//
//  Created by Rahman on 5/20/17.
//  Copyright © 2017 Ali Rahman. All rights reserved.
//

#import "ReportCrimeViewController.h"

@interface ReportCrimeViewController ()

@end

@implementation ReportCrimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    crimeOptionArray = [[NSMutableArray alloc] initWithObjects:
                        @"Arson",
                        @"Aggravated Assault / Battery",
                        @"Child Abandonment",
                        @"Child Abuse",
                        @"Disturbing the Peace",
                        @"Drug Manufacturing and Cultivation",
                        @"Drug Trafficking / Distribution",
                        @"DUI / DWI",
                        @"Fraud",
                        @"Harassment",
                        @"Hate Crimes",
                        @"Homicide",
                        @"Kidnapping",
                        @"Manslaughter: Involuntary",
                        @"Manslaughter: Voluntary",
                        @"MIP: A Minor in Possession",
                        @"Open Container Law",
                        @"Prostitution",
                        @"Public Intoxication",
                        @"Rape",
                        @"Robbery",
                        @"Sexual Assault",
                        @"Shoplifting",
                        @"Stalking",
                        @"Vandalism",
                        @"Burglary",
                        @"Theft / Larceny", nil];
    searchArray = [[NSMutableArray alloc] initWithArray:crimeOptionArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Collection Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return searchArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"crimeCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    [label setText:[searchArray objectAtIndex:indexPath.item]];
    
    UIImageView *iV = (UIImageView *)[cell viewWithTag:2];
    NSString *str = [searchArray objectAtIndex:indexPath.item];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    str = [str stringByReplacingOccurrencesOfString:@"/" withString:@""];
    [iV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",str]]];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [optionsSearchBar resignFirstResponder];
}

// Search bar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) searchArray = crimeOptionArray;
    else {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSString *item in crimeOptionArray) {
            if ([item rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [arr addObject:item];
            }
        }
        searchArray = arr;
        [crimeOptionCollectionView reloadData];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    searchArray = crimeOptionArray;
    [crimeOptionCollectionView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
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
