//
//  Candidate.swift
//  HireDevs
//
//  Created by Darren Asamov on 03/01/2022.
//

import Foundation
import RealmSwift

let REALM_QUEUE = DispatchQueue(label: "realmQueue")

class Candidate: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var jobPosition: String = ""
    @objc dynamic var dateOfInterview: String = ""
    @objc dynamic var professionalSkills: String? = ""
    
    convenience init(name: String, surname: String, phoneNumber: String, jobPosition: String, dateOfInterview: String, professionalSkills: String?) {
        self.init()
        self.id = UUID().uuidString
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.jobPosition = jobPosition
        self.dateOfInterview = dateOfInterview
        self.professionalSkills = professionalSkills
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    static func createCandidate(candidate: Candidate) {
        print("Trying to create candidate")
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                try realm.write {
                    realm.add(candidate)
                    try realm.commitWrite()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func deleteCandidate(_ candidate: Candidate) {
        print("Delete a Candidate!")
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allCandidates = realm.objects(Candidate.self)
                for singleCandidate in allCandidates{
                    if singleCandidate.id == candidate.id {
                        try! realm.write {
                            realm.delete(candidate)
                            try realm.commitWrite()
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func getAllCandidates() -> [Candidate]? {
        REALM_QUEUE.sync {
            var allCandidates: [Candidate] = [Candidate]()
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allCandidatesData = realm.objects(Candidate.self)
                for candidate in allCandidatesData {
                    allCandidates.append(candidate)
                }
                return allCandidates
            } catch {
                return nil
            }
        }
    }
    
//    static func editSkillsOfCandidate(candidate: Candidate, skills: [String]) {
//        REALM_QUEUE.sync {
//            do {
//                let realm = try Realm(configuration: RealmConfig.runDataConfig)
//                let allCandidates = realm.objects(Candidate.self)
//                for singleCandidate in allCandidates {
//                    if singleCandidate.id == candidate.id {
//                        try realm.write {
//                            realm.create(Candidate.self, value: ["professionalSkills": "!NOT A VALUE MUST REWRITE!"], update: .modified)
//                        }
//                    }
//                }
//                if allCandidates.contains(candidate) {
//                    print("Professional skills has been updated!")
//                    try realm.write{
////                        realm.add(candidate, update: )
//                    }
//                }
//            } catch {
//
//            }
//        }
//    }
}
