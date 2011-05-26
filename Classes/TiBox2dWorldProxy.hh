/**
 * Appcelerator Titanium Mobile Modules
 * Copyright (c) 2011 by Appcelerator, Inc. All Rights Reserved.
 * Proprietary and Confidential - This source code is not for redistribution
 */

#import "TiProxy.h"
#import "TiViewProxy.h"
#import <Box2D/Box2D.h>
#import "TiContactListener.h"

@interface TiBox2dWorldProxy : TiProxy {

	b2Vec2 gravity;
	b2World *world;
	NSTimer *timer;
	TiViewProxy *surface;
	TiContactListener *contactListener;
	NSLock *lock;
	BOOL _destroyed;
}

-(id)initWithViewProxy:(TiViewProxy*)view pageContext:(id<TiEvaluator>)pageContext;
-(b2World*)world;

@end
