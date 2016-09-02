# mac-active-url

## getActiveURL(callback)

Get the URL of the document represented in the focused window of the active
application.


```js
var getActiveURL = require('mac-active-url').getActiveURL
getActiveURL(function (error, activeURL) {
  console.log('Active URL', activeURL)
})
```

## prompt()

Prompt for access to the accessibility APIs if the process is not already
trusted. This will show a pop-up confirm dialog if the process is not trusted:

```js
var alreadyTrusted = require('mac-active-url').prompt()
console.log('Previously trusted?', alreadyTrusted)
```
