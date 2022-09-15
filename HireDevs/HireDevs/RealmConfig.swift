//
//  RealmConfig.swift
//  HireDevs
//
//  Created by Darren Asamov on 02/01/2022.
//

import Foundation
import RealmSwift

let REALM_RUN_CONFIG = "realmRunConfig"

class RealmConfig {

    static var runDataConfig: Realm.Configuration {

        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)

        let config = Realm.Configuration(

            fileURL: realmPath,

            schemaVersion: 17, // iTunes 1, Build 1 *** Live API *** Live Uploader ***

            migrationBlock: { migration, oldSchemaVersion in

                if (oldSchemaVersion < 17) {

                    //Nothing to do

                    //Realm with automatically detect new properties and remove properties

                }
        })
        return config
    }
}
