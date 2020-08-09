//
//  AcountDetail.swift
//  netflix
//
//  Created by thanh tien on 8/9/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RealmSwift

struct AccountDetail: Codable {
    var avatar: Avatar?
    var id: Int?
    var iso_639_1: String?
    var iso_3166_1: String?
    var name: String?
    var includeAdult: Bool?
    var username: String?
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case id
        case iso_639_1
        case iso_3166_1
        case name
        case includeAdult = "include_adult"
        case username 
    }
    
    init(accountDetailObject: AccountDetailObject) {
        self.avatar = Avatar(gravatar: Gravatar(hash: accountDetailObject.avatar))
        self.id = accountDetailObject.id
        self.iso_639_1 = accountDetailObject.iso_639_1
        self.iso_3166_1 = accountDetailObject.iso_3166_1
        self.name = accountDetailObject.name
        self.includeAdult = accountDetailObject.includeAdult
        self.username = accountDetailObject.username
    }
}

struct Avatar: Codable {
    var gravatar: Gravatar?
}

struct Gravatar: Codable {
    var hash: String?
}

class AccountDetailObject: Object {
    @objc dynamic var avatar: String?
    @objc dynamic var id = -1
    @objc dynamic var iso_639_1: String?
    @objc dynamic var iso_3166_1: String?
    @objc dynamic var name: String?
    @objc dynamic var includeAdult = false
    @objc dynamic var username: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(accountDetail: AccountDetail) {
        self.init()
        self.avatar = accountDetail.avatar?.gravatar?.hash
        self.id = accountDetail.id ?? -1
        self.iso_639_1 = accountDetail.iso_639_1
        self.iso_3166_1 = accountDetail.iso_3166_1
        self.name = accountDetail.name
        self.includeAdult = accountDetail.includeAdult ?? false
        self.username = accountDetail.username
    }
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                let accountDetail = realm.create(AccountDetailObject.self, value: self, update: .all)
                realm.add(accountDetail)
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
    
    static func getAccountDetail() -> AccountDetail? {
        let realm = try? Realm()
        guard let accountDetailObject = realm?.objects(AccountDetailObject.self).first else {
            return nil
        }
        return AccountDetail(accountDetailObject: accountDetailObject)
    }
    
    static func deleteAccountDetails() {
        let realm = try? Realm()
        guard let accountDetails = realm?.objects(AccountDetailObject.self) else {
            return
        }
        do {
            try realm?.write {
                realm?.delete(accountDetails)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
