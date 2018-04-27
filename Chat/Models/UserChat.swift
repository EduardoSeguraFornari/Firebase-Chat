//
//  UserChats.swift
//  Chat
//
//  Created by Eduardo Fornari on 23/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation

class UserChat {

    public private(set) var identifier: String?

    public private(set) var chatID: String
    public private(set) var firstUserProfileID: String
    public private(set) var secondUserProfileID: String

    // MARK: - Init

    init(chatID: String, firstUserProfileID: String, secondUserProfileID: String) {
        identifier = UUID().description
        self.chatID = chatID
        self.firstUserProfileID = firstUserProfileID
        self.secondUserProfileID = secondUserProfileID
    }

    required init?(_ fbObject: [String: Any]) {
        guard let identifier = fbObject["identifier"] as? String,
            let chatID = fbObject["chatID"] as? String,
            let firstUserProfileID = fbObject["firstUserProfileID"] as? String,
            let secondUserProfileID = fbObject["secondUserProfileID"] as? String else { return nil }

        self.identifier = identifier
        self.chatID = chatID
        self.firstUserProfileID = firstUserProfileID
        self.secondUserProfileID = secondUserProfileID
    }

}

// MARK: - CloudConvertible

extension UserChat: CloudConvertible {

    static var typeName: String {
        return "UserChat"
    }

    func intoFBObject() -> [String: Any] {
        var fbObject = [String: Any]()

        fbObject["identifier"] = identifier
        fbObject["chatID"] = chatID
        fbObject["firstUserProfileID"] = firstUserProfileID
        fbObject["secondUserProfileID"] = secondUserProfileID

        return fbObject
    }

}
