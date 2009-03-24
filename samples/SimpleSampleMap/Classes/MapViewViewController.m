//
//  MapViewViewController.m
//
// Copyright (c) 2008, Route-Me Contributors
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "MapViewViewController.h"

#import "RMMapContents.h"
#import "RMFoundation.h"
#import "RMMarker.h"
#import "RMMarkerManager.h"

@implementation MapViewViewController

@synthesize mapViewPortrait;
@synthesize mapViewLandscape;
@synthesize mapView;
@synthesize locationManager;
@synthesize currentLocation;

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation: (UIInterfaceOrientation)toOrientation
													duration: (NSTimeInterval)duration
{
	if (toOrientation == UIInterfaceOrientationPortrait)
	{
		self.mapView		= self.mapViewPortrait;
		self.view.transform = CGAffineTransformIdentity;
		self.view.transform = CGAffineTransformMakeRotation(degreesToRadian(0.0));
		self.view.bounds	= CGRectMake(0.0, 0.0, 460.0, 320.0);
	}
	else if (toOrientation == UIInterfaceOrientationLandscapeLeft)
	{
		self.mapView		= self.mapViewLandscape;
		self.view.transform	= CGAffineTransformIdentity;
		self.view.transform = CGAffineTransformMakeRotation(degreesToRadian(-90));
		self.view.bounds	= CGRectMake(0.0, 0.0, 300.0, 480.0);
	}
	else if (toOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		self.mapView		= self.mapViewPortrait;
		self.view.transform = CGAffineTransformIdentity;
		self.view.transform = CGAffineTransformMakeRotation(degreesToRadian(180.0));
		self.view.bounds	= CGRectMake(0.0, 0.0, 460.0, 320.0);
	}
	else if (toOrientation == UIInterfaceOrientationLandscapeRight)
	{
		self.mapView		= self.mapViewLandscape;
		self.view.transform	= CGAffineTransformIdentity;
		self.view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
		self.view.bounds	= CGRectMake(0.0, 0.0, 300.0, 480.0);
	}
}

// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
        // Custom initialization
    }
	
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/

- (void)testMarkers
{
	RMMarkerManager *markerManager	= [mapView markerManager];
	NSArray			*markers		= [markerManager getMarkers];
	
	NSLog(@"Nb markers %d", [markers count]);
	
	NSEnumerator *markerEnumerator = [markers objectEnumerator];
	RMMarker *aMarker;
	
	while (aMarker = (RMMarker *)[markerEnumerator nextObject])
	{
//		RMXYPoint point						= [aMarker location];
//		CGPoint screenPoint					= [markerManager getMarkerScreenCoordinate: aMarker];
//		CLLocationCoordinate2D coordinates	=  [markerManager getMarkerCoordinate2D: aMarker];
		
		[markerManager removeMarker:aMarker];
	}
	
	// Put the marker back
	RMMarker *marker = [[RMMarker alloc]initWithKey:RMMarkerBlueKey];
	[marker setTextLabel:@"Hello"];
	
	[markerManager addMarker:marker 
				   AtLatLong:[[mapView contents] mapCenter]];
	
	[markerManager addDefaultMarkerAt:[[mapView contents] mapCenter]];
	[marker release];
	markers  = [markerManager getMarkersForScreenBounds];
	
	NSLog(@"Nb Markers in Screen: %d", [markers count]);
	
	//	[mapView getScreenCoordinateBounds];
	
	[markerManager hideAllMarkers];
	[markerManager unhideAllMarkers];
	

}

- (BOOL)mapView:(RMMapView *)map 
shouldDragMarker:(RMMarker *)marker
	  withEvent:(UIEvent *)event
{
   //If you do not implement this function, then all drags on markers will be sent to the didDragMarker function.
   //If you always return YES you will get the same result
   //If you always return NO you will never get a call to the didDragMarker function
   return YES;
}

- (void)mapView:(RMMapView *)map
  didDragMarker:(RMMarker *)marker 
	  withEvent:(UIEvent *)event 
{
   CGPoint position = [[[event allTouches] anyObject] locationInView:mapView];
   
	RMMarkerManager *markerManager = [mapView markerManager];

	NSLog(@"New location: X:%lf Y:%lf", [marker location].x, [marker location].y);
	CGRect rect = [marker bounds];
	
	[markerManager moveMarker:marker 
						 AtXY:CGPointMake(position.x,position.y +rect.size.height/3)];

}

