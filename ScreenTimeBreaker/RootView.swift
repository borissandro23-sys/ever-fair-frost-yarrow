import SwiftUI

struct RootView: View {
    @StateObject private var model = DiagnosticsViewModel()

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Device")) {
                    InfoRow(title: "Model", value: model.deviceModel)
                    InfoRow(title: "System version", value: model.systemVersion)
                    InfoRow(title: "Architecture", value: model.architecture)
                }

                Section(header: Text("Jailbreak environment")) {
                    InfoRow(title: "Configured target", value: "Dopamine / Rootless")
                    InfoRow(title: "Rootful mode", value: "Separate environment required")
                    Text("This screen reports configuration only. It does not change jailbreak state or system protections.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Section(header: Text("Screen Time frameworks")) {
                    InfoRow(title: "FamilyControls", value: model.familyControlsStatus)
                    InfoRow(title: "DeviceActivity", value: "Public framework")
                    InfoRow(title: "ManagedSettings", value: "Public framework")
                    Text("Actual API use requires the appropriate Apple entitlement and user authorization.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Section {
                    Button("Refresh diagnostics") {
                        model.refresh()
                    }
                }
            }
            .navigationTitle("Screen Time Breaker")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
            Spacer(minLength: 12)
            Text(value)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}
