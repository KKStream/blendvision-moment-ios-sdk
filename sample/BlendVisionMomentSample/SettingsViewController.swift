//
//  SettingsViewController.swift
//  BlendVisionMoment
//
//  Created by chantil on 2021/3/10.
//  Copyright © 2021 KKStream Limited. All rights reserved.
//

import UIKit
import BlendVisionMoment

class SettingsViewController: UITableViewController {
    private let settingsCellIdentifier = "SettingsCell"

    enum Row: String, CaseIterable {
        case accessToken = "Access Token"
        case deviceId = "Device ID"
        case version = "Version"

        var title: String { rawValue }
    }
    private let rows: [Row] = Row.allCases

    private let accessTokenItem = AccessTokenItem()
    private let deviceIdItem = DeviceIdItem()
    private let versionItem = VersionItem()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: settingsCellIdentifier)
        let cell = dequeuedCell ?? UITableViewCell(style: .value1, reuseIdentifier: settingsCellIdentifier)

        let row = rows[indexPath.row]
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.minimumScaleFactor = 0.5

        switch row {
        case .accessToken:
            cell.detailTextLabel?.text = accessTokenItem.text
        case .deviceId:
            cell.detailTextLabel?.text = deviceIdItem.text
        case .version:
            cell.detailTextLabel?.text = versionItem.text
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch rows[indexPath.row] {
        case .accessToken:
            accessTokenItem.action(in: self, completion: {
                tableView.reloadRows(at: [indexPath], with: .none)
            })
        case .deviceId:
            deviceIdItem.action(in: tableView.cellForRow(at: indexPath)?.detailTextLabel, completion: {})
        case .version:
            versionItem.action(in: self, completion: {})
        }
    }
}

// MARK: - Settings items
extension SettingsViewController {
    struct AccessTokenItem {
        var text: String? { Configuration.accessToken }

        func action(in viewController: UIViewController, completion: @escaping () -> Void) {
            let alert = UIAlertController(title: "Enter Access Token", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let doneAction = UIAlertAction(title: "Done", style: .default, handler: { (_) in
                guard let newAccessToken = alert.textFields?.first?.text else { return }
                Configuration.updateAccessToken(newAccessToken)
                completion()
            })
            alert.addTextField(configurationHandler: { textField in
                let shouldBeEnabled: (String?) -> Bool = { !($0 ?? "").isEmpty }

                textField.text = text
                textField.clearButtonMode = .whileEditing
                doneAction.isEnabled = shouldBeEnabled(textField.text)

                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main, using: { _ in
                    doneAction.isEnabled = shouldBeEnabled(textField.text)
                })
            })
            alert.addAction(cancelAction)
            alert.addAction(doneAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    struct DeviceIdItem {
        var text: String? { Configuration.deviceId }

        func action(in view: UIView?, completion: @escaping () -> Void) {
            guard let view = view else { return }
            view.becomeFirstResponder()

            if !UIMenuController.shared.isMenuVisible {
                UIMenuController.shared.setTargetRect(view.bounds, in: view)
                UIMenuController.shared.setMenuVisible(true, animated: true)
            }
        }
    }

    struct VersionItem {
        var text: String? { Configuration.version }

        func action(in viewController: UIViewController, completion: @escaping () -> Void) {
        }
    }
}
