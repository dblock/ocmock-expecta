#import "Expecta+OCMock.h"
#import "EXPMatcherHelpers.h"
#import <OCMock/OCMock.h>
#import <OCMock/OCPartialMockObject.h>
#import <OCMock/OCMExpectationRecorder.h>
#import <OCMock/OCMStubRecorder.h>
#import <OCMock/OCMInvocationStub.h>

#import <objc/runtime.h>
#import <XCTest/XCTest.h>

@interface OCMExpectationRecorder (Private)
- (OCMInvocationStub *)stub;
@end

@interface ORExpectaOCMockMatcher : NSObject <EXPMatcher>
- (instancetype)initWithExpectation:(EXPExpect *)expectation;
@end

@interface ORExpectaOCMockMatcher()
@property (nonatomic, weak) EXPExpect *expectation;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy) NSArray *arguments;
@property (nonatomic, strong) id returning;

@property (nonatomic, strong) OCMExpectationRecorder *selectorCheckRecorder;
@property (nonatomic, strong) OCPartialMockObject *mock;
@end

@implementation ORExpectaOCMockMatcher

- (instancetype)initWithExpectation:(EXPExpect *)expectation
{
    self = [super init];
    if (!self) { return nil; }

    _expectation = expectation;

    _mock = expectation.actual;
    _selectorCheckRecorder = [_mock expect];

    [self.selectorCheckRecorder andForwardToRealObject];

    return self;
}

- (void)updateMatcher
{
    [(NSMutableArray *)self.selectorCheckRecorder.stub.invocationActions removeAllObjects];
    
    // Yeah, I'm doing it. I know what it is under the hood.

    NSInvocation *invocation = [self representedInvocation];
    [invocation invoke];
}

- (NSInvocation *)representedInvocation
{
    NSMethodSignature * mySignature = [self.mock.realObject.class instanceMethodSignatureForSelector:self.selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:mySignature];

    invocation.selector = self.selector;
    invocation.target = self.selectorCheckRecorder;

    for (__unsafe_unretained id object in self.arguments) {
        [invocation setArgument:&object atIndex:[self.arguments indexOfObject:object] +2];
    }

    return invocation;
}

- (BOOL)matches:(id)actual
{
    return YES;
}

- (void)dealloc
{
    id mock = self.mock;
    NSException *theException = nil;

    @try {
        [mock verify];
    }
    @catch (NSException *exception) {
        theException = exception;
    }

    if (_returning) {
        CFTypeRef cfResult;

        NSInvocation *invocation = [self representedInvocation];
        [invocation setTarget:self.mock.realObject];
        [invocation invoke];
        [invocation getReturnValue:&cfResult];
        if (cfResult)
            CFRetain(cfResult);

        id result = (__bridge_transfer id)cfResult;
        if (![result isEqual:self.returning]) {
            _XCTFailureHandler(self.expectation.testCase, YES, self.expectation.fileName , self.expectation.lineNumber, FALSE, @"Expected a match");
        }

    }

    if (theException) {
        EXPFail(self.expectation.testCase, self.expectation.lineNumber, self.expectation.fileName, @"Fail");
        [theException raise];
    }

    [mock stopMocking];
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

    ORExpectaOCMockMatcher *matcher = [[ORExpectaOCMockMatcher alloc] initWithExpectation:self];
    objc_setAssociatedObject(self, @selector(_expectaOCMatcher), matcher, OBJC_ASSOCIATION_RETAIN);

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