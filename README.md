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

- Status `.undetermined`: shows only the system prompt.
- If user denies in the system prompt: it does NOT show the guide alert immediately.
- The first later call when status is `.denied` is suppressed once (still no guide); subsequent denied calls show the guide alert.

## Guide Alert Customization

You can provide a custom title/message:

- `showPermissionGuideAlertFromViewController:title:message:completion:`

If title/message are nil, the Pod uses its built-in localized strings.
