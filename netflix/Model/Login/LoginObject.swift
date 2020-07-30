//
//  LoginObject.swift
//  netflix
//
//  Created by thanh tien on 7/27/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RealmSwift

class LoginObject: Object, Codable {
    @objc dynamic var username: String?
    @objc dynamic var password: String?
    
    override class func primaryKey() -> String? {
        return "username"
    }
    
    convenience init(username: String?, password: String?) {
        self.init()
        self.username = username
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                let loginObject = realm.create(LoginObject.self, value: self, update: .all)
                realm.add(loginObject)
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
    
    static func getLoginObject() -> LoginObject? {
        let realm = try? Realm()
        return realm?.objects(LoginObject.self).first
    }
    
    static func deleteLoginInfo() {
        let realm = try? Realm()
        guard let allLoginInfo = realm?.objects(LoginObject.self) else {
            return
        }
        do {
            try realm?.write {
                realm?.delete(allLoginInfo)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
