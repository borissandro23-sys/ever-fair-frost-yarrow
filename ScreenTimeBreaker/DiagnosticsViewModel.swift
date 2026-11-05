import Foundation
import UIKit
import Combine

#if canImport(FamilyControls)
import FamilyControls
#endif

final class DiagnosticsViewModel: ObservableObject {
    @Published private(set) var deviceModel = UIDevice.current.model
    @Published private(set) var systemVersion = UIDevice.current.systemVersion
    @Published private(set) var architecture = "arm64"
    @Published private(set) var familyControlsStatus = "Not checked"

    func refresh() {
        deviceModel = UIDevice.current.model
        systemVersion = UIDevice.current.systemVersion

        #if canImport(FamilyControls)
        if #available(iOS 15.0, *) {
            familyControlsStatus = "Framework available; entitlement/authorization not verified"
        } else {
            familyControlsStatus = "Requires iOS 15.0 or later"
        }
        #else
        familyControlsStatus = "FamilyControls is not available in this SDK"
        #endif
    }
}
