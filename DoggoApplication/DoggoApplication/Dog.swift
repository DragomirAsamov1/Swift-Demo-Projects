//
//  Dog.swift
//  DoggoApplication
//
//  Created by Darren Asamov on 18/10/2021.
//

import Foundation
import RealmSwift


class Dog: Object {
    @objc dynamic var dogID: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
    convenience init(name: String, age: Int) {
        self.init()
        self.dogID = UUID().uuidString
        self.name = name
        self.age = age
    }
    
    static func createDog(dog: Dog) {
        print("Try to create a Dog!")
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                try realm.write {
                    realm.add(dog)
                    try realm.commitWrite()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func getAllDogs() -> [Dog]? {
        REALM_QUEUE.sync {
            var allDogs : [Dog] = [Dog]()
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allDogsData = realm.objects(Dog.self)
                for dog in allDogsData {
                    allDogs.append(dog)
                }
                return allDogs
            } catch {
                return nil
            }
        }
    }
    
    static func deleteDog(dog: Dog) {
        print("Just deleted current dog!")
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allDogs = realm.objects(Dog.self)
                if allDogs.contains(dog){
                    try! realm.write {
                        realm.delete(dog)
                        try realm.commitWrite()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func deleteAllDogs(dog: Dog) {
        print("Just deleted all dogs!")
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allDogs = realm.objects(Dog.self)
                    try! realm.write {
                        realm.delete(allDogs)
                        try realm.commitWrite()
                    }
            } catch {
                print(error)
            }
        }
    }
}
