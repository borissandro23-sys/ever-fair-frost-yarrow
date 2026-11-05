# Screen Time Breaker — Dual Edition (Diagnostic)

A read-only iOS diagnostic app for learning about public Screen Time frameworks and recording the app's own lifecycle events.

## Target / development notes
- Primary test target: iPhone 6s (Apple A9, arm64), iOS 15.x
- Jailbreak profile: Dopamine / rootless
- UI: SwiftUI
- Deployment target: iOS 15.0
- Rootful is a separate compatibility profile, not a mode inside Dopamine.

## Current features
- Device model, hardware identifier, iOS version, and app version.
- Manually selectable Rootless / Rootful diagnostic profile.
- Compile-time availability checks for FamilyControls, DeviceActivity, and ManagedSettings.
- Read-only display of FamilyControls authorization status when the framework is available.
- Timestamped notifications for this app's own foreground/background lifecycle.
- Manual refresh.

## Important limitations
- A third-party app's lifecycle notifications do not reveal SpringBoard's internal startup sequence.
- Framework presence in the SDK does not prove that the app has Apple's required entitlement or authorization.
- The app does not disable Screen Time, bypass parental controls, modify protected system data, or interfere with system services.
- The profile picker is informational; it does not detect or change the installed jailbreak.
- Changing MinimumOSVersion does not change the actual iOS version or create compatibility with unavailable APIs.

## Build in Xcode
1. On a Mac, create an iOS App project named ScreenTimeBreaker using SwiftUI.
2. Set the deployment target to iOS 15.0.
3. Add the three Swift files in the ScreenTimeBreaker folder.
4. Use a development team and bundle identifier appropriate for your signing setup.
5. For future supported FamilyControls functionality, configure Apple's required capability/entitlement and use Apple's authorization flow. This diagnostic app does not request authorization.

## Files
- ScreenTimeBreaker/ScreenTimeBreakerApp.swift — app entry point
- ScreenTimeBreaker/RootView.swift — diagnostic UI
- ScreenTimeBreaker/DiagnosticsViewModel.swift — read-only diagnostics and app lifecycle log
