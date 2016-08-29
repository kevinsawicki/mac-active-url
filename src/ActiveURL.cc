void GetActiveURL(const Nan::FunctionCallbackInfo<v8::Value>& info) {
  // Unimplemented
}

void Init(v8::Local<v8::Object> exports) {
  exports->Set(Nan::New("getActiveURL").ToLocalChecked(),
               Nan::New<v8::FunctionTemplate>(GetActiveURL)->GetFunction());
}

NODE_MODULE(active_url, Init)
