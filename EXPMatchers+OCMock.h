//
//  EXPMatchers+OCMockTest.h
//  Artsy
//
//  Created by Daniel Doubrovkine on 1/14/14.
//  Copyright (c) 2014 Artsy Inc. All rights reserved.
//

#import "Expecta.h"

typedef void (^ EmptyBlock)(void);

EXPMatcherInterface(receiveIn, (SEL selector, EmptyBlock block));

@interface ORExpectaOCMockMatcher : NSObject <EXPMatcher>

- (instancetype)initWithExpectation:(EXPExpect *)expectation object:(id)object;

@end


@interface EXPExpect (receiveMatcher)

/// Expect an object to recieve a selector
@property (nonatomic, readonly) EXPExpect *(^ receive) (SEL);

/// Expectations around the arguments recieved
@property (nonatomic, readonly) EXPExpect *(^ with) (NSArray *);

/// Expectations around the arguments recieved
@property (nonatomic, readonly) EXPExpect *(^ returning) (id);

@end;
//