//
//  UserData.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation
import RealmSwift

// MARK: - 전체 유저 데이터
public class UserData: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var mainCharacterName: String
    @Persisted var charactersWorks = List<CharacterWork>()
    var charactersWorksArr: [CharacterWork] {
        get {
            return charactersWorks.map { $0 }
        }
        set {
            charactersWorks.removeAll()
            charactersWorks.append(objectsIn: newValue)
        }
    }
    @Persisted var lastResetDate: Date
    
    convenience init(mainCharacterName: String, characterWorks: [CharacterWork], lastResetDate: Date) {
        self.init()
        print("UserDataInit! :: characterWorks = \(characterWorks)")
        self.mainCharacterName = mainCharacterName
        self.charactersWorksArr = characterWorks
        self.lastResetDate = lastResetDate
    }
}

// MARK: - 캐릭터별 숙제
class CharacterWork: EmbeddedObject {
    @Persisted var nickName: String
    @Persisted var className: String
    @Persisted var level: String
    @Persisted var server: String
    @Persisted var commandersWork: CommandersWork?
    @Persisted var dailyWork: DailyWork?
    
    convenience init(nickName: String, className: String, level: String, server: String, commandersWork: CommandersWork, dailyWork: DailyWork) {
        self.init()
        print("CharacterWorkInit! :: CommanderWork = \(commandersWork)")
        self.nickName = nickName
        self.className = className
        self.level = level
        self.server = server
        self.commandersWork = commandersWork
        self.dailyWork = dailyWork
    }
}

// MARK: - 일일 숙제
// 일일 숙제
class DailyWork: EmbeddedObject {
    @Persisted var chaos: ChaosWork?
    @Persisted var epona: EponaWork?
    @Persisted var guardian: GuardianWork?
    
    override init() {
        chaos = ChaosWork(restGauge: 0, isClears: [false, false], clearDate: nil)
        epona = EponaWork(restGauge: 0, isClears: [false, false, false], clearDate: nil)
        guardian = GuardianWork(restGauge: 0, isClears: [false, false], clearDate: nil)
    }
}

class ChaosWork: EmbeddedObject {
    @Persisted var restGauge: Int // max 100, min 0 매일 안돌면 20, 오늘돌았니.count == 1 -> +10, 오늘돌았니.count == 2 -> +0, 오늘돌았니.count ==0 -> +20
    @Persisted var isClears: List<Bool> // [false, false] [true, false] [true, true] -> true가 하나면 -20, true가 두개면 -40
    @Persisted var clearDate: Date?
    
    convenience init(restGauge: Int, isClears: [Bool], clearDate: Date? = nil) {
        self.init()
        self.restGauge = restGauge
        self.isClears.append(objectsIn: isClears)
        self.clearDate = clearDate
    }
}

class EponaWork: EmbeddedObject {
    @Persisted var restGauge: Int
    @Persisted var isClears: List<Bool>
    @Persisted var clearDate: Date?
    
    convenience init(restGauge: Int, isClears: [Bool], clearDate: Date? = nil) {
        self.init()
        self.restGauge = restGauge
        self.isClears.append(objectsIn: isClears)
        self.clearDate = clearDate
    }
}

class GuardianWork: EmbeddedObject {
    @Persisted var restGauge: Int
    @Persisted var isClears: List<Bool>
    @Persisted var clearDate: Date?
    
    convenience init(restGauge: Int, isClears: [Bool], clearDate: Date? = nil) {
        self.init()
        self.restGauge = restGauge
        self.isClears.append(objectsIn: isClears)
        self.clearDate = clearDate
    }
}



// MARK: - 군단장
// 군단장 숙제
class CommandersWork: EmbeddedObject {
    @Persisted var clearCount: Int = 0 // 0, 1, 2
    @Persisted var commanders = List<Commander>() // 군단장들[0] -> 군단장(이름: 발탄, 돌았니, 2022-121310)
    var commandersArr: [Commander] {
        get {
            return commanders.map { $0 }
        }
        set {
            commanders.removeAll()
            commanders.append(objectsIn: newValue)
        }
    }
    
    // 캐릭터 레벨 넣으면 알아서 세팅되게
    convenience init(characterLevelString: String) {
        self.init()
        let newCharacterLevel = characterLevelString.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        let characterLevel: Float = Float(newCharacterLevel) ?? 0.0
        print("CommandersWork :: level = \(characterLevel), \(characterLevelString)")
        if characterLevel < 1415 {
            print("CommandersWork :: 세팅할 레벨이 아닙니다.")
            self.clearCount = 0
            self.commanders = List()
            return
        }
        if characterLevel >= 1415 {
            self.commanders.append(
                Commander(name: .val, mode: .normarl, step: 2, isClear: false)
            )
        }
        if characterLevel >= 1430 {
            self.commanders.append(
                Commander(name: .via, mode: .normarl, step: 3, isClear: false)
            )
        }
        if characterLevel >= 1445 {
            for (index, commander) in commanders.enumerated() {
                if commander.name == .val {
                    commanders[index].mode = .hard
                }
            }
        }
        if characterLevel >= 1460 {
            for (index, commander) in commanders.enumerated() {
                if commander.name == .via {
                    commanders[index].mode = .hard
                }
            }
        }
        if characterLevel >= 1475 {
            self.commanders.append(
                Commander(name: .kk, mode: .normarl, step: 3, isClear: false)
            )
        }
        if characterLevel >= 1490 {
            self.commanders.append(
                Commander(name: .abr, mode: .normarl, step: 2, isClear: false)
            )
        }
        if characterLevel >= 1500 {
            for (index, commander) in commanders.enumerated() {
                if commander.name == .abr {
                    commanders[index].step = 4
                }
            }
        }
        if characterLevel >= 1520 {
            for (index, commander) in commanders.enumerated() {
                if commander.name == .abr {
                    commanders[index].step = 6
                }
            }
        }
        if characterLevel >= 1540 {
            for (index, commander) in commanders.enumerated() {
                if commander.name == .abr {
                    commanders[index].mode = .hard
                }
            }
        }
        if characterLevel >= 1580 {
            self.commanders.append(
                Commander(name: .il, mode: .normarl, step: 3, isClear: false)
            )
        }
        if characterLevel >= 1600 {
            for (index, commander) in commanders.enumerated() {
                if commander.name == .il {
                    commanders[index].mode = .hard
                }
            }
        }
    }
}
// 군단장 Enum
public enum CommandersName: String {
    case val = "발탄"
    case via = "비아키스"
    case kk = "쿠크세이튼"
    case abr = "아브렐슈드"
    case il = "일리아칸"
}

public enum CommandersMode: String {
    case normarl = "노말"
    case hard = "하드"
}

class Commander: EmbeddedObject {
    @Persisted private var privateName: String
    var name: CommandersName { // 이름
        get { return CommandersName(rawValue: privateName)! }
        set { privateName = newValue.rawValue }
    }
    @Persisted private var privateCommanderMode: String
    var mode: CommandersMode { // 노말, 하드
        get { return CommandersMode(rawValue: privateCommanderMode)! }
        set { privateCommanderMode = newValue.rawValue }
    }
    @Persisted var step: Int = 0 // 관문
    @Persisted var isClear: Bool = false
    @Persisted var clearDate: Date?
    
    convenience init(name: CommandersName, mode: CommandersMode, step: Int, isClear: Bool, clearDate: Date? = nil) {
        self.init()
        self.name = name
        self.mode = mode
        self.name = name
        self.mode = mode
        self.step = step
        self.isClear = isClear
        self.clearDate = clearDate
    }
}
