# Swift Trending for BitBar

A plugin for [BitBar](https://getbitbar.com) (free) to list Swift repositories tending on GitHub in a given period.

![Screenshot](screenshot.png "Screenshot")

## Install

BitBar needs to be installed. Download [here](https://github.com/matryer/bitbar/releases/latest).

Then you can either:

* _Option 1_: Drop the `swift-trending.15m.swift` file in your BitBar plugin directly.
* _Option 2_: Open this lins link in your browser: `bitbar://openPlugin?title=Swift%20Trending&src=https://raw.githubusercontent.com/kaishin/bitbar-plugins/master/Dev/GitHub/swift-trending.15m.swift`

## Settings

You can change the following settings directly in the script file:

```swift
var displayCount = 15 // Min: 10, Max: 25
var maxSubtitleLineLength = 70
var trendingPeriod = "daily" // Possible values: "daily", "weekly", "monthly"
```

If you want to change the update frequency, you can change the `15m` in the filename to your preferred duration.
