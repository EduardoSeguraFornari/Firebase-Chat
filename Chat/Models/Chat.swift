//
//  Chat.swift
//  Chat
//
//  Created by Eduardo Fornari on 20/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation

class Chat {
    
    public private(set) var id: String?
    
    public private(set) var usersID: [String] = []
    
    // MARK: - Init
    
    init(user1: String, user2: String) {
        id = UUID().description
    }
    
    required init?(_ fbObject: [String : Any]) {
        guard let id = fbObject["id"] as? String else { return nil}
        guard let usersID = fbObject["usersID"] as? [String: Bool] else { return nil}
        
        self.id = id
        self.usersID = []
        for userID in usersID {
            self.usersID.append(userID.key)
        }
    }
    
    func addUser(with profileID: String) {
        if !usersID.contains(profileID) {
            usersID.append(profileID)
        }
    }
    
    func removeUser(with profileID: String) {
        if let index = usersID.index(where: { (userID) -> Bool in userID == profileID}) {
            usersID.remove(at: index)
        }
    }
    
}

extension Chat: CloudConvertible {
    
    static var typeName: String {
        return "Chat"
    }
    
    func intoFBObject() -> [String : Any] {
        var fbObject = [String: Any]()
        
        fbObject["id"] = self.id
        var dic = [String: Bool]()
        for userID in usersID {
            dic[userID] = true
        }
        fbObject["usersID"] = dic
        
        return fbObject
    }
    
}
