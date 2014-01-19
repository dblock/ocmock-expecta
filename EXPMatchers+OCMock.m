//
//  EXPMatchers+OCMockTest.h
//  Artsy
//
//  Created by Daniel Doubrovkine on 1/14/14.
//  Copyright (c) 2014 Artsy Inc. All rights reserved.
//

#import "EXPMatchers+OCMock.h"
#import "EXPMatcherHelpers.h"
#import <OCMock/OCMock.h>

EXPMatcherImplementationBegin(receive, (SEL selector)){
    match(^BOOL{
        // TODO tell OCMockObject to expect the method name
        [[[OCMockObject partialMockForObject:actual] expect] ???];
        return YES;
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected %@ to receive %@", actual, NSStringFromSelector(selector)];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected %@ not to receive %@", actual, NSStringFromSelector(selector)];
    });
}
EXPMatcherImplementationEnd

