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
#import <objc/runtime.h>

/// With a Block argument

EXPMatcherImplementationBegin(receiveIn, (SEL selector, EmptyBlock block)){
    __block NSException * _exception;

    match(^BOOL{
        id mock = [OCMockObject partialMockForObject:actual];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[mock expect] performSelector:selector];
#pragma clang diagnostic pop

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

@interface ORExpectaOCMockMatcher()
@property (nonatomic, strong) EXPExpect *expectation;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy) NSArray *arguments;
@property (nonatomic, strong) id returning;

@property (nonatomic, strong) OCMockRecorder *selectorCheckRecorder;
@property (nonatomic, strong) OCMockObject *mock;

@end

@implementation ORExpectaOCMockMatcher

- (instancetype)initWithExpectation:(EXPExpect *)expectation object:(id)object
{
    self = [super init];
    if (!self) { return nil; }

    _expectation = expectation;

    _mock = [OCMockObject partialMockForObject:expectation.actual];
    _selectorCheckRecorder = [_mock expect];

    return self;
}

- (void)updateMatcher
{
    // Yeah, I'm doing it. I know what it is under the hood.
    [(NSMutableArray *)self.selectorCheckRecorder.invocationHandlers removeAllObjects];

    NSMethodSignature *sig = [self.selectorCheckRecorder methodSignatureForSelector:self.selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation retainArguments];

    for (__unsafe_unretained id object in self.arguments) {
        [invocation setArgument:&object atIndex:[self.arguments indexOfObject:object] +2];
    }

    if (self.returning) {
        [self.selectorCheckRecorder andReturn:self.returning];
    }

    [invocation invoke];

}

- (BOOL)matches:(id)actual
{
    return YES;
}

- (void)dealloc
{
    id mock = self.mock;
    id theException = nil;

    @try {
        [mock verify];
    }
    @catch (NSException *exception) {
        theException = exception;
        NSLog(@"------------------------------------------------------------------");
    }
    @finally {
        [mock stopMocking];
    }

    if (theException) {
        EXPFail(self.expectation.testCase, self.expectation.lineNumber, self.expectation.fileName, @"Fail");
        NSAssert(NO, @"Failed");
    }
}

@end

/// For passing data between recieve and with

@interface EXPExpect (receiveMatcherPrivate)
@property (nonatomic, strong) id _expectaOCMatcher;
@end

@implementation EXPExpect (receiveMatcherPrivate)
@dynamic _expectaOCMatcher;
@end

@implementation EXPExpect (receiveMatcher)

@dynamic receive;

- (EXPExpect *(^) (SEL)) receive {
    __block id actual = self.actual;

    ORExpectaOCMockMatcher *matcher = [[ORExpectaOCMockMatcher alloc] initWithExpectation:self object:actual];
    objc_setAssociatedObject(self, @selector(_expectaOCMatcher), matcher, OBJC_ASSOCIATION_ASSIGN);

    // This means we don't dealloc correctly, but it is normally set
    // [[[NSThread currentThread] threadDictionary] setObject:matcher forKey:@"EXP_currentMatcher"];

    EXPExpect *(^matcherBlock) (SEL selector) = [^ (SEL selector) {
        matcher.selector = selector;

        [matcher updateMatcher];
        actual = matcher.mock;
        [self applyMatcher:matcher to:&actual];



        return self;

    } copy];

    return  matcherBlock;
}

@dynamic with;

- (EXPExpect *(^) (NSArray *)) with {

    EXPExpect *(^matcherBlock) (id object) = [^ (id object) {

        ORExpectaOCMockMatcher *matcher = objc_getAssociatedObject(self, @selector(_expectaOCMatcher));
        matcher.arguments = object;
        [matcher updateMatcher];

        return self;

    } copy];
    
    return  matcherBlock;
}

@dynamic returning;

- (EXPExpect *(^) (id)) returning {

    EXPExpect *(^matcherBlock) (id object) = [^ (id object) {

        ORExpectaOCMockMatcher *matcher = objc_getAssociatedObject(self, @selector(_expectaOCMatcher));
        matcher.returning = object;
        [matcher updateMatcher];

        return self;

    } copy];

    return  matcherBlock;
}


@end