Expecta-OCMock
==============

[Expecta](https://github.com/specta/expecta) matchers for [OCMock 3.x](https://github.com/erikdoe/ocmock).

## Examples

```objc
// First check that a method is called
// Note: it will still call said method in the test. It's not stubbed.
// These never stub.

it(@"checks for a method", ^{
    @mockify(sut);

    expect(sut).to.receive(@selector(method));
    [sut method];
});

// Checks that a method has been called.
// Then calls it again at the end of the test to check it's return value.
// be wary if you have side-effects with this.

it(@"checks for a return value", ^{
    @mockify(sut);
    
    expect(sut).receive(@selector(method2)).returning(@2);
    [sut method2];
});

// Checks that something has been called and that it has the expected arguments

it(@"checks for an argument to the method", ^{
    @mockify(sut);
    
    expect(sut).receive(@selector(method3:)).with(@[@"thing"]);
    [sut method3:@"thing"];
});
```

### Get it

```
pod "Expecta-OCMock", "~> 2"
```

For OCMock 2 support, 

```
pod "Expecta-OCMock", "~> 1"
```

### License

MIT, see [LICENSE](LICENSE.md)
