import SwiftUI

struct RootView: View {
    @StateObject private var model = DiagnosticsViewModel()
    @State private var selectedProfile = "Rootless"
    var body: some View {
        NavigationView { List {
            Section(header: Text("Edition profile")) {
                Picker("Profile", selection: $selectedProfile) { Text("Rootless").tag("Rootless"); Text("Rootful").tag("Rootful") }
                    .pickerStyle(SegmentedPickerStyle())
                Text(selectedProfile == "Rootless" ? "Rootless is the intended profile for Dopamine. This selection is informational and does not detect or change the jailbreak." : "Rootful is a separate jailbreak environment, not a mode inside Dopamine. This selection only changes the diagnostic profile.")
                    .font(.footnote).foregroundColor(.secondary)
            }
            Section(header: Text("Device")) {
                InfoRow(title: "Device", value: model.deviceModel)
                InfoRow(title: "Hardware identifier", value: model.hardwareIdentifier)
                InfoRow(title: "iOS version", value: model.systemVersion)
                InfoRow(title: "App version", value: model.appVersion)
            }
            Section(header: Text("Screen Time frameworks")) {
                InfoRow(title: "FamilyControls", value: model.familyControlsStatus)
                InfoRow(title: "DeviceActivity", value: model.deviceActivityStatus)
                InfoRow(title: "ManagedSettings", value: model.managedSettingsStatus)
                Text("Framework availability does not prove that the app has the required entitlement or user authorization. This app does not request authorization automatically.").font(.footnote).foregroundColor(.secondary)
            }
            Section(header: Text("App lifecycle log")) {
                Text("These entries describe this app's own foreground/background events. A normal third-party app cannot use these notifications to monitor SpringBoard's internal startup sequence.").font(.footnote).foregroundColor(.secondary)
                if model.lifecycleEvents.isEmpty { Text("No events recorded yet.").foregroundColor(.secondary) }
                else { ForEach(Array(model.lifecycleEvents.enumerated()), id: \.offset) { _, event in Text(event).font(.system(.caption, design: .monospaced)).textSelection(.enabled) } }
            }
            Section { Button(action: model.refresh) { Label("Refresh diagnostics", systemImage: "arrow.clockwise") } }
        }.navigationTitle("Screen Time Breaker") }.navigationViewStyle(StackNavigationViewStyle())
    }
}

private struct InfoRow: View {
    let title: String; let value: String
    var body: some View { HStack(alignment: .firstTextBaseline) { Text(title); Spacer(minLength: 12); Text(value).foregroundColor(.secondary).multilineTextAlignment(.trailing) } }
}
