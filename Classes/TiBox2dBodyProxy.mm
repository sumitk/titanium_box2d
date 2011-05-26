/**
 * Appcelerator Titanium Mobile Modules
 * Copyright (c) 2011 by Appcelerator, Inc. All Rights Reserved.
 * Proprietary and Confidential - This source code is not for redistribution
 */


#import "TiBox2dBodyProxy.hh"
#import "TiUtils.h"

@implementation TiBox2dBodyProxy

-(id)initWithBody:(b2Body*)body_ viewproxy:(TiViewProxy*)vp pageContext:(id<TiEvaluator>)context
{
	if (self = [super _initWithPageContext:context])
	{
		body = body_;
		viewproxy = [vp retain];
	}
	return self;
}

-(void)dealloc
{
	RELEASE_TO_NIL(viewproxy);
	[super dealloc];
}

-(TiViewProxy*)viewproxy
{
	return viewproxy;
}

@end
