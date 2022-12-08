//
//  UserData.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation

public struct UserData {
    var 캐릭터별숙제들: [캐릭터별숙제]
    var 언제마지막접속: Date
}

public struct 캐릭터별숙제 {
    var 닉네임: String
    var 직업: String
    var 레벨: String
    var 서버: String
    var 군단장숙제: 군단장숙제
    var 일일숙제: 일일숙제
}

public struct 일일숙제 {
    var 카오스던전숙제: 카오스던전
    var 에포나숙제: 에포나
}

public struct 카오스던전 {
    var 휴게: Int // max 100, min 0 매일 안돌면 20, 오늘돌았니.count == 1 -> +10, 오늘돌았니.count == 2 -> +0, 오늘돌았니.count ==0 -> +20
    var 오늘돌았니: [Bool] // [false, false] [true, false] [true, true] -> true가 하나면 -20, true가 두개면 -40
    var 언제돌았니: Date?
}

public struct 에포나 {
    var 휴게: Int
    var 오늘했니: [Bool]
    var 언제돌았니: Date?
}

public struct 가디언토벌 {
    var 휴게: Int
    var 오늘했니: [Bool]
    var 언제돌았니: Date?
}

public struct 군단장숙제 {
    var 돈군단장: Int // 0, 1, 2
    var 군단장들: [군단장] // 군단장들[0] -> 군단장(이름: 발탄, 돌았니, 2022-121310)
}

public enum 궁당장 {
    case val
    case via
    case kk
    case abr
    case il
}

public struct 군단장 {
    var 이름: 궁당장
    var 돌았니: Bool
    var 언제돌았니: Date?
}
