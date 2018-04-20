//
//  Alerts.swift
//  Chat
//
//  Created by Eduardo Fornari on 19/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class Alerts {

    static func simpleAlert(with title: String, and message: String? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // TO-DO Translate action
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        return alert
    }

}
