//
//  EXPMatchers+OCMockTest.h
//  Artsy
//
//  Created by Daniel Doubrovkine on 1/14/14.
//  Copyright (c) 2014 Artsy Inc. All rights reserved.
//

#import "Expecta.h"

typedef void (^ EmptyBlock)(void);

EXPMatcherInterface(receive, (SEL selector, EmptyBlock block));
