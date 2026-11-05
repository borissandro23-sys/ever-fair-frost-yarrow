# Screen Time Breaker — Dual Edition (Research)

Read-only research dashboard for public Screen Time frameworks on iOS 15+.

## Target device
- iPhone 6s (Apple A9, arm64)
- iOS 15.x
- Dopamine jailbreak: rootless environment
- SwiftUI, deployment target iOS 15.0

## Important architecture note
Dopamine is a rootless jailbreak. Rootful is not a mode that can be enabled inside Dopamine; it would require a different jailbreak/environment. This repository keeps the rootless target explicit and treats any future rootful build as a separate diagnostics target.

## Scope
This app reports device information and the availability/status exposed by public Apple APIs. It does not disable Screen Time, bypass parental controls, alter system daemons, or modify protected system data.

## Build
1. Open Xcode on a Mac.
2. Create an iOS App project named `ScreenTimeBreaker` using SwiftUI.
3. Set the deployment target to iOS 15.0.
4. Add the Swift files from `ScreenTimeBreaker/`.
5. If using FamilyControls APIs, configure the required Apple capability/entitlement and request authorization through Apple's supported flow.

A framework being present in the SDK does not guarantee the app has the required entitlement or authorization.
