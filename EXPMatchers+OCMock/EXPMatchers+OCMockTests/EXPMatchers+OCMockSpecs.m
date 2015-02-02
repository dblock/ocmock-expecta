//
//  OCMockDemoSpecs.m
//  OCMockDemo
//
//  Created by Daniel Doubrovkine on 1/14/14.
//  Copyright (c) 2014 Artsy Inc. All rights reserved.
//

@interface ORObject : NSObject
@end

@implementation ORObject
- (void)method {};
- (NSNumber *)method2 {
    return @2;
};
- (void)method3:(NSString *)argument {};
@end



SpecBegin(EXPMatchers)

__block ORObject *sut;

before(^{
    sut = [[ORObject alloc] init];
});

//describe(@"with inline bldsadsocks", ^{
//    it(@"asdas", ^{
//        expect(sut).to.equal([NSObject new]);
//    });
//});
//
describe(@"with inline blocks", ^{

//    it(@"expect to receive an instance method with a block", ^{
//        expect(sut).to.receiveIn(@selector(method), ^{
//            [sut method];
//        });
//    });
//
//
//    it(@"can deal with not to recieving an instance method", ^{
//        expect(sut).toNot.receiveIn(@selector(method), ^{
//            [sut method2];
//        });
//    });
//
//    it(@"can run two in a row on the same object", ^{
//        expect(sut).to.receiveIn(@selector(method), ^{
//            [sut method];
//        });
//
//        expect(sut).to.receiveIn(@selector(method2), ^{
//            [sut method2];
//        });
//    });

});

describe(@"with no block", ^{
    it(@"checks for a method", ^{
                NSLog(@"BEFORE");
        expect(sut).to.receive(@selector(method));

        id mockVC = [OCMockObject partialMockForObject:sut];
        [[mockVC expect] method];
        [mockVC verify];

        NSLog(@"AFTER");
//        [sut method];
                NSLog(@"AFTER ALLL");
    });

//    it(@"checks for a method not being called", ^{
        expect(sut).to.receive(@selector(method));
        [sut method2];
//    });
//
//    it(@"checks for a return value", ^{
//        expect(sut).receive(@selector(method2)).returning(@2);
//        [sut method2];
//    });
//
//    it(@"checks for an argument to the method", ^{
//        expect(sut).receive(@selector(method3:)).with(@[@"thing"]);
//        [sut method3:@"thing"];
//    });
});

SpecEnd