- (void) singleTapOnMap: (RMMapView*) map 
					 At: (CGPoint) point
{
	NSLog(@"Clicked on Map - New location: X:%lf Y:%lf", point.x, point.y);
}

- (void) tapOnMarker: (RMMarker*) marker 
			   onMap: (RMMapView*) map
{
	NSLog(@"MARKER TAPPED!");
	RMMarkerManager *markerManager = [mapView markerManager];
	[marker removeLabel];
	if (!tap)
	{
		[marker replaceImage:[[UIImage imageNamed:@"marker-red.png"] CGImage]  
				 anchorPoint:CGPointMake(0.5, 1.0)];
		[marker setTextLabel:@"World"];
		tap=YES;
		[markerManager moveMarker:marker 
							 AtXY:CGPointMake([marker position].x,[marker position].y + 20.0)];
		[mapView setDeceleration:YES];
	}
	else
	{
		[marker replaceImage:[[UIImage imageNamed:@"marker-blue.png"] CGImage]   
				 anchorPoint:CGPointMake(0.5, 1.0)];
		[marker setTextLabel:@"Hello"];
		[markerManager moveMarker:marker 
							 AtXY:CGPointMake([marker position].x, [marker position].y - 20.0)];
		tap = NO;
		[mapView setDeceleration:NO];
	}

}

- (void) tapOnLabelForMarker:(RMMarker*) marker 
					   onMap:(RMMapView*) map
{
	NSLog(@"Label <0x%x, RC:%U> tapped for marker <0x%x, RC:%U>",  marker.labelView, [marker.labelView retainCount], marker, [marker retainCount]);
	[marker setTextLabel:[NSString stringWithFormat:@"Tapped! (%U)", ++tapCount]];
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	mapViewPortrait = [[RMMapView alloc]initWithFrame:CGRectMake(0.0, 
														  0.0, 
														  320.0, 
														  460.0)]; 
	mapViewLandscape = [[RMMapView alloc]initWithFrame:CGRectMake(0.0, 
																 0.0, 
																 480.0, 
																 300.0)]; 
	locationManager	= [[CLLocationManager alloc] init];
	locationManager.delegate		= self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	if (locationManager.locationServicesEnabled == NO)
	{
		NSLog(@"Services not enabled");
		return;
	}
	
	[locationManager startUpdatingLocation];

	tap = NO;
	RMMarkerManager *markerManager = [mapView markerManager];

	[mapView setDelegate:self];
	[mapView setBackgroundColor:[UIColor grayColor]];  //or clear etc 

	if (locationManager.location != nil)
	{
		currentLocation = locationManager.location.coordinate;
		
		NSLog(@"Location: Lat: %lf Lon: %lf", currentLocation.latitude, currentLocation.longitude);
		
		[mapView moveToLatLong:currentLocation]; 
	}
	
	[self.view addSubview:mapView]; 

	[markerManager addDefaultMarkerAt:currentLocation];
	
	RMMarker *marker = [[RMMarker alloc]initWithKey:RMMarkerBlueKey];
	[marker setTextForegroundColor:[UIColor blueColor]];
	[marker setTextLabel:@"Hello"];
	[markerManager addMarker:marker 
				   AtLatLong:currentLocation];
	[marker release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}


- (void)didReceiveMemoryWarning 
{
	// due to a bug, RMMapView should never be released, as it causes the application to crash
    //[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview

	[mapView.contents didReceiveMemoryWarning];
}


- (void)dealloc 
{
	[mapView release];
	[locationManager stopUpdatingLocation];
	[locationManager release];
	
    [super dealloc];
}

#pragma mark --
#pragma mark locationManagerDelegate Methods

- (void)locationManager: (CLLocationManager *)manager 
	didUpdateToLocation: (CLLocation *)newLocation
		   fromLocation: (CLLocation *)oldLocation
{
	NSLog(@"Moving from lat: %lf lon: %lf to lat: %lf lon: %lf", 
		  oldLocation.coordinate.latitude, oldLocation.coordinate.longitude,
		  newLocation.coordinate.latitude, newLocation.coordinate.longitude);
	
	currentLocation = newLocation.coordinate;
	[mapView moveToLatLong:currentLocation]; 
}

- (void)locationManager: (CLLocationManager *)manager
	   didFailWithError: (NSError *)error
{
	NSLog(@"Location Manager error: %@", [error localizedDescription]);
}

@synthesize tap;
@synthesize tapCount;
@end
