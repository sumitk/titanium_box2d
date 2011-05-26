/**
 * Appcelerator Titanium Mobile Modules
 * Copyright (c) 2011 by Appcelerator, Inc. All Rights Reserved.
 * Proprietary and Confidential - This source code is not for redistribution
 */

#import "TiBox2dModule.hh"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiBox2dWorldProxy.hh"

@implementation TiBox2dModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"906b17ce-2c91-471a-842c-3d6fba6d7d09";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.box2d";
}

#pragma mark box2d

-(id)createWorld:(id)args
{
	TiViewProxy *viewproxy = [args objectAtIndex:0];
	TiBox2dWorldProxy *proxy = [[TiBox2dWorldProxy alloc] initWithViewProxy:viewproxy pageContext:[self executionContext]];
	return [proxy autorelease];
}


@end
