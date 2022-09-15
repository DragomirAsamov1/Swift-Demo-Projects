//
//  Employee.swift
//  HireDevs
//
//  Created by Darren Asamov on 03/01/2022.
//

import Foundation
import RealmSwift

class Employee: Object {
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var status: String = ""
    
    convenience init(email: String, password: String, name: String, surname: String, status: String) {
        self.init()
        self.email = email
        self.password = password
        self.name = name
        self.surname = surname
        self.status = status
    }
    
    static func createEmployee(employee: Employee) {
        print("Trying to create employee")
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                try realm.write {
                    realm.add(employee)
                    try realm.commitWrite()
                }
            } catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    static func updateEmployee(employee: Employee) {
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                try realm.write {
                    realm.add(employee, update: .modified)
                    try realm.commitWrite()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func deleteEmployee(_ employee: Employee) {
        print("Delete a Employee!")
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allCandidates = realm.objects(Employee.self)
                if allCandidates.contains(employee) {
                    try! realm.write {
                        realm.delete(employee)
                        try realm.commitWrite()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func getAllEmployees() -> [Employee]? {
        REALM_QUEUE.sync {
            var allEmployees: [Employee] = [Employee]()
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allEmployeesData = realm.objects(Employee.self)
                for employee in allEmployeesData {
                    allEmployees.append(employee)
                }
                return allEmployees
            } catch {
                return nil
            }
        }
    }
    
    static func lookingForEmployee(employee: Employee) -> String {
        REALM_QUEUE.sync {
            let user = "Unrecognised user!"
            do {
                let test = employee.email
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let predicate = NSPredicate(format: "email == %@", test)
                let allEmployees = realm.objects(Employee.self).filter(predicate).first
                if allEmployees?.password == employee.password {
                    return allEmployees!.status
                }
                return user
            } catch {
                print(error)
                return user
            }
        }
    }
}
