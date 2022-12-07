//
//  Realm+Util.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation
import RealmSwift
import Realm

extension Realm {
    static func safeInit() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        }
        catch {
            // LOG ERROR
        }
        return nil
    }

    func safeWrite(_ block: () -> ()) {
        do {
            // Async safety, to prevent "Realm already in a write transaction" Exceptions
            if !isInWriteTransaction {
                try write(block)
            }
        } catch {
            // LOG ERROR
        }
    }
}
