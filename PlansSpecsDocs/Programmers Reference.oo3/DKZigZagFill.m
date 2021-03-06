//
//  DKZigZagFill.m
//  DrawKit
//
//  Created by graham on 04/01/2008.
//  Copyright 2008 Apptree.net. All rights reserved.
//

#import "DKZigZagFill.h"

#import "NSBezierPath+Geometry.h"
#import "NSObject+GraphicsAttributes.h"


@implementation DKZigZagFill
#pragma mark As a DKZigZagFill

- (void)		setWavelength:(float) w
{
	mWavelength = w;
}


- (float)		wavelength
{
	return mWavelength;
}


#pragma mark -
- (void)		setAmplitude:(float) amp
{
	mAmplitude = amp;
}


- (float)		amplitude
{
	return mAmplitude;
}


#pragma mark -
- (void)		setSpread:(float) sp
{
	mSpread = sp;
}


- (float)		spread
{
	return mSpread;
}


#pragma mark -
#pragma mark As a GCObservableObject
+ (NSArray*)		observableKeyPaths
{
	return [[super observableKeyPaths] arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:@"wavelength", @"amplitude", @"spread", nil]];
}


- (void)		registerActionNames
{
	[super registerActionNames];
	[self setActionName:@"#kind# Fill Zig-Zag Wavelength" forKeyPath:@"wavelength"];
	[self setActionName:@"#kind# Fill Zig-Zag Amplitude" forKeyPath:@"amplitude"];
	[self setActionName:@"#kind# Fill Zig-Zag Spread" forKeyPath:@"spread"];
}


#pragma mark -
#pragma mark As an NSObject
- (id)			init
{
	self = [super init];
	if (self != nil)
	{
		[self setWavelength:10];
		[self setAmplitude:5];
		NSAssert(mSpread == 0.0, @"Expected init to zero");
	}
	return self;
}


#pragma mark -
#pragma mark As part of DKRasterizerProtocol
- (NSSize)		extraSpaceNeeded
{
	if([self enabled])
	{
		NSSize esp = [super extraSpaceNeeded];
		
		esp.width += [self amplitude];
		esp.height += [self amplitude];
		
		return esp;
	}
	else
		return NSZeroSize;
}


- (NSBezierPath*)	renderingPathForObject:(id) object
{
	return [[super renderingPathForObject:object] bezierPathWithWavelength:[self wavelength] amplitude:[self amplitude] spread:[self spread]];
}


#pragma mark -
#pragma mark As part of GraphicAttributtes Protocol
- (void)		setValue:(id) val forNumericParameter:(int) pnum
{
	// 3 -> wavelength, 4 -> amplitude, 5 -> spread
	
	switch( pnum )
	{
		default:
			[super setValue:val forNumericParameter:pnum];
			break;
		
		case 3:
			[self setWavelength:[val floatValue]];
			break;
			
		case 4:
			[self setAmplitude:[val floatValue]];
			break;
			
		case 5:
			[self setSpread:[val floatValue]];
			break;
	}
}


#pragma mark -
#pragma mark As part of NSCoding Protocol
- (void)		encodeWithCoder:(NSCoder*) coder
{
	NSAssert(coder != nil, @"Expected valid coder");
	[super encodeWithCoder:coder];
	
	[coder encodeFloat:[self wavelength] forKey:@"wavelength"];
	[coder encodeFloat:[self amplitude] forKey:@"amplitude"];
	[coder encodeFloat:[self spread] forKey:@"spread"];

}


- (id)			initWithCoder:(NSCoder*) coder
{
	NSAssert(coder != nil, @"Expected valid coder");
	self = [super initWithCoder:coder];
	if (self != nil)
	{
		[self setWavelength:[coder decodeFloatForKey:@"wavelength"]];
		[self setAmplitude:[coder decodeFloatForKey:@"amplitude"]];
		[self setSpread:[coder decodeFloatForKey:@"spread"]];
	}
	return self;
}


#pragma mark -
#pragma mark As part of NSCopying Protocol
- (id)			copyWithZone:(NSZone*) zone
{
	DKZigZagFill* copy = [super copyWithZone:zone];
	
	[copy setWavelength:[self wavelength]];
	[copy setAmplitude:[self amplitude]];
	[copy setSpread:[self spread]];
	
	return copy;
}


@end
