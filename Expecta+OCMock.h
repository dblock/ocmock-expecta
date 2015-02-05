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

 // Concatenates A and B
#define mockify_concat(A, B) A ## B

// This is the @mockify, I used the same technique as libextobjc by using a @try{} @catch with no
// @ to absorb the initial @.

#define mockify(OBJ) \
        try {} @finally {} \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Wshadow\"") \
        \
        typeof(OBJ) mockify_concat(OBJ, _original_) = OBJ; \
        typeof(OBJ) OBJ = [OCMockObject partialMockForObject:mockify_concat(OBJ, _original_)]; \
        \
        _Pragma("clang diagnostic pop")
