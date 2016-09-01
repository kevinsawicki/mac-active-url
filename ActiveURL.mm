#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>
#import <nan.h>
#import <string>

class ActiveURLWorker : public Nan::AsyncWorker {
 public:
  ActiveURLWorker(Nan::Callback *callback)
    : AsyncWorker(callback),
      url() {
  }

  ~ActiveURLWorker() {
  }

  bool GetAttributeValue(AXUIElementRef* element, CFStringRef attribute, void* value) {
    AXError error = AXUIElementCopyAttributeValue(*element, attribute, (CFTypeRef *) value);
    return error == kAXErrorSuccess;
  }

  pid_t GetPid() {
    NSDictionary* app = [[NSWorkspace sharedWorkspace] activeApplication];
    return (pid_t) [[app objectForKey:@"NSApplicationProcessIdentifier"] longValue];
  }

  void Execute() {
    AXUIElementRef activeApp = AXUIElementCreateApplication(GetPid());
    AXUIElementRef focusedWindow = nil;
    NSString* documentPath = nil;

    if (GetAttributeValue(&activeApp, kAXFocusedWindowAttribute, &focusedWindow)) {
      if (GetAttributeValue(&focusedWindow, kAXDocumentAttribute, &documentPath)) {
        url = [documentPath UTF8String];
        [documentPath autorelease];
      }
      CFRelease(focusedWindow);
    }

    CFRelease(activeApp);
  }

  void HandleOKCallback () {
    Nan::HandleScope scope;
    v8::Local<v8::Value> argv[] = {
      Nan::Null(),
      Nan::New<v8::String>(url).ToLocalChecked()
    };
    callback->Call(2, argv);
  }

 private:
  std::string url;
};

NAN_METHOD(GetActiveURL) {
  Nan::Callback *callback = new Nan::Callback(info[0].As<v8::Function>());
  Nan::AsyncQueueWorker(new ActiveURLWorker(callback));
}

NAN_METHOD(Prompt) {
  NSDictionary* options = @{(id)kAXTrustedCheckOptionPrompt: @YES};
  bool trusted = AXIsProcessTrustedWithOptions((CFDictionaryRef) options);
  info.GetReturnValue().Set(Nan::New(trusted));
}


void Init(v8::Local<v8::Object> exports) {
  exports->Set(Nan::New("getActiveURL").ToLocalChecked(),
               Nan::New<v8::FunctionTemplate>(GetActiveURL)->GetFunction());
  exports->Set(Nan::New("prompt").ToLocalChecked(),
               Nan::New<v8::FunctionTemplate>(Prompt)->GetFunction());
}

NODE_MODULE(mac_active_url, Init)
