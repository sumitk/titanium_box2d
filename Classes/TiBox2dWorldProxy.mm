/**
 * Appcelerator Titanium Mobile Modules
 * Copyright (c) 2011 by Appcelerator, Inc. All Rights Reserved.
 * Proprietary and Confidential - This source code is not for redistribution
 */

#import "TiBox2dWorldProxy.hh"
#import "TiUtils.h"
#import "TiViewProxy.h"
#import "TiContactListener.h"
#import "TiBox2dBodyProxy.hh"

#define PTM_RATIO 16

@implementation TiBox2dWorldProxy


-(void)_destroy
{
	[lock lock];
	_destroyed = YES;
	[timer invalidate];
	timer = nil;
	if (world)
	{
		delete world;
		world = nil;
	}
	[lock unlock];
	[super _destroy];
}

-(void)dealloc
{
	[lock lock];
	[timer invalidate]; timer = nil;
	if (world)
	{
		delete world; 
		world = nil;
	}
	if (contactListener)
	{
		delete contactListener;
		contactListener = nil;
	}
	[lock unlock];
	RELEASE_TO_NIL(surface);
	RELEASE_TO_NIL(lock);
	[super dealloc];
}

-(id)initWithViewProxy:(TiViewProxy*)view pageContext:(id<TiEvaluator>)context
{
	if (self = [super _initWithPageContext:context])
	{
		surface = [view retain];
		lock = [[NSRecursiveLock alloc] init];
	}
	return self;
}

-(b2World*)world
{
	return world;
}

