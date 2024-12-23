//
//  AlertController.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 19/12/24.
//

#if canImport(UIKit)
    import UIKit

    public class AlertController {

        private var onTextChange: ((String) -> Void)?

        internal var rootController: UIViewController? {
            guard
                let scene = UIApplication.shared.connectedScenes.first(where: {
                    $0.activationState == .foregroundActive
                }) as? UIWindowScene,
                let window = scene.windows.first(where: { $0.isKeyWindow })
            else {
                return nil
            }

            var root = window.rootViewController
            while let presentedViewController = root?.presentedViewController {
                root = presentedViewController
            }
            return root
        }

        func showAlert(
            title: String,
            message: String,
            placeholder: String? = nil,
            defaultText: String? = nil,
            onTextChange: ((String) -> Void)? = nil,
            completion: @escaping (String?) -> Void
        ) {
            // Store the onTextChange closure
            self.onTextChange = onTextChange

            // Create the alert controller
            let alert = UIAlertController(
                title: title, message: message, preferredStyle: .alert)

            // Add a text field
            alert.addTextField { textField in
                textField.placeholder = placeholder
                textField.text = defaultText

                // Add a target to handle text changes
                if onTextChange != nil {
                    textField.addTarget(
                        self, action: #selector(self.textFieldDidChange(_:)),
                        for: .editingChanged)
                }
            }

            alert.addAction(
                UIAlertAction(
                    title: "OK", style: .default,
                    handler: { [weak alert] _ in
                        let textFieldText = alert?.textFields?.first?.text
                        completion(textFieldText)
                    }))
            alert.addAction(
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            // Present the alert
            rootController?.present(alert, animated: true)
        }

        @objc private func textFieldDidChange(_ textField: UITextField) {
            onTextChange?(textField.text ?? "")
        }

        func showAlert(
            title: String,
            message: String,
            onOk: (() -> Void)? = nil,
            onCancel: (() -> Void)? = nil
        ) {
            // Create the alert controller
            let alert = UIAlertController(
                title: title, message: message, preferredStyle: .alert)

            alert.addAction(
                UIAlertAction(
                    title: "OK", style: .default,
                    handler: { _ in
                        onOk?()
                    }))
            alert.addAction(
                UIAlertAction(
                    title: "Cancel", style: .cancel,
                    handler: { _ in
                        onCancel?()
                    }))

            // Present the alert
            rootController?.present(alert, animated: true)
        }
    }
#endif

#if canImport(AppKit)
    import AppKit
    public class AlertController {

        private var onTextChange: ((String) -> Void)?

        // Root Window or ViewController
        internal var rootWindow: NSWindow? {
            return NSApp.mainWindow
        }

        // Show alert with a text field and real-time text change closure
        func showAlert(
            title: String,
            message: String,
            placeholder: String? = nil,
            defaultText: String? = nil,
            onTextChange: ((String) -> Void)? = nil,
            completion: @escaping (String?) -> Void
        ) {
            // Store the onTextChange closure
            self.onTextChange = onTextChange

            // Create the alert
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.alertStyle = .informational

            // Create an input text field
            let textField = NSTextField(
                frame: NSRect(x: 0, y: 0, width: 200, height: 24))
            textField.placeholderString = placeholder
            textField.stringValue = defaultText ?? ""
            alert.accessoryView = textField

            // Show real-time text updates
            if let onTextChange = onTextChange {
                textField.target = self
                textField.action = #selector(self.textFieldDidChange(_:))
            }

            // Add the OK and Cancel buttons
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Cancel")

            // Show the alert
            let response = alert.runModal()

            // Handle completion based on the response
            if response == .alertFirstButtonReturn {
                completion(textField.stringValue)
            } else {
                completion(nil)
            }
        }

        @objc private func textFieldDidChange(_ textField: NSTextField) {
            // Call the closure with the updated text
            onTextChange?(textField.stringValue)
        }

        // Show a simple alert with OK and Cancel actions
        func showAlert(
            title: String,
            message: String,
            onOk: (() -> Void)? = nil,
            onCancel: (() -> Void)? = nil
        ) {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Cancel")

            // Show the alert
            let response = alert.runModal()

            // Handle actions based on the response
            if response == .alertFirstButtonReturn {
                onOk?()
            } else {
                onCancel?()
            }
        }
    }
#endif