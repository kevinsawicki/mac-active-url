# mac-active-url

Get the URL of the document represented in the focused window.

```js
var getActiveUrl = require('mac-active-url').getActiveUrl
console.log('Active URL', getActiveUrl())
```

Test it out:

```js
var getActiveUrl = require('mac-active-url').getActiveUrl
setInterval(function () {
  console.log('Active URL', getActiveUrl())
}, 1000)
// Set this running then focus some windows such as the Preview app
```
