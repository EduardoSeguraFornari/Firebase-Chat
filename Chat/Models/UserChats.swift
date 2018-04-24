//
//  UserChats.swift
//  Chat
//
//  Created by Eduardo Fornari on 23/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation

class UserChats {
    
    public private(set) var id: String?
    
    public private(set) var profileId: String
    
    public private(set) var chatsId = [String]()
    
    // MARK: - Init
    
    init() {
        id = UUID().description
        profileId = DataAccess.currentProfile!.id!
    }
    
    required init?(_ fbObject: [String : Any]) {
        guard let id = fbObject["id"] as? String else { return nil}
        guard let profileId = fbObject["profileId"] as? String else { return nil}
        guard let chatsId = fbObject["chatsId"] as? [String: Bool] else { return nil}
        
        self.id = id
        self.profileId = profileId
        self.chatsId = []
        for chatId in chatsId {
            self.chatsId.append(chatId.key)
        }
    }
    
}

extension UserChats: CloudConvertible {
    
    static var typeName: String {
        return "UserChats"
    }
    
    func intoFBObject() -> [String : Any] {
        var fbObject = [String: Any]()
        
        fbObject["id"] = id
        fbObject["profileId"] = profileId
        
        var dic = [String: Bool]()
        for cahtID in chatsId {
            dic[cahtID] = true
        }
        fbObject["chatsId"] = dic
        
        return fbObject
    }
    
}
