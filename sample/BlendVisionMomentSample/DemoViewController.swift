//
//  DemoViewController.swift
//  BlendVisionSample
//
//  Created by chantil on 2021/3/16.
//  Copyright © 2021 KKStream Limited. All rights reserved.
//

import UIKit
import BlendVisionMoment

struct DemoModel {
    static var config: PlayerContext.Configuration = PlayerContext.Configuration()
    static var barItems: [PlayerContext.BarItem] = [.airplay, .settings]
}

class DemoViewController: UITableViewController {
    private let configCellIdentifier = "ConfigCell"

    enum Section: String, CaseIterable {
        case content = "Content Configs"
        case barItems = "Bar Items"
        case action = "Demo Actions"

        var title: String { rawValue }

        var rows: [Row] {
            switch self {
            case .content: return [.resolution]
            case .barItems: return [.airplay, .settings]
            case .action: return [.presentPlayer]
            }
        }
    }
    enum Row: String, CaseIterable {
        // Content
        case resolution = "Default Resolution"

        // Bar Items
        case airplay = "AirPlay"
        case settings = "Settings"

        // Action
        case presentPlayer = ">>> Present Player <<<"

        var title: String { rawValue }
    }
    private let sections: [Section] = Section.allCases

    private let resolutionItem = ResolutionItem()
    private let airplayItem = AirPlayItem()
    private let settingsItem = SettingsItem()
    private let presentPlayerItem = PresentPlayerItem()

    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: configCellIdentifier)
        let cell = dequeuedCell ?? UITableViewCell(style: .value1, reuseIdentifier: configCellIdentifier)

        let row = sections[indexPath.section].rows[indexPath.row]
        cell.textLabel?.text = row.title

        switch row {
        case .resolution:
            cell.detailTextLabel?.text = resolutionItem.text
        case .airplay:
            cell.detailTextLabel?.text = airplayItem.text
        case .settings:
            cell.detailTextLabel?.text = settingsItem.text
        case .presentPlayer:
            cell.detailTextLabel?.text = presentPlayerItem.text
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch sections[indexPath.section].rows[indexPath.row] {
        case .resolution:
            resolutionItem.action(in: self, completion: {
                tableView.reloadRows(at: [indexPath], with: .none)
            })
        case .airplay:
            airplayItem.action(in: self, completion: {
                tableView.reloadSections(IndexSet([indexPath.section]), with: .none)
            })
        case .settings:
            settingsItem.action(in: self, completion: {
                tableView.reloadSections(IndexSet([indexPath.section]), with: .none)
            })
        case .presentPlayer:
            presentPlayerItem.action(in: self, completion: {})
        }
    }
}

// MARK: - Config items
extension DemoViewController {
    struct ResolutionItem {
        var text: String? {
            guard let defaultResolution = DemoModel.config.defaultResolution else { return nil }
            return String(defaultResolution)
        }

        func action(in viewController: UIViewController, completion: @escaping () -> Void) {
            let alert = UIAlertController(title: "Enter Default Resolution", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let doneAction = UIAlertAction(title: "Done", style: .default, handler: { (_) in
                if let newDefaultResolution = alert.textFields?.first?.text {
                    DemoModel.config.defaultResolution = Int(newDefaultResolution)
                } else {
                    DemoModel.config.defaultResolution = nil
                }
                completion()
            })
            alert.addTextField(configurationHandler: { textField in
                textField.keyboardType = .numberPad
                textField.placeholder = "e.g. 1080"
                textField.text = text
                textField.clearButtonMode = .whileEditing
            })
            alert.addAction(cancelAction)
            alert.addAction(doneAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    struct AirPlayItem {
        var text: String? {
            guard let index = DemoModel.barItems.firstIndex(of: .airplay) else { return "" }
            return String(index + 1)
        }

        func action(in viewController: UIViewController, completion: @escaping () -> Void) {
            if let index = DemoModel.barItems.firstIndex(of: .airplay) {
                DemoModel.barItems.remove(at: index)
            } else {
                DemoModel.barItems.append(.airplay)
            }
            completion()
        }
    }

    struct SettingsItem {
        var text: String? {
            guard let index = DemoModel.barItems.firstIndex(of: .settings) else { return "" }
            return String(index + 1)
        }

        func action(in viewController: UIViewController, completion: @escaping () -> Void) {
            if let index = DemoModel.barItems.firstIndex(of: .settings) {
                DemoModel.barItems.remove(at: index)
            } else {
                DemoModel.barItems.append(.settings)
            }
            completion()
        }
    }

    struct PresentPlayerItem {
        var text: String? { nil }

        func action(in viewController: UIViewController, completion: @escaping () -> Void) {
            let context = PlayerContext(config: DemoModel.config, barItems: DemoModel.barItems)
            Utils.presentPlayer(context)
            completion()
        }
    }
}

