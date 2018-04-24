//
//  DataAccessBackup.swift
//  ForeignMeeting
//
//  Created by Arthur Giachini on 16/11/2017.
//  Copyright © 2017 Arthur Giachini. All rights reserved.
//

import Firebase

class DataAccess {
    
    static var currentProfile: Profile?
    
    static func saveChatID(userID: String, chatID: String) {
        let usersRef = Database.database().reference()
        let dict = ["users/\(userID)/chatsIDs/\(chatID)": true]
        usersRef.updateChildValues(dict)
    }
    
    // MARK - CREATE
    
    static func createAccount(with email: String, and password: String, completion: @escaping (User?, Error?) -> Void) {
            DataManager.sharedInstance.createAccount(with: email, and: password, completion: completion)
    }
    
    // MARK - LOGIN
    
    static func login(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        DataManager.sharedInstance.login(with: email, and: password, completion: completion)
    }
    
    static func currentUser() -> User? {
        return DataManager.sharedInstance.currentUser()
    }
    
    // MARK: - LOGOUT
    
    static func logout() {
        DataManager.sharedInstance.logout()
    }
    
    // MARK - SAVE
    
    static func save(with profile: Profile, completion: @escaping (Error?, DatabaseReference) -> Void) {
        var profileToSave = profile
        profileToSave.accountId = currentUser()?.uid
        DataManager.sharedInstance.save(data: profileToSave, typeName: Profile.typeName, completion: { error, databaseReference in
            if error == nil {
                currentProfile = profileToSave
            }
            completion(error, databaseReference)
        })
    } 
    
    //MARK - DELETE
    
//    static func deleteAccount(completion: @escaping (Error?) -> Void) {
//        DataManager.shareInstance.deleteAccount(completion: completion)
//    }
    
    //MARK - Fetch
    
    static func fetchProfilesObservable(completion: @escaping ([Profile]?) -> Void) {
        DataManager.sharedInstance.fetchObservable(eventType: DataEventType.value, typeName: Profile.typeName, completion: completion)
    }
    
    static func queryChatsWith(query: DatabaseQuery, completion: @escaping (Bool, [Chat]?) -> Void) {
        DataManager.sharedInstance.query(query: query, completion: completion)
    }
    
//    static func fetchChatsObservable(completion: @escaping ([Chat]?) -> Void) {
//
//        let databaseReference: DatabaseReference = Database.database().reference()
//
//        let query1 = databaseReference.child(Chat.typeName).queryOrdered(byChild: "user1").queryEqual(toValue: currentProfile!)
//        let query2 = databaseReference.child(Chat.typeName).queryOrdered(byChild: "user2").queryEqual(toValue: currentProfile!)
//
//        queryChatsWith(query: query1) { (firstQueryFinished, fistQueryChats) in
//            if firstQueryFinished {
//                var chats = fistQueryChats as? [Chat] != nil ? fistQueryChats! : [Chat]()
//                queryChatsWith(query: query2) { (secondQueryFinished, secondQueryChats) in
//                    if secondQueryFinished {
//                        if let secondQueryChats = secondQueryChats {
//                            chats.append(contentsOf: secondQueryChats)
//                        }
//                        completion(chats)
//                    }
//                }
//            }
//        }
//
//        DataManager.sharedInstance.fetchObservable(eventType: DataEventType.value, typeName: Chat.typeName, completion: completion)
//    }
    
    static func fetchCurrentUserProfile(completion: @escaping (Bool, Profile?) -> Void) {
        let currentUserAccountId = Auth.auth().currentUser?.uid

        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(Profile.typeName).queryOrdered(byChild: "accountId").queryEqual(toValue: currentUserAccountId)

        DataManager.sharedInstance.queryFirst(query: query, completion: completion)
    }

}
