//
//  ViewController.swift
//  BlendVisionSample
//
//  Created by chantil on 2021/2/24.
//  Copyright © 2021 KKStream Limited. All rights reserved.
//

import UIKit
import BlendVisionMoment

class ViewController: UIViewController {
    func presentPlayer() {
        // Update access token if needed
//        Configuration.updateAccessToken("valid_access_token")

        // Create a player context with bar items
        let context = PlayerContext(barItems: [.settings])

        // Update configurations
        context.config.defaultResolution = 1080

        // Update bar items
        context.barItems = [.airplay, .settings]

        // Modally present player
        Utils.presentPlayer(context)
    }
}

