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
import Moya

public protocol LoaMateRepository {
    // ChracterWork
    func setClearCommander(characterName: String, commanderName: CommandersName, isClear: Bool)
    
    // USerData
    func saveUserData(mainCharacterName: String, selectedCharacterArr: [CharacterInfoModel])
    func fetchUserData()
    var userData: BehaviorRelay<UserData?> { get }
    
    // userEmail
    var userEmailRelay: BehaviorRelay<String> { get }
    func fetchEmail()
    func addEmail(email: String)
    
    // API
    func searchCharacters(userNickname: String)
    func searchCharcterProfile(userNickname: String)
    var charactersInfoRelay: BehaviorRelay<[CharacterInfoModel]> { get }
    var characterProfileRelay: BehaviorRelay<ArmoryProfileModel?> { get }
}

public final class LoaMateRepositoryImp: LoaMateRepository {
    private let provider = MoyaProvider<LostarkAPI>()
    public var userData = BehaviorRelay<UserData?>(value: nil)
    public var characterProfileRelay = BehaviorRelay<ArmoryProfileModel?>(value: nil)
    public var userEmailRelay = BehaviorRelay<String>(value: "")
    public var charactersInfoRelay = BehaviorRelay<[CharacterInfoModel]>(value: [])
    
    public func fetchEmail() {
        guard let realm = Realm.safeInit() else { return }
        
        guard let userEmial = realm.objects(UserEmail.self).first else { return }
        userEmailRelay.accept(userEmial.userEmail)
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
        
        userEmailRelay.accept(userEmail.userEmail)
    }
    
    // 로아API에서 캐릭터 목록 검색
    public func searchCharacters(userNickname: String) {
        provider.request(.characters(characterName: userNickname)) { result in
            switch result {
            case .success(let response):
                let result = try? response.map([CharacterInfoModel].self)
                
                let sortedResult = result?.sorted(by: {
                    
                    let newCharacterLevel_0 = $0.ItemMaxLevel.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                    let newCharacterLevel_1 = $1.ItemMaxLevel.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                    return newCharacterLevel_0 > newCharacterLevel_1
                })
                if let sortedResult = sortedResult {
                    self.charactersInfoRelay.accept(sortedResult)
                }
                
                
            case .failure(let error):
                print("error = \(error.localizedDescription)")
            }
        }
    }
    
    // 로아API에서 캐릭터 프로필 검색
    public func searchCharcterProfile(userNickname: String) {
        provider.request(.profiles(characterName: userNickname)) { result in
            switch result {
            case .success(let response):
                let result = try? response.map(ArmoryProfileModel.self)
                if let result = result {
                    self.characterProfileRelay.accept(result)
                }

            case .failure(let error):
                print("error = \(error.localizedDescription)")
            }
        }
    }
    
    public func saveUserData(mainCharacterName: String, selectedCharacterArr: [CharacterInfoModel]) {
        print("Repo :: saveUserData = \(selectedCharacterArr)")
        
        var characterWorks: [CharacterWork] = []
        for selectedCharacter in selectedCharacterArr {
            let commandersWork = CommandersWork(characterLevelString: selectedCharacter.ItemMaxLevel)
            let dailyWork = DailyWork()
            let characterWork = CharacterWork(nickName: selectedCharacter.CharacterName,
                                             className: selectedCharacter.CharacterClassName,
                                             level: selectedCharacter.ItemMaxLevel,
                                             server: selectedCharacter.ServerName,
                                             commandersWork: commandersWork,
                                             dailyWork: dailyWork)
            characterWorks.append(characterWork)
            print("Repo :: ChracterWork = \(characterWork)")
        }
        
        let userData = UserData(mainCharacterName: mainCharacterName,
                                characterWorks: characterWorks,
                                lastResetDate: Date()
        )
        print("Repo :: UserData = \(userData), \(userData.charactersWorks.first)")
        
        guard let realm = Realm.safeInit() else { return }

        realm.safeWrite {
            realm.add(userData)
        }
        
        self.userData.accept(userData)
    }
    
    public func setClearCommander(characterName: String, commanderName: CommandersName, isClear: Bool) {
        guard let realm = Realm.safeInit() else { return }
        
        guard let characterWork: CharacterWork = realm.objects(UserData.self).first?.charactersWorks.filter ({ $0.nickName == characterName }).first else { return }
        
        guard let newCharacterWork = characterWork.commandersWork?.commanders.filter({ $0.name == commanderName }).first else { return }
        
        realm.safeWrite {
            newCharacterWork.isClear = isClear
        }
    }
    
    public func fetchUserData() {
        print("Repo :: fetchUserData!")
        guard let realm = Realm.safeInit() else { return }
        
        guard let userData = realm.objects(UserData.self).first else {
            self.userData.accept(UserData())
            return
        }
        
        self.userData.accept(userData)
    }
}
