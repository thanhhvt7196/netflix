//
//  MovieGenreRealmObject.swift
//  netflix
//
//  Created by thanh tien on 7/24/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RealmSwift

class MovieGenreRealmObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var createdTime = Date()
    @objc dynamic var name = ""
    
    convenience init(genre: Genre) {
        self.init()
        self.id = genre.id ?? 0
        self.name = genre.name ?? ""
        self.createdTime = Date()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                let genreObject = realm.create(MovieGenreRealmObject.self, value: self, update: .all)
                realm.add(genreObject)
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
    
    static func save(genres: [Genre]) {
        do {
            let realm = try Realm()
            try realm.write {
                genres.forEach { genre in
                    let genreObject = MovieGenreRealmObject(genre: genre)
                    let object = realm.create(MovieGenreRealmObject.self, value: genreObject, update: .all)
                    realm.add(object)
                }
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
    
    static func getAllGenres() -> [Genre]? {
        let realm = try? Realm()
        guard let genres = realm?.objects(MovieGenreRealmObject.self).sorted(byKeyPath: "createdTime", ascending: true) else {
            return nil
        }
        return Array(genres.map { $0.getGenre() })
    }
    
    static func delete(id: Int) {
        let realm = try? Realm()
        guard let genre = realm?.object(ofType: MovieGenreRealmObject.self, forPrimaryKey: id) else {
            return
        }
        do {
            try realm?.write {
                realm?.delete(genre)
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
    
    func deleteFromRealm() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(self)
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
    
    static func deleteAllGenres() {
        let realm = try? Realm()
        guard let genres = realm?.objects(MovieGenreRealmObject.self) else { return }
        do {
            try realm?.write {
                realm?.delete(genres)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getGenre() -> Genre {
        return Genre(id: id, name: name)
    }
}
