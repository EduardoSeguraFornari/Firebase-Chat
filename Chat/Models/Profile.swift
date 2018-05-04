//
//  Profile.swift
//  Chat
//
//  Created by Eduardo Fornari on 19/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class Profile {

    public private(set) var identifier: String?

    public var accountId: String?
    public private(set) var firstName: String
    public private(set) var lastName: String

    public var profilePicture: UIImage?

    // MARK: - Init

    init(firstName: String, lastName: String) {
        identifier = UUID().description
        self.firstName = firstName
        self.lastName = lastName
    }

    required init?(_ fbObject: [String: Any]) {
        guard let identifier = fbObject["identifier"] as? String,
            let accountId = fbObject["accountId"] as? String,
            let firstName = fbObject["firstName"] as? String,
            let lastName = fbObject["lastName"] as? String else { return nil }

        self.identifier = identifier
        self.accountId = accountId
        self.firstName = firstName
        self.lastName = lastName
    }

}

// MARK: - CloudConvertible

extension Profile: CloudConvertible {

    static var typeName: String {
        return "Profile"
    }

    func intoFBObject() -> [String: Any] {
        var fbObject = [String: Any]()

        fbObject["identifier"] = identifier
        fbObject["accountId"] = accountId
        fbObject["firstName"] = firstName
        fbObject["lastName"] = lastName

        return fbObject
    }

}
