
/// Note: 3 tests are _meant_ to fail.

@interface ORObject : NSObject
@end

@implementation ORObject
- (void)method {};
- (NSNumber *)method2 { return @2; };
- (void)method3:(NSString *)argument {};
- (NSInteger)method4 { return 23; };

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

it(@"checks for a return object", ^{
    @mockify(sut);
    expect(sut).receive(@selector(method2)).returning(@2);
    [sut method2];
});

it(@"checks for a return value bridged to an object", ^{
    @mockify(sut);
    expect(sut).receive(@selector(method4)).returning(@23);
    [sut method4];
});

it(@"checks for an argument to the method", ^{
    @mockify(sut);
    expect(sut).receive(@selector(method3:)).with(@[@"thing"]);
    [sut method3:@"thing"];
});

__block ORObject *a;
__block ORObject *b;

beforeEach(^{
    a = [[ORObject alloc] init];
    b = [[ORObject alloc] init];
});

it(@"supports multiple invocations of @mockify", ^{
    @mockify(a)
    @mockify(b)

    expect(a).receive(@selector(method3:)).with(@[@"a"]);
    expect(b).receive(@selector(method3:)).with(@[@"b"]);

    [a method3:@"a"];
    [b method3:@"b"];
});

/// It is expected that these tests will fail. That means they work properly

it(@"fails when method is not called", ^{
    @mockify(sut);
    expect(sut).receive(@selector(method2));
    [sut method];
});


it(@"fails with the wrong return value", ^{
    @mockify(sut);
    expect(sut).receive(@selector(method2)).returning(@3);
    [sut method2];
});

it(@"fails with the wrong argument value", ^{
    @mockify(sut);
    expect(sut).receive(@selector(method3:)).with(@[@"thingy"]);
    [sut method3:@"thing"];
});

SpecEnd
