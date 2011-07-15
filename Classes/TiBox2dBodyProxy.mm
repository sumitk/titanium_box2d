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
	if ((self = [super _initWithPageContext:context]))
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

#define B2VEC2_ARRAY(v) [NSArray arrayWithObjects:NUMDOUBLE(v.x), NUMDOUBLE(v.y),nil];
#define ARRAY_B2VEC2(a,b) b2Vec2 b([TiUtils doubleValue:[a objectAtIndex:0]], [TiUtils doubleValue:[a objectAtIndex:1]]);

-(NSArray*)getLocalCenter:(id)args
{
    const b2Vec2& center = body->GetLocalCenter();
    return B2VEC2_ARRAY(center);
}

-(NSArray*)getWorldCenter:(id)args
{
    const b2Vec2& center = body->GetWorldCenter();
    return B2VEC2_ARRAY(center);
}

-(NSArray*)getLinearVelocity:(id)args
{
    const b2Vec2& velocity = body->GetLinearVelocity();
    return B2VEC2_ARRAY(velocity);
}

-(NSArray*)getPosition:(id)args
{
    const b2Vec2& velocity = body->GetPosition();
    return B2VEC2_ARRAY(velocity);
}

-(id)getAngularVelocity:(id)args
{
    float v = body->GetAngularVelocity();
    return NUMFLOAT(v);
}

-(id)getMass:(id)args
{
    float v = body->GetMass();
    return NUMFLOAT(v);
}

-(id)getInertia:(id)args
{
    float v = body->GetInertia();
    return NUMFLOAT(v);
}

-(id)isAwake:(id)args
{
    return NUMBOOL(body->IsAwake());
}

-(void)setAwake:(id)args
{
    ENSURE_SINGLE_ARG(args,NSNumber);
    
    bool x = [TiUtils boolValue:args];
    body->SetAwake(x);
}

-(void)setLinearVelocity:(id)args
{
    ENSURE_SINGLE_ARG(args,NSArray);
    ARRAY_B2VEC2(args,v);
    body->SetLinearVelocity(v);
}

//
// body.applyForce([1,0], [1,2])
//
-(void)applyForce:(id)args
{
    ENSURE_ARG_COUNT(args, 2);
    
    NSArray *a1 = [args objectAtIndex:0];
    NSArray *a2 = [args objectAtIndex:1];
    
    ARRAY_B2VEC2(a1,force);
    ARRAY_B2VEC2(a2,point);
    
    body->ApplyForce(force, point);
}

//
// body.applyLinearImpulse([1,0], [1,2])
//
-(void)applyLinearImpulse:(id)args
{
    ENSURE_ARG_COUNT(args, 2);
    
    NSArray *a1 = [args objectAtIndex:0];
    NSArray *a2 = [args objectAtIndex:1];
    
    ARRAY_B2VEC2(a1,force);
    ARRAY_B2VEC2(a2,point);
    
    body->ApplyLinearImpulse(force, point);
}

//
// body.applyTorque(1.0f)
//
-(void)applyTorque:(id)args
{
    ENSURE_SINGLE_ARG(args,NSNumber);
    
    CGFloat t = [TiUtils floatValue:args];
    body->ApplyTorque(t);
}

//
// body.applyAngularImpulse(1.0f)
//
-(void)applyAngularImpulse:(id)args
{
    ENSURE_SINGLE_ARG(args,NSNumber);
    
    CGFloat i = [TiUtils floatValue:args];
    body->ApplyAngularImpulse(i);
}

@end