-(void)_createWorld
{
	[lock lock];
	if (world) 
	{
		[lock unlock];
		return;
	}
	
	CGSize size = [[surface view] bounds].size;
	
	gravity.Set(0.0f, -9.81f); 
	
	// Construct a world object, which will hold and simulate the rigid bodies.
	world = new b2World(gravity, false); //TODO: make configurable sleep
	world->SetContinuousPhysics(true);
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	//FIXME: do i need to release groundBody
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(size.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox, 0);
	
	// top
	groundBox.Set(b2Vec2(0,size.height/PTM_RATIO), b2Vec2(size.width/PTM_RATIO,size.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox, 0);
	
	// left
	groundBox.Set(b2Vec2(0,size.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox, 0);
	
	// right
	groundBox.Set(b2Vec2(size.width/PTM_RATIO,size.height/PTM_RATIO), b2Vec2(size.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox, 0);

	if (contactListener)
	{
		world->SetContactListener(contactListener);
	}
	
	[lock unlock];
}

-(void)start:(id)args
{
	ENSURE_UI_THREAD_0_ARGS
	[lock lock];
	if (timer)
	{
		[timer invalidate];
		timer = nil;
	}
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
	[lock unlock];
}

-(void)stop:(id)args
{
	ENSURE_UI_THREAD_0_ARGS
	[lock lock];
	if (timer)
	{
		[timer invalidate];
		timer = nil;
	}
	[lock unlock];
}

-(void)_listenerAdded:(NSString *)type count:(int)count 
{
	[lock lock];
	if (count == 1 && [type isEqualToString:@"collision"] && contactListener==nil)
	{
		contactListener = new TiContactListener(self);
		if (world)
		{
			world->SetContactListener(contactListener);
		}
	}
	[lock unlock];
}

-(void)_listenerRemoved:(NSString *)type count:(int)count 
{
	[lock lock];
	if (count == 0 && contactListener && [type isEqualToString:@"collision"])
	{
		world->SetContactListener(nil);
		delete contactListener;
		contactListener = nil;
	}
	[lock unlock];
}

-(void)setGravity:(id)args
{
	[lock lock];
	if (args && [args count] > 1 && world)
	{
		CGFloat x = [TiUtils floatValue:[args objectAtIndex:0]];
		CGFloat y = [TiUtils floatValue:[args objectAtIndex:1]];
		gravity.Set(x,y);
		world->SetGravity(gravity);
	}
	[lock unlock];
}

-(void)addBodyToView:(TiViewProxy*)viewproxy
{
	if (_destroyed==NO)
	{
		[self _createWorld];
		[surface add:viewproxy];
	}
}

-(id)addBody:(id)args
{
	TiViewProxy *viewproxy = [args objectAtIndex:0];
	NSDictionary *props = [args count] > 1 ? [args objectAtIndex:1] : nil;
	
	[self performSelectorOnMainThread:@selector(addBodyToView:) withObject:viewproxy waitUntilDone:YES];
	UIView *physicalView = [viewproxy view];


	// Define the dynamic body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	
	CGPoint p = physicalView.center;
	CGPoint boxDimensions = CGPointMake(physicalView.bounds.size.width/PTM_RATIO/2.0,physicalView.bounds.size.height/PTM_RATIO/2.0);
	
	CGFloat height = [surface view].bounds.size.height;
	bodyDef.position.Set(p.x/PTM_RATIO, ( height - p.y)/PTM_RATIO);
	
	[lock lock];
	
	TiBox2dBodyProxy *bp = nil;
	
	if (world && boxDimensions.x > 0 && boxDimensions.y > 0)
	{

		// Tell the physics world to create the body
		b2Body *body = world->CreateBody(&bodyDef);


		// Define the dynamic body fixture.
		b2FixtureDef fixtureDef;
		
		CGFloat radius = [TiUtils floatValue:@"radius" properties:props def:-1.0];
		if (radius > 0)
		{
			b2CircleShape circle;
			fixtureDef.shape = &circle;
			circle.m_radius = radius / PTM_RATIO;
		}
		else
		{
			
			// Define another box shape for our dynamic body.
			b2PolygonShape dynamicBox;
			dynamicBox.SetAsBox(boxDimensions.x, boxDimensions.y);
			fixtureDef.shape = &dynamicBox;
		}	
		fixtureDef.density =  [TiUtils floatValue:@"density" properties:props def:3.0f];
		fixtureDef.friction = [TiUtils floatValue:@"friction" properties:props def:0.3f];
		fixtureDef.restitution = [TiUtils floatValue:@"restitution" properties:props def:0.5f]; // 0 is a lead ball, 1 is a super bouncy ball

		body->CreateFixture(&fixtureDef);
		
		NSString *bodyType = [TiUtils stringValue:@"type" properties:props def:@"dynamic"];
		if ([bodyType isEqualToString:@"dynamic"])
		{
			body->SetType(b2_dynamicBody);
		}
		else if ([bodyType isEqualToString:@"static"])
		{
			body->SetType(b2_staticBody);
		}
		else if ([bodyType isEqualToString:@"kinematic"])
		{
			body->SetType(b2_kinematicBody);
		}
		
		// we abuse the tag property as pointer to the physical body
		physicalView.tag = (int)body;
		
		bp = [[TiBox2dBodyProxy alloc] initWithBody:body viewproxy:viewproxy pageContext:[self executionContext]];
		
		body->SetUserData(bp);
	}
	
	[lock unlock];
	
	return bp;
}

-(void)tick:(NSTimer *)timer
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	[lock lock];
	
	if (world)
	{
		
		int32 velocityIterations = 8;
		int32 positionIterations = 1;
		
		// Instruct the world to perform a single step of simulation. It is
		// generally best to keep the time step and iterations fixed.
		world->Step(1.0f/60.0f, velocityIterations, positionIterations);

		CGSize size = [[surface view] bounds].size;
		
		//Iterate over the bodies in the physics world
		for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
		{
			void *ud = b->GetUserData();
			
			if (ud != NULL && sizeof(ud)==sizeof(id) && [(id)ud isKindOfClass:[TiBox2dBodyProxy class]])
			{
				UIView *oneView = [[(TiBox2dBodyProxy *)ud viewproxy] view];
				
				// y Position subtracted because of flipped coordinate system
				CGPoint newCenter = CGPointMake(b->GetPosition().x * PTM_RATIO,
												size.height - b->GetPosition().y * PTM_RATIO);
				oneView.center = newCenter;
				
				CGAffineTransform transform = CGAffineTransformMakeRotation(- b->GetAngle());
				
				oneView.transform = transform;
			}
		}
	}
	
	[lock unlock];
}

@end
