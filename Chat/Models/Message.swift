//
//  Message.swift
//  Chat
//
//  Created by Eduardo Fornari on 23/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation

class Message {

    public private(set) var identifier: String?
    var chatID: String
    var senderID: String
    var text: String

    var date: Date

    init(chatID: String, senderID: String, text: String) {
        identifier = UUID().description
        self.chatID = chatID
        self.senderID = senderID
        self.text = text
        date = Date()
    }

    required init?(_ fbObject: [String: Any]) {
        guard let identifier = fbObject["identifier"] as? String,
            let chatID = fbObject["chatID"] as? String,
            let senderID = fbObject["senderID"] as? String,
            let text = fbObject["text"] as? String,
            let year = fbObject["year"] as? Int,
            let month = fbObject["month"] as? Int,
            let day = fbObject["day"] as? Int,
            let hour = fbObject["hour"] as? Int,
            let minute = fbObject["minute"] as? Int,
            let second = fbObject["second"] as? Int,
            let nanosecond = fbObject["nanosecond"] as? Int else { return nil }

        self.identifier = identifier
        self.chatID = chatID
        self.senderID = senderID
        self.text = text

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = nanosecond
        self.date = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.date(from: components)!
    }

}

// MARK: - CloudConvertible

extension Message: CloudConvertible {

    static var typeName: String {
        return "Message"
    }

    func intoFBObject() -> [String: Any] {
        var fbObject = [String: Any]()

        fbObject["identifier"] = identifier
        fbObject["chatID"] = chatID
        fbObject["senderID"] = senderID
        fbObject["text"] = text

        let date = Date()
        let calendar = Calendar.current

        let year = calendar.component(.year, from: date)
        fbObject["year"] = year
        let month = calendar.component(.month, from: date)
        fbObject["month"] = month
        let day = calendar.component(.day, from: date)
        fbObject["day"] = day
        let hour = calendar.component(.hour, from: date)
        fbObject["hour"] = hour
        let minute = calendar.component(.minute, from: date)
        fbObject["minute"] = minute
        let second = calendar.component(.second, from: date)
        fbObject["second"] = second
        let nanosecond = calendar.component(.nanosecond, from: date)
        fbObject["nanosecond"] = nanosecond

        return fbObject
    }

}
