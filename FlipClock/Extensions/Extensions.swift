import SwiftUI

extension String {
    init?(_ value: Int, base: Base, padding: Int) {
        if base == .doz {
            self = String(value, radix: 12, uppercase: true).replacingOccurrences(of: "A", with: "D").replacingOccurrences(of: "B", with: "E")
        } else {
            self.init(value, radix: base.rawValue, uppercase: true)
        }
        while self.count < padding {
            self.insert("0", at: self.startIndex)
        }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#if swift(<5.1)
extension Strideable where Stride: SignedInteger {
    func clamped(to limits: CountableClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
#endif


extension UIWindow {
    public func showAlert(placeholder: String, currentText: String, primaryTitle: String, cancelTitle: String, primaryAction: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: primaryTitle, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = currentText
            textField.becomeFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { textField.selectAll(nil) }
        }

        let primaryButton = UIAlertAction(title: primaryTitle, style: .default) { _ in
            guard let text = alertController.textFields?[0].text else { return }
            primaryAction(text)
        }

        let cancelButton = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)

        alertController.addAction(primaryButton)
        alertController.addAction(cancelButton)

        self.rootViewController?.present(alertController, animated: true)
    }
}

extension UIApplication {
    func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
        .first?.windows.filter { $0.isKeyWindow }.first
    }
}