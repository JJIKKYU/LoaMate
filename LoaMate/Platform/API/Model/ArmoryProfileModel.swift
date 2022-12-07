//
//  ArmoryProfile.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation

struct ArmoryProfileModel: Codable {
    let CharacterImage: String
    let ExpeditionLevel: Int
    let PvpGradeName: String
    let TownLevel: Int
    let TownName: String
    let Title: String
    let GuildMemberGrade: String
    let GuildName: String
    let Stats: [StatsModel]
    let Tendencies: [TendencyModel]
    let ServerName: String
    let CharacterName: String
    let CharacterLevel: Int
    let CharacterClassName: String
    let ItemAvgLevel: String
    let ItemMaxLevel: String
}

class StatsModel: Codable {
    let `Type`: String
    let Value: String
    let Tooltip: [String]
}

class TendencyModel: Codable {
    let `Type`: String
    let Point: Int
    let MaxPoint: Int
}
