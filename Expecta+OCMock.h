#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

@interface EXPExpect (receiveMatcher)

/// Expect an object to recieve a selector
@property (nonatomic, readonly) EXPExpect *(^ receive) (SEL);

/// Expectations around the arguments recieved
@property (nonatomic, readonly) EXPExpect *(^ with) (NSArray *);

/// Expectations around the arguments recieved
@property (nonatomic, readonly) EXPExpect *(^ returning) (id);

@end;

// This is the @mockify, I used the same technique as libextobjc by using a @try{} @catch with no
// @ to absorb the initial @.

// Limitiations: This technique means you can only write one @mockify per it block. This is because
// I couldn't find a way to make a new var name based on the input name, thus: strongOriginalReference

#define mockify(...) \
try {} @finally {} \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
id strongOriginalReference = __VA_ARGS__; \
__VA_ARGS__ = [OCMockObject partialMockForObject:strongOriginalReference];\
_Pragma("clang diagnostic pop")
