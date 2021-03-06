/**
 *  Copyright 2011 Jeff Haynie
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
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

-(b2Body*)body
{
    return body;
}

#define B2VEC2_ARRAY(v) [NSArray arrayWithObjects:NUMDOUBLE(v.x), NUMDOUBLE(v.y),nil];
#define B2VEC2_ARRAY_WITH_PTM_RATIO(v) [NSArray arrayWithObjects:NUMDOUBLE(v.x*PTM_RATIO), NUMDOUBLE(v.y*PTM_RATIO),nil];

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
    return B2VEC2_ARRAY_WITH_PTM_RATIO(velocity);
}

-(id)getAngle:(id)args
{
    return NUMFLOAT(body->GetAngle());
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

-(id)isBullet:(id)args
{
    return NUMBOOL(body->IsBullet());
}

-(id)isActive:(id)args
{
    return NUMBOOL(body->IsActive());
}

-(id)isFixedRotation:(id)args
{
    return NUMBOOL(body->IsFixedRotation());
}

-(void)setAwake:(id)args
{
    ENSURE_SINGLE_ARG(args,NSNumber);
    
    bool x = [TiUtils boolValue:args];
    body->SetAwake(x);
}

-(void)setBullet:(id)args
{
    ENSURE_SINGLE_ARG(args,NSNumber);
    
    bool x = [TiUtils boolValue:args];
    body->SetBullet(x);
}

-(void)setFixedRotation:(id)args
{
    ENSURE_SINGLE_ARG(args,NSNumber);
    
    bool x = [TiUtils boolValue:args];
    body->SetFixedRotation(x);
}

-(void)setLinearVelocity:(id)args
{
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

-(void)resetMassData:(id)args
{
    body->ResetMassData();
}

@end
