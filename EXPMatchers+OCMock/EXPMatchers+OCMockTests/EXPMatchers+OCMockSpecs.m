@interface ORObject : NSObject
@end

@implementation ORObject
- (void)method {};
- (NSNumber *)method2 {
    return @2;
};
- (void)method3:(NSString *)argument {};
@end

SpecBegin(ExpectaOCMockMatchers)

__block ORObject *sut;

before(^{
    sut = [[ORObject alloc] init];
});

it(@"checks for a method", ^{
    @mockify(sut);

    expect(sut).to.receive(@selector(method));
    [sut method];
});


// This is difficult, I have no idea how to force the dealloc. Maybe this has to be not ARC :/
//    it(@"checks for a method not being called", ^{
//        @mockify(sut);
//        EXPExpect *expect = expect(sut).to.receive(@selector(method2));
//        SEL dealloc = NSSelectorFromString(@"dealloc"));
//        assertFail([expect performSelector:dealloc]; , @"fails correctly");
//    });


it(@"checks for a return value", ^{
    @mockify(sut);
    expect(sut).receive(@selector(method2)).returning(@2);
    [sut method2];
});


//it(@"fails with the wrong return value", ^{
//    @mockify(sut);
//    expect(sut).receive(@selector(method2)).returning(@3);
//    [sut method2];
//});


it(@"checks for an argument to the method", ^{
    @mockify(sut);
    expect(sut).receive(@selector(method3:)).with(@[@"thing"]);
    [sut method3:@"thing"];
});

//it(@"fails with the wrong argument value", ^{
//    @mockify(sut);
//    expect(sut).receive(@selector(method3:)).with(@[@"thingy"]);
//    [sut method3:@"thing"];
//});

SpecEnd
