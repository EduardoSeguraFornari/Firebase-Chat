//
//  DataAccessBackup.swift
//  Chat
//
//  Created by Eduardo Fornari on 18/04/18.
//  Copyright © 2017 Arthur Giachini. All rights reserved.
//

import Firebase

class DataAccess {

    let userChatsChangedNotification = NSNotification.Name("UserChatsChanged")

    public var currentProfile: Profile?
    public var currentUserChats: [UserChat]?

    static let sharedInstance = DataAccess()

    private init() {}

    // MARK: - Account

    public func createAccount(with email: String, and password: String, completion: @escaping (User?, Error?) -> Void) {
            DataManager.sharedInstance.createAccount(with: email, and: password, completion: completion)
    }

    public func currentUser() -> User? {
        return DataManager.sharedInstance.currentUser()
    }

    // MARK: - LOGIN

    public func login(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        DataManager.sharedInstance.login(with: email, and: password, completion: completion)
    }

    // MARK: - LOGOUT

    public func logout() {
        DataManager.sharedInstance.logout()
    }

    // MARK: - SAVE

    public func save(with profile: Profile, completion: @escaping (Error?) -> Void) {
        let profileToSave = profile
        profileToSave.accountId = currentUser()?.uid
        DataManager.sharedInstance.save(data: profileToSave, typeName: Profile.typeName,
                                        completion: { error in

            if error == nil {
                self.currentProfile = profileToSave
            }
            completion(error)
        })
    }

    public func save(with userChat: UserChat, completion: @escaping (Error?) -> Void) {
        DataManager.sharedInstance.save(data: userChat, typeName: UserChat.typeName, completion: completion)
    }

    public func save(message: Message, completion: @escaping (Error?) -> Void) {
        DataManager.sharedInstance.save(data: message, typeName: Message.typeName, completion: completion)
    }

    // MARK: - DELETE

//    static func deleteAccount(completion: @escaping (Error?) -> Void) {
//        DataManager.shareInstance.deleteAccount(completion: completion)
//    }

    // MARK: - Fetch

    public func fetchProfilesObservable(completion: @escaping ([Profile]?) -> Void) {
        DataManager.sharedInstance.fetchObservable(eventType: DataEventType.value, typeName: Profile.typeName,
                                                   completion: completion)
    }

    public func fetchUserChatsForCurrentProfileObservable(completion: @escaping ([UserChat]?) -> Void) {
        let currentProfileID = currentProfile!.identifier!
        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(UserChat.typeName).queryOrdered(byChild:
            "firstUserProfileID").queryEqual(toValue: currentProfileID)

        DataManager.sharedInstance.queryObservable(query: query, eventType: DataEventType.value,
                                                   completion: completion)
    }

    public func fetchUserChats(for profileID: String, completion: @escaping ([UserChat]?) -> Void) {
        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(UserChat.typeName).queryOrdered(byChild:
            "profileId").queryEqual(toValue: profileID)

        DataManager.sharedInstance.query(query: query, completion: completion)
    }

    public func fetchMessages(for chatID: String, completion: @escaping ([Message]?) -> Void) {
        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(Message.typeName).queryOrdered(byChild:
            "chatID").queryEqual(toValue: chatID)
        DataManager.sharedInstance.query(query: query, completion: completion)
    }

    public func fetchNewMessageObservable(for chatID: String, completion: @escaping (Message?) -> Void) {
        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(Message.typeName).queryOrdered(byChild:
            "chatID").queryEqual(toValue: chatID)
        DataManager.sharedInstance.queryObservableChildAdded(query: query, completion: completion)
    }

    public func fetchCurrentUserProfile(completion: @escaping ([Profile]?) -> Void) {
        let currentUserAccountId = Auth.auth().currentUser?.uid

        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(Profile.typeName).queryOrdered(byChild:
            "accountId").queryEqual(toValue: currentUserAccountId)

        DataManager.sharedInstance.query(query: query, completion: completion)
    }

    public func fetchUserProfile(by identifier: String, completion: @escaping ([Profile]?) -> Void) {
        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(Profile.typeName).queryOrdered(byChild:
            "identifier").queryEqual(toValue: identifier)

        DataManager.sharedInstance.query(query: query, completion: completion)
    }

}
