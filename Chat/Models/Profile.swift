//
//  Profile.swift
//  Chat
//
//  Created by Eduardo Fornari on 19/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation

struct Profile {

    public private(set) var id: String?

    public var accountId: String?
    public private(set) var firstName: String
    public private(set) var lastName: String
    
    init(firstName: String, lastName: String) {
        self.id = UUID().description
        self.firstName = firstName
        self.lastName = lastName
    }

}

extension Profile: CloudConvertible {

    static var typeName: String {
        return "Profile"
    }

    func intoFBObject() -> [String : Any] {
        var fbObject = [String: Any]()

        fbObject["id"] = self.id as Any
        fbObject["accountId"] = self.accountId as Any
        fbObject["firstName"] = self.firstName as Any
        fbObject["lastName"] = self.lastName as Any

        return fbObject
    }

    init?(_ fbObject: [String : Any]) {
        guard let id = fbObject["id"] as? String else { return nil}
        guard let accountId = fbObject["accountId"] as? String else { return nil}
        guard let firstName = fbObject["firstName"] as? String else { return nil}
        guard let lastName = fbObject["lastName"] as? String else { return nil}

        self.id = id
        self.accountId = accountId
        self.firstName = firstName
        self.lastName = lastName
    }

}
