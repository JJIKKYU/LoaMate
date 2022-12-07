//
//  CharaterInfoModel.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation

public struct CharacterInfoModel: Decodable {
    let ServerName: String
    let CharacterName: String
    let CharacterLevel: Int
    let CharacterClassName: String
    let ItemAvgLevel: String
    let ItemMaxLevel: String
}
