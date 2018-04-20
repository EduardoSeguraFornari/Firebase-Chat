//
//  CloudConvertible.swift
//  ForeignMeeting
//
//  Created by Arthur Giachini on 08/11/17.
//  Copyright © 2017 Arthur Giachini. All rights reserved.
//

import CloudKit

protocol CloudConvertible: Equatable {
    static var typeName: String { get }
    var id: String? { get }

    func intoFBObject() -> [String: Any]
    init?(_ fbObject: [String: Any])
}

extension CloudConvertible {

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

}

