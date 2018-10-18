//
//  MKMapView+ZoomLevel.h
//  CodeDay2
//
//  Created by Rahman on 5/20/17.
//  Copyright © 2017 Ali Rahman. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
