Expecta-OCMock
==============

[Expecta](https://github.com/specta/expecta) matchers for [OCMock 2.x](https://github.com/erikdoe/ocmock).

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
pod "Expecta-OCMock", "~> 1"
```

### Limitations

Running this on a 64 bit simulator will fail, it seems to be that the `expect` isn't being help on to by something else
and so the dealloc call happens at the end of the declartion instead of at the end of the block's scope. [#4](https://github.com/dblock/ocmock-expecta/issues/4)

### License

MIT, see [LICENSE](LICENSE.md)
