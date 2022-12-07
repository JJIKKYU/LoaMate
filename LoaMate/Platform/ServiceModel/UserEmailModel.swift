//
//  UserEmailModel.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation
import RealmSwift

class UserEmail: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var userEmail: String
    
    convenience init(userEmail: String) {
        self.init()
        self.userEmail = userEmail
    }
}
