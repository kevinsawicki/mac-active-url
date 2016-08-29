#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>
#import <nan.h>

bool GetAttributeValue(AXUIElementRef* element, CFStringRef attribute, void* value) {
  AXError error = AXUIElementCopyAttributeValue(*element, attribute, (CFTypeRef *) value);
  return error == kAXErrorSuccess;
}

bool IsAPIAvailable() {
  NSDictionary* options = @{(id)kAXTrustedCheckOptionPrompt: @YES};
  return AXIsProcessTrustedWithOptions((CFDictionaryRef) options);
}

pid_t GetPid() {
  NSDictionary* app = [[NSWorkspace sharedWorkspace] activeApplication];
  return (pid_t) [[app objectForKey:@"NSApplicationProcessIdentifier"] longValue];
}

void GetActiveURL(const Nan::FunctionCallbackInfo<v8::Value>& info) {
  if (!IsAPIAvailable()) return;

  AXUIElementRef activeApp = AXUIElementCreateApplication(GetPid());
  AXUIElementRef focusedWindow = nil;
  NSString* documentPath = nil;

  if (GetAttributeValue(&activeApp, kAXFocusedWindowAttribute, &focusedWindow)) {
    if (GetAttributeValue(&focusedWindow, kAXDocumentAttribute, &documentPath)) {
      info.GetReturnValue().Set(Nan::New([documentPath UTF8String]).ToLocalChecked());
      [documentPath autorelease];
    }
    CFRelease(focusedWindow);
  }

  CFRelease(activeApp);
}

void Init(v8::Local<v8::Object> exports) {
  exports->Set(Nan::New("getActiveURL").ToLocalChecked(),
               Nan::New<v8::FunctionTemplate>(GetActiveURL)->GetFunction());
}

NODE_MODULE(active_url, Init)
