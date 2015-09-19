#import <Foundation/Foundation.h>

#import <main.h>

// This C function is called from Go
static int Callback() {
  return 42;
}

static NSString* _NSStringFromGoString(GoString string) {
  return [[NSString alloc] initWithBytes:string.p length:string.n encoding:NSUTF8StringEncoding];
}

// The returned GoString will be valid for the duration of the current autorelease pool
static GoString _GoStringFromNSString(NSString* string) {
  NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
  GoString result = {(char*)data.bytes, data.length};
  return result;
}

int main(int argc, const char* argv[]) {
  @autoreleasepool {
    GoString param = _GoStringFromNSString(@"Result");
    GoString result = Bridge(param, Callback);
    NSLog(@"%@", _NSStringFromGoString(result));
  }
  return 0;
}
