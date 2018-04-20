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
    
//    static func saveChatID(userID: String, chatID: String) {
//        let usersRef: DatabaseReference = Database.database().reference()
//        let dict = ["users/\(userID)/chatsIDs/\(chatID)": true]
//        usersRef.updateChildValues(dict)
//    }
    
    //MARK - CREATE
    
    static func createAccount(with email: String, and password: String, completion: @escaping (User?, Error?) -> Void) {
            DataManager.sharedInstance.createAccount(with: email, and: password, completion: completion)
    }
    
    //MARK - LOGIN
    
    static func login(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        DataManager.sharedInstance.login(with: email, and: password, completion: completion)
    }
    
    static func currentUser() -> User? {
        return DataManager.sharedInstance.currentUser()
    }
    
    //MARK - SAVE
    
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
    
//    static func save(with produto: Produto, completion: @escaping (Error?, DatabaseReference) -> Void) {
//        var produtoToSave = produto
//        produtoToSave.vendedorId = currentVendedor?.id
//        DataManager.shareInstance.save(data: produtoToSave, typeName: Produto.typeName, completion: { error, databaseReference in
//            completion(error, databaseReference)
//        })
//    }
    
//    static func save(with lance: Lance, completion: @escaping (Error?, DatabaseReference) -> Void) {
//        var lanceToSave = lance
//        lanceToSave.compradorId = currentVendedor?.id
//        DataManager.shareInstance.save(data: lanceToSave, typeName: Lance.typeName, completion: { error, databaseReference in
//            completion(error, databaseReference)
//        })
//    }
    
    //MARK - DELETE
    
//    static func deleteAccount(completion: @escaping (Error?) -> Void) {
//        DataManager.shareInstance.deleteAccount(completion: completion)
//    }
    
    //MARK - Fetch
    
//    static func fetchVendedores(completion: @escaping (Bool, [Vendedor]?) -> Void) {
//        DataManager.shareInstance.fetch(typeName: Vendedor.typeName, completion: completion)
//    }
    
    static func fetchCurrentUserProfile(completion: @escaping (Bool, Profile?) -> Void) {
        let currentUserAccountId = Auth.auth().currentUser?.uid

        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(Profile.typeName).queryOrdered(byChild: "accountId").queryEqual(toValue: currentUserAccountId)

        DataManager.sharedInstance.queryFirst(query: query, completion: completion)
    }
    
//    static func fetchMeusProdutosObservable(completion: @escaping (Bool, [Produto]?) -> Void) {
//        let databaseReference: DatabaseReference = Database.database().reference()
//        let query = databaseReference.child(Produto.typeName).queryOrdered(byChild: "vendedorId").queryEqual(toValue: currentVendedor!.id!)
//
//        DataManager.shareInstance.queryObservable(query: query, completion: completion)
//    }
    
//    static func fetchLancesObservable(in produto: Produto, completion: @escaping (Bool, [Lance]?) -> Void) {
//        let databaseReference: DatabaseReference = Database.database().reference()
//        let query = databaseReference.child(Lance.typeName).queryOrdered(byChild: "produtoId").queryEqual(toValue: produto.id)
//        DataManager.shareInstance.queryObservable(query: query, completion: completion)
//    }
    
//    static func fetchAllProdutosObservable(completion: @escaping (Bool, [Produto]?) -> Void) {
//        DataManager.shareInstance.fetchObservable(typeName: Produto.typeName, completion: completion)
//    }
    
//    static func fetchVendedorBy(id: String, completion: @escaping (Bool, Vendedor?) -> Void) {
//        let databaseReference: DatabaseReference = Database.database().reference()
//        let query = databaseReference.child(Vendedor.typeName).queryOrdered(byChild: "id").queryEqual(toValue: id)
//
//        DataManager.shareInstance.queryFirst(query: query, completion: completion)
//    }

}
