/**
 * Appcelerator Titanium Mobile Modules
 * Copyright (c) 2011 by Appcelerator, Inc. All Rights Reserved.
 * Proprietary and Confidential - This source code is not for redistribution
 */

#import "TiProxy.h"
#import "TiViewProxy.h"

#import <Box2D/Box2D.h>

@interface TiBox2dBodyProxy : TiProxy 
{	
	b2Body *body;
	TiViewProxy *viewproxy;

}

-(id)initWithBody:(b2Body*)body viewproxy:(TiViewProxy*)vp pageContext:(id<TiEvaluator>)context;
-(TiViewProxy*)viewproxy;

@end
