import AVFoundation
import Foundation
import UIKit

@objcMembers
public final class BFMicrophonePermissionManager: NSObject {
    public static let shared = BFMicrophonePermissionManager()
    private static var suppressGuideAlertOnceAfterSystemDeny = false

    private override init() {
        super.init()
    }

    @objc(sharedManager)
    public class func sharedManager() -> BFMicrophonePermissionManager {
        BFMicrophonePermissionManager.shared
    }

    // MARK: - Status

    @objc
    public class func authorizationStatus() -> AVAudioSession.RecordPermission {
        AVAudioSession.sharedInstance().recordPermission
    }

    @objc
    public class func isAuthorized() -> Bool {
        authorizationStatus() == .granted
    }

    // MARK: - Request

    /// Behavior:
    /// - If status is .undetermined, only the system prompt is shown.
    /// - If user denies in the system prompt, the guide alert is NOT shown immediately.
    /// - The first later call with status .denied is suppressed once (no guide), then guide is shown on subsequent calls.
    @objc(requestAuthorizationFromViewController:completion:)
    public class func requestAuthorization(fromViewController viewController: UIViewController?,
                                          completion: @escaping (Bool) -> Void) {
        guard viewController != nil else {
            DispatchQueue.main.async { completion(false) }
            return
        }

        switch authorizationStatus() {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    suppressGuideAlertOnceAfterSystemDeny = !granted
                    completion(granted)
                }
            }

        case .granted:
            suppressGuideAlertOnceAfterSystemDeny = false
            DispatchQueue.main.async { completion(true) }

        case .denied:
            if suppressGuideAlertOnceAfterSystemDeny {
                suppressGuideAlertOnceAfterSystemDeny = false
                DispatchQueue.main.async { completion(false) }
                return
            }
            showPermissionGuideAlert(fromViewController: viewController, title: nil, message: nil) { _ in
                DispatchQueue.main.async { completion(false) }
            }

        @unknown default:
            DispatchQueue.main.async { completion(false) }
        }
    }

    // MARK: - Guide Alert

    @objc(showPermissionGuideAlertFromViewController:completion:)
    public class func showPermissionGuideAlert(fromViewController viewController: UIViewController?,
                                               completion: ((Bool) -> Void)?) {
        showPermissionGuideAlert(fromViewController: viewController, title: nil, message: nil, completion: completion)
    }

    @objc(showPermissionGuideAlertFromViewController:title:message:completion:)
    public class func showPermissionGuideAlert(fromViewController viewController: UIViewController?,
                                               title: String?,
                                               message: String?,
                                               completion: ((Bool) -> Void)?) {
        guard let viewController else {
            DispatchQueue.main.async { completion?(false) }
            return
        }

        DispatchQueue.main.async {
            let bundle = BFPermissionLocalization.bundle(
                forResourceBundleNamed: "BFMicrophonePermissionManager",
                anchorClass: BFMicrophonePermissionManager.self
            )

            let alertTitle = title ?? BFPermissionLocalization.localized("bf_permission_microphone_title", bundle: bundle)
            let alertMessage = message ?? BFPermissionLocalization.localized("bf_permission_microphone_message", bundle: bundle)
            let settingsTitle = BFPermissionLocalization.localized("bf_permission_common_settings", bundle: bundle)
            let cancelTitle = BFPermissionLocalization.localized("bf_permission_common_cancel", bundle: bundle)

            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: settingsTitle, style: .default) { _ in
                openAppSettingsInternal()
                completion?(true)
            })
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                completion?(false)
            })

            viewController.present(alert, animated: true)
        }
    }

    // MARK: - Settings

    @objc
    public class func openAppSettings() {
        openAppSettingsInternal()
    }
}

private func openAppSettingsInternal() {
    DispatchQueue.main.async {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

enum BFPermissionLocalization {
    static func bundle(forResourceBundleNamed name: String, anchorClass: AnyClass) -> Bundle {
        let frameworkBundle = Bundle(for: anchorClass)
        if let url = frameworkBundle.url(forResource: name, withExtension: "bundle"),
           let bundle = Bundle(url: url) {
            return bundle
        }
        return frameworkBundle
    }

    static func localized(_ key: String, bundle: Bundle) -> String {
        NSLocalizedString(key, bundle: bundle, comment: "")
    }
}
