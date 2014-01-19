//
//  OCMockDemoSpecs.m
//  OCMockDemo
//
//  Created by Daniel Doubrovkine on 1/14/14.
//  Copyright (c) 2014 Artsy Inc. All rights reserved.
//

SpecBegin(EXPMatchers)

it(@"expect to receive an instance method", ^{
    NSString *s = @"TESTING";
    expect(s).to.receive(@selector(lowercaseString));
    [s lowercaseString];
});

it(@"expect to not receive an instance method", ^{
    NSString *s = @"TESTING";
    expect(s).notTo.receive(@selector(lowercaseString));
});

SpecEnd

