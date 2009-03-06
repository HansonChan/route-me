//
//  RMMarker.h
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

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RMMapLayer.h"
#import "RMFoundation.h"

@class RMMarkerStyle;

extern NSString * const RMMarkerBlueKey;
extern NSString * const RMMarkerRedKey;

@class RMMarkerManager;

@class RMMarker;
@class RMRadiusLayer;

@protocol RMMarkerChangeDelegate

- (void)markerChanged:(RMMarker*)marker;
- (void)marker:(RMMarker*)marker focused:(BOOL)focus;

@end

@interface RMMarker : RMMapLayer <RMMovingMapLayer,RMScalingMapLayer> {
	RMXYPoint location;
    RMMarkerManager *manager;
	NSObject* data;
    id<RMMarkerChangeDelegate> markerChangeDelegate;
    CALayer *imageLayer;
    RMRadiusLayer *radiusLayer;
	CGFloat metersPerPixel;
    CLLocationDistance radius;
    
	// A label which comes up when you tap the marker
	UIView* labelView;
}

+ (RMMarker*) markerWithNamedStyle: (NSString*) styleName;
+ (CGImageRef) markerImage: (NSString *) key;
+ (CGImageRef) loadPNGFromBundle: (NSString *)filename;

// Call this with either RMMarkerBlue or RMMarkerRed for the key.
+ (CGImageRef) markerImage: (NSString *) key;

- (id) initWithCGImage: (CGImageRef) image anchorPoint: (CGPoint) anchorPoint;
- (id) initWithCGImage: (CGImageRef) image;
- (id) initWithKey: (NSString*) key;
- (id) initWithUIImage: (UIImage*) image;
- (id) initWithStyle: (RMMarkerStyle*) style;
- (id) initWithNamedStyle: (NSString*) styleName;

// These helper methods update the labelView to show some text
// Position is specified relative to the overlay view
- (void) setTextLabel: (NSString*)text;
- (void) setTextLabel: (NSString*)text atPosition:(CGPoint)position;
- (void) setTextLabel: (NSString*)text withFont:(UIFont*)font withTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)backgroundColor;
- (void) setTextLabel: (NSString*)text atPosition:(CGPoint)position withFont:(UIFont*)font withTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)backgroundColor;

- (void) toggleLabelAnimated:(BOOL)animate;
- (void) showLabelAnimated:(BOOL)animate;
- (void) hideLabelAnimated:(BOOL)animate;
- (void) removeLabel;
- (void) setFocused:(BOOL)aFocused;
- (BOOL) focused;

// Subclasses can override this to specify whether a point is acceptable for touch
// By default, observes the touchAcceptRegion property.
- (BOOL) canAcceptTouchWithPoint:(CGPoint)point;

- (void) replaceImage:(CGImageRef)image anchorPoint:(CGPoint)_anchorPoint;
- (void) replaceKey: (NSString*) key;

@property (assign, nonatomic) RMXYPoint location;
@property (retain) NSObject* data;
@property (nonatomic, retain) UIView* labelView;
@property (nonatomic,assign,setter=setMarkerManager:) RMMarkerManager *manager;
@property (nonatomic,assign) id<RMMarkerChangeDelegate> markerChangeDelegate;
@property (assign,nonatomic) CLLocationDistance radius;
@property (nonatomic,readonly) RMRadiusLayer *radiusLayer;


@end
