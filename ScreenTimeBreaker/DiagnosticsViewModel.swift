import Foundation
import UIKit
import Combine
import Darwin

#if canImport(FamilyControls)
import FamilyControls
#endif

#if canImport(DeviceActivity)
import DeviceActivity
#endif

#if canImport(ManagedSettings)
import ManagedSettings
#endif

final class DiagnosticsViewModel: ObservableObject {
    @Published private(set) var deviceModel = UIDevice.current.model
    @Published private(set) var hardwareIdentifier = "Unknown"
    @Published private(set) var systemVersion = UIDevice.current.systemVersion
    @Published private(set) var appVersion = "Unknown"
    @Published private(set) var familyControlsStatus = "Not checked"
    @Published private(set) var deviceActivityStatus = "Not checked"
    @Published private(set) var managedSettingsStatus = "Not checked"
    @Published private(set) var lifecycleEvents: [String] = []
    private var observers: [NSObjectProtocol] = []

    init() { registerLifecycleObservers(); refresh(); record("Diagnostics session started") }
    deinit { observers.forEach(NotificationCenter.default.removeObserver) }

    func refresh() {
        deviceModel = UIDevice.current.model
        systemVersion = UIDevice.current.systemVersion
        hardwareIdentifier = Self.machineIdentifier()
        appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        #if canImport(FamilyControls)
        if #available(iOS 15.0, *) {
            familyControlsStatus = "Available; authorization: \(String(describing: AuthorizationCenter.shared.authorizationStatus))"
        } else { familyControlsStatus = "Requires iOS 15.0 or later" }
        #else
        familyControlsStatus = "Unavailable in this SDK"
        #endif
        #if canImport(DeviceActivity)
        deviceActivityStatus = "Framework linked"
        #else
        deviceActivityStatus = "Unavailable in this SDK"
        #endif
        #if canImport(ManagedSettings)
        managedSettingsStatus = "Framework linked"
        #else
        managedSettingsStatus = "Unavailable in this SDK"
        #endif
        record("Diagnostics refreshed")
    }

    private func registerLifecycleObservers() {
        let events: [(Notification.Name, String)] = [
            (UIApplication.willEnterForegroundNotification, "App will enter foreground"),
            (UIApplication.didBecomeActiveNotification, "App became active"),
            (UIApplication.willResignActiveNotification, "App will resign active"),
            (UIApplication.didEnterBackgroundNotification, "App entered background")
        ]
        for (name, label) in events {
            let observer = NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in self?.record(label) }
            observers.append(observer)
        }
    }

    private func record(_ message: String) {
        let formatter = DateFormatter(); formatter.dateStyle = .none; formatter.timeStyle = .medium
        lifecycleEvents.insert("[\(formatter.string(from: Date()))] \(message)", at: 0)
        lifecycleEvents = Array(lifecycleEvents.prefix(30))
    }

    private static func machineIdentifier() -> String {
        var size = 0
        guard sysctlbyname("hw.machine", nil, &size, nil, 0) == 0, size > 0 else { return "Unavailable" }
        var machine = [CChar](repeating: 0, count: size)
        let result = machine.withUnsafeMutableBufferPointer { buffer in sysctlbyname("hw.machine", buffer.baseAddress, &size, nil, 0) }
        guard result == 0 else { return "Unavailable" }
        return String(cString: machine)
    }
}
