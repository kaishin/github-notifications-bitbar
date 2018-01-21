# GitHub Notifications for BitBar

A plugin for [BitBar](https://getbitbar.com) (free) to display all your GitHub notifications in the menu bar.

![Screenshot](screenshot.png "Screenshot")

## Prerequisites

- BitBar (free). Download [here](https://github.com/matryer/bitbar/releases/latest).
- Latest version of [Xcode](https://developer.apple.com/xcode/) (free) with Swift 4 support.
- Personal GitHub API key. Follow [this guide](https://github.com/blog/1509-personal-api-tokens) to generate one.

# Install

* _Option 1_: Drop the `github-notifications.1m.swift` file in your BitBar plugin directly.
* _Option 2_: Copy, paste, then open the following URL in your browser: `bitbar://openPlugin?title=Github%20Notifications&src=https://raw.githubusercontent.com/kaishin/github-notifications-bitbar/master/github-notifications.1min.swift`

## Settings

Once you have an API key, open the script installed in your plugin directory and set it in the `GitHubAPIKey` variable.

You can also choose to display a badge by setting `displayCount` to `true`.

```swift
let GitHubAPIKey = "" // Set it to use your own GitHub API token key.
var displayCount = false // Show the notification badge in the menu bar.
```

If you want to change the update frequency, you can change the `1m` in the filename to your preferred duration (10s, 5m, 1h, etc).
