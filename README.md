# BFMicrophonePermissionManager

Microphone permission request + "Go to Settings" guide alert helper.

- Swift implementation
- Objective-C callable
- Guide alert localization: English + zh-Hans

## Requirements

- iOS 13.0+

## Host App (Info.plist)

You must provide the usage description in your host app:

- `NSMicrophoneUsageDescription`

This Pod does not (and should not) ship Info.plist permission strings.

## Installation (local path)

```ruby
pod 'BFMicrophonePermissionManager', :path => '/Users/bigger/Desktop/Pod/BFMicrophonePermissionManager'
```

## Usage

### Objective-C

```objc
@import BFMicrophonePermissionManager;

[BFMicrophonePermissionManager requestAuthorizationFromViewController:self completion:^(BOOL authorized) {
    // ...
}];
```

### Swift

```swift
import BFMicrophonePermissionManager

BFMicrophonePermissionManager.requestAuthorization(fromViewController: self) { authorized in
    // ...
}
```

## Behavior

- Status `.undetermined`: shows only the system prompt; if user denies, it does NOT show the guide alert in the same request.
- Later calls when status is `.denied`: shows the guide alert.

## Guide Alert Customization

You can provide a custom title/message:

- `showPermissionGuideAlertFromViewController:title:message:completion:`

If title/message are nil, the Pod uses its built-in localized strings.
