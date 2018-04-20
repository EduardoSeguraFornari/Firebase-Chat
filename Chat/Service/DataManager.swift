//
//  DataManagerBackup.swift
//  ForeignMeeting
//
//  Created by Arthur Giachini on 16/11/2017.
//  Copyright © 2017 Arthur Giachini. All rights reserved.
//
 
import UIKit
import FirebaseDatabase
import Firebase

class DataManager {
    
    static let sharedInstance = DataManager()
    
    private init() {}
    
    func save<T: CloudConvertible>(data: T, typeName: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        
        let object = data.intoFBObject()
        let database: DatabaseReference = Database.database().reference()
        
        if let id = data.id {
            database.child(typeName).child(id).updateChildValues(object) { (error, Database) in
                completion(error, database)
            }
        } else {
            database.child(typeName).childByAutoId().setValue(object, withCompletionBlock: { (error, Database) in
                completion(error, database)
            })
        }
    }
    
    func fetch<T: CloudConvertible>(typeName: String, completion: @escaping (Bool, [T]?) -> Void) {
        
        let database: DatabaseReference = Database.database().reference()
        
        database.child(typeName).observeSingleEvent(of: .value) { (dataSnapshot) in
            var result = [T]()
            
            if let values = dataSnapshot.value as? [String: Any] {                
                var aux = [[String: Any]]()
                
                for postValue in values {
                    if let value = postValue.value as? [String: Any] {
                        var newValue = value
                        newValue["id"] = postValue.key
                        aux.append(newValue)
                    }
                }
                result = aux.compactMap { T.init($0) } // map & remove nils
                completion(true, result)
            } else {
                completion(true, result)
            }
        }
    
    }
    
    func fetchObservable<T: CloudConvertible>(eventType: DataEventType, typeName: String, completion: @escaping (Bool, [T]?) -> Void) {
        
        let database: DatabaseReference = Database.database().reference()
        
        database.child(typeName).observe(eventType) { (dataSnapshot) in
            var result = [T]()
            
            if let values = dataSnapshot.value as? [String: Any] {
                var aux = [[String: Any]]()
                
                for postValue in values {
                    if let value = postValue.value as? [String: Any] {
                        var newValue = value
                        newValue["id"] = postValue.key
                        aux.append(newValue)
                    }
                }
                result = aux.compactMap { T.init($0) } // map & remove nils
                completion(true, result)
            } else {
                completion(true, result)
            }
        }
        
    }
    
//    func delete(ids: [String], typeName: String, completion: @escaping ([String]?, Error?) -> Void) {
//    }
    
    func deleteAccount(completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.delete(completion: { (error) in
            completion(error)
        })
    }
    
    func createAccount(with email: String, and password: String, completion: @escaping (User?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            completion(user, error)
        }
    }
    
    func query<T: CloudConvertible>(query: DatabaseQuery, completion: @escaping (Bool, [T]?) -> Void) {
        
        query.observeSingleEvent(of: .value) { (dataSnapshot) in
            var result = [T]()
            
            if let values = dataSnapshot.value as? [String: Any] {
                var aux = [[String: Any]]()
                
                for postValue in values {
                    if let value = postValue.value as? [String: Any] {
                        var newValue = value
                        newValue["id"] = postValue.key
                        aux.append(newValue)
                    }
                }
                result = aux.compactMap { T.init($0) } // map & remove nils
                completion(true, result)
            } else {
                completion(true, result)
            }
        }
        
    }
    
    func queryObservable<T: CloudConvertible>(query: DatabaseQuery, eventType: DataEventType, completion: @escaping (Bool, [T]?) -> Void) {
        
        query.observe(eventType) { (dataSnapshot) in
            var result = [T]()
            
            if let values = dataSnapshot.value as? [String: Any] {
                var aux = [[String: Any]]()
                
                for postValue in values {
                    if let value = postValue.value as? [String: Any] {
                        var newValue = value
                        newValue["id"] = postValue.key
                        aux.append(newValue)
                    }
                }
                result = aux.compactMap { T.init($0) } // map & remove nils
                completion(true, result)
            } else {
                completion(true, result)
            }
        }
        
    }
    
    func queryFirst<T: CloudConvertible>(query: DatabaseQuery, completion: @escaping (Bool, T?) -> Void) {
        
        query.observeSingleEvent(of: .value) { (dataSnapshot) in
            var result = [T]()
            
            if let values = dataSnapshot.value as? [String: Any] {
                var aux = [[String: Any]]()
                
                for postValue in values {
                    if let value = postValue.value as? [String: Any] {
                        var newValue = value
                        newValue["id"] = postValue.key
                        aux.append(newValue)
                    }
                }
                result = aux.compactMap { T.init($0) } // map & remove nils
                completion(true, result.first)
            } else {
                completion(true, result.first)
            }
        }
        
    }
    
    func login(with email: String, and password: String, completion: @escaping (User?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            completion(user, error)
        }
    }

    
    func currentUser() -> User? {
        let user = Auth.auth().currentUser
        return user
    }

}
