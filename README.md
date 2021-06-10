# BlendVisionMoment iOS SDK

BlendVisionMoment SDK is a Swift library to help you integrate BlendVision Moment player into your iOS app.

## Trying the Sample App

To have a quick look at the features of BlendVisionMoment SDK, try our sample app by following the steps below

1. Clone or download this repository.
2. Open the `sample/BlendVisionMomentSample.xcodeproj` file in Xcode.
3. Build and run the `BlendVisionMomentSample` scheme.

## Using the SDK

### Minimum Requirements

- Xcode 12.0
- iOS 12.0
- Swift 5.0

### Installation

To use BlendVisionMoment SDK within your app, following the steps below

1. Copy _all_ framework files under the `frameworks` folder into your project folder (or another location defined in the framework search path).
2. Add relevant frameworks to the "Frameworks, Libraries, and Embedded Content" section of "General" tab in your app target.
    - BlendVisionMoment (Required)
    - KKSPaaS (Required)
    - KKSNetwork (Required)
    - KKSLocalization (Required)
    - SDWebImage (Required)
    - GoogleCast _(Optional)_

## Sample Code

You will need three lines of code to present a player with default configurations.

```swift
import BlendVisionMoment

let context = PlayerContext(barItems: [.settings])

Utils.presentPlayer(context, accessToken: "access_token")
```

### Configuration

BlendVisionMoment SDK provides APIs for flexible configurations. 

#### Player Context

```swift
// Create a player context with configuration and bar items
let context = PlayerContext(config: Configuration(defaultResolution: 720), 
                            barItems: [.settings])

// Update default resolution
// Player will prompt an alert if default resolution is not supported for the event
context.config.defaultResolution = 1080

// Update bar items
// Chromecast button will be hidden if GoogleCast is not supported
context.barItem = [.airplay, .chromecast, .settings]
```

#### Player Presentation

```swift
// Modally present player in the top most view controller in the view hierarchy
Utils.presentPlayer(context)

// Modally present player in a specified view controller
Utils.presentPlayer(context, in: viewController)

// Modally present player with an access token different from Configuration.accessToken
Utils.presentPlayer(context, accessToken: "access_token")
```

### Access Token

```swift
// Update access token at anytime
Configuration.updateAccessToken("access_token")
```

### Opt-in GoogleCast

To opt-in GoogleCast and support casting

1. Add GoogleCast framework into your app target
2. Set up GoogleCast receiver application ID in `AppDelegate`

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Opt-in GoogleCast
    Configuration.setupGoogleCast(applicationID: GOOGLE_CAST_APPLICATION_ID)

    return true
}
```
