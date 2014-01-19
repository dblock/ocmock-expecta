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

EXPMatcherImplementationBegin(receive, (SEL selector, EmptyBlock block)){
    __block NSException * _exception;
    match(^BOOL{
        id mock = [OCMockObject partialMockForObject:actual];
        [[mock expect] performSelector:selector];
        block();
        @try {
            [mock verify];
            return YES;
        }
        @catch (NSException *exception) {
            _exception = exception;
            return NO;
        }
        @finally {
            [mock stopMocking];
        }
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected %@ to receive %@: %@", actual, NSStringFromSelector(selector), _exception];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected %@ not to receive %@: %@", actual, NSStringFromSelector(selector), _exception];
    });
}
EXPMatcherImplementationEnd

