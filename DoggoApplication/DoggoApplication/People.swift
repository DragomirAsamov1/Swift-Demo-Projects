//
//  PeopleList.swift
//  DoggoApplication
//
//  Created by Darren Asamov on 12/10/2021.
//

import Foundation
import RealmSwift

let REALM_QUEUE = DispatchQueue(label: "realmQueue")

class People: Object {
    @objc dynamic var peopleID: ObjectId = ObjectId.generate()
    @objc dynamic var name: String = ""
//    var dogs: [Dog] = [Dog]()
    var dogs = List<Dog>()
    convenience init (name: String, dogs: [Dog]) {
        self.init()
        self.name = name
        self.dogs.append(objectsIn: dogs)
    }
    override static func primaryKey() -> String {
        return "peopleID"
    }
    
    static func create(person: People) {
        print("Try to create a person!")
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                try realm.write {
                    realm.add(person)
                    try realm.commitWrite()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func getAllPeople() -> [People]? {
        REALM_QUEUE.sync {
            var allPeople : [People] = [People]()
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allPeopleData = realm.objects(People.self)
                for person in allPeopleData {
                    allPeople.append(person)
                }
                return allPeople
            } catch {
                return nil
            }
        }
    }
    
    static func deletePerson(person: People) {
        print("Delete a person!")
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allPeople = realm.objects(People.self)
                for human in allPeople {
                    if human.peopleID == person.peopleID {
                        try! realm.write {
                            realm.delete(person)
                            try realm.commitWrite()
                        }
                        break
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
