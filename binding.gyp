{
  "targets": [
    {
      "target_name": "mac-active-url",
      "include_dirs": [ "<!(node -e \"require('nan')\")" ],
      "conditions": [
        ['OS=="mac"', {
          "sources": [
            "src/ActiveURL.mm",
          ],
          "link_settings": {
            "libraries": [
              "-framework", "AppKit"
            ]
          }
        }],
        ['OS=="linux" or OS=="win"', {
          "sources": [
            "src/ActiveURL.cc",
          ],
        }],
      ]
    }
  ]
}
