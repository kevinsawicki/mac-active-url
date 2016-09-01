{
  "targets": [
    {
      "target_name": "mac-active-url",
      "include_dirs": [ "<!(node -e \"require('nan')\")" ],
      "conditions": [
        ['OS=="mac"', {
          "sources": [
            "ActiveURL.mm",
          ],
          "link_settings": {
            "libraries": [
              "-framework", "AppKit"
            ]
          }
        }],
      ]
    }
  ]
}
