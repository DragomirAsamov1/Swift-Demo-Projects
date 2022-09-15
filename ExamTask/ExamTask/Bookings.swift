//
//  Bookings.swift
//  ExamTask
//
//  Created by Darren Asamov on 02/11/2021.
//

import Foundation
import RealmSwift

let REALM_QUEUE = DispatchQueue(label: "realmQueue")

 
class Bookings: Object, Decodable {
    @objc dynamic var autoPointID: Int = 0
    @objc dynamic var bayNumber: Int = 0
    @objc dynamic var baySize: String = ""
    @objc dynamic var VehicleReg: String = ""
    @objc dynamic var referenceCode: Int = 0
    @objc dynamic var accessType: String = ""
    @objc dynamic var vehicleMap: String = ""
    @objc dynamic var vehicleBayNumber: String = ""
    @objc dynamic var bookingType: String = ""
    @objc dynamic var codeNumber: Int = 0
    @objc dynamic var isAdmin: Bool = false
    @objc dynamic var email: String = ""
    @objc dynamic var mobile: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var isDeclinedRedConcernsScreenAvailable: Bool = false
    @objc dynamic var advertisementLeft1Url: String = ""
    @objc dynamic var advertisementLeft2Url: String = ""
    @objc dynamic var advertisementRight1Url: String = ""
    @objc dynamic var advertisementRight2Url: String = ""
    
    enum CodingKeys: String, CodingKey {
        case autoPointID = "AutoPointID"
        case bayNumber = "BayNumber"
        case baySize = "BaySize"
        case VehicleReg = "VehicleReg"
        case referenceCode = "ReferenceCode"
        case accessType = "AccessType"
        case vehicleMap = "VehicleMap"
        case vehicleBayNumber = "VehicleBayNumber"
        case bookingType = "BookingType"
        case codeNumber = "CodeNumber"
        case isAdmin = "IsAdmin"
        case email = "Email"
        case mobile = "Mobile"
        case surname = "Surname"
        case title = "Title"
        case isDeclinedRedConcernsScreenAvailable = "IsDeclinedRedConcernsScreenAvailable"
        case advertisementLeft1Url = "AdvertisementLeft1Url"
        case advertisementLeft2Url = "AdvertisementLeft2Url"
        case advertisementRight1Url = "AdvertisementRight1Url"
        case advertisementRight2Url = "AdvertisementRight2Url"
    }
    
    convenience init(autoPointID: Int, bayNumber: Int, baySize: String, VehicleReg: String, referenceCode: Int, accessType: String, vehicleMap: String, vehicleBayNumber: String, bookingType: String, codeNumber: Int, isAdmin: Bool, email: String, mobile: String, surname: String, title: String, isDeclinedRedConcernsScreenAvailable: Bool, advertisementLeft1Url: String, advertisementLeft2Url: String, advertisementRight1Url: String, advertisementRight2Url: String) {
        self.init()
        self.autoPointID = autoPointID
        self.bayNumber = bayNumber
        self.baySize = baySize
        self.VehicleReg = VehicleReg
        self.referenceCode = referenceCode
        self.accessType = accessType
        self.vehicleMap = vehicleMap
        self.vehicleBayNumber = vehicleBayNumber
        self.bookingType = bookingType
        self.codeNumber = codeNumber
        self.isAdmin = isAdmin
        self.email = email
        self.mobile = mobile
        self.surname = surname
        self.title = title
        self.isDeclinedRedConcernsScreenAvailable = isDeclinedRedConcernsScreenAvailable
        self.advertisementLeft1Url = advertisementLeft1Url
        self.advertisementLeft2Url = advertisementLeft2Url
        self.advertisementRight1Url = advertisementRight1Url
        self.advertisementRight2Url = advertisementRight2Url
    }
    
    static func createBooking(booking: Bookings) {
        print("Trying to create booking")
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                try realm.write {
                    realm.add(booking)
                    try realm.commitWrite()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func getAllBookings() -> [Bookings]? {
        REALM_QUEUE.sync {
            var allBookings : [Bookings] = [Bookings]()
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allBookingsData = realm.objects(Bookings.self)
                
                for booking in allBookingsData {
                    allBookings.append(booking)
                }
                return allBookings
            } catch {
                return nil
            }
        }
    }
    
    static func deleteBooking(booking: Bookings) {
        print("Delete a Booking!")
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allBookings = realm.objects(Bookings.self)
                if allBookings.contains(booking) {
                    try! realm.write {
                        realm.delete(booking)
                        try realm.commitWrite()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    static func deleteAllBookings() {
        print("Just deleted all bookings")
        REALM_QUEUE.sync {
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                let allBookings = realm.objects(Bookings.self)
                try! realm.write{
                    realm.delete(allBookings)
                    try realm.commitWrite()
                }
            } catch {
                print(error)
            }
        }
    }
}
