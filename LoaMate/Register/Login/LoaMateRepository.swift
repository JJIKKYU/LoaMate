//
//  LoaMateRepository.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation
import RxSwift
import RxRelay
import RealmSwift
import RxRealm

public protocol LoaMateRepository {
    // userEmail
    var userEmail: BehaviorRelay<String> { get }
    func fetchEmail()
    func addEmail(email: String)
}

public final class LoaMateRepositoryImp: LoaMateRepository {
    public var userEmail: BehaviorRelay<String> { userEmailSubject }
    public let userEmailSubject = BehaviorRelay<String>(value: "")
    
    public func fetchEmail() {
        guard let realm = Realm.safeInit() else { return }
        
        guard let userEmial = realm.objects(UserEmail.self).first else { return }
        userEmailSubject.accept(userEmial.userEmail)
    }
    
    public func addEmail(email: String) {
        guard let realm = Realm.safeInit() else { return }
        // 이메일은 하나만 있어야 하므로 이미 저장되어 있다면 삭제하도록
        if let willDeleteUserEmail = realm.objects(UserEmail.self).first {
            realm.safeWrite {
                realm.delete(willDeleteUserEmail)
            }
        }

        let userEmail = UserEmail(userEmail: email)
        realm.safeWrite {
            realm.add(userEmail)
        }
        
        userEmailSubject.accept(email)
    }
}
