//
//  LostarkAPI.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation
import Moya

enum LostarkAPI {
    case characters(characterName: String)
    case profiles(characterName: String)
}

extension LostarkAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://developer-lostark.game.onstove.com") ?? URL(fileURLWithPath: "") as URL
    }
    
    var path: String {
        switch self {
        case .characters(let characterName):
            return "/characters/\(characterName)/siblings"
        case .profiles(let characterName):
            return "/armories/characters/\(characterName)/profiles"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .characters, .profiles:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .characters, .profiles:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "accept" : "application/json",
            "authorization" : "bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyIsImtpZCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyJ9.eyJpc3MiOiJodHRwczovL2x1ZHkuZ2FtZS5vbnN0b3ZlLmNvbSIsImF1ZCI6Imh0dHBzOi8vbHVkeS5nYW1lLm9uc3RvdmUuY29tL3Jlc291cmNlcyIsImNsaWVudF9pZCI6IjEwMDAwMDAwMDAwMDA2MDAifQ.BWFnezSXu3eHRCrp_0rrneF4GbWeHgX9T_zkABffk8xKTmHgKW4lHqh19-6uwscqkfC-F-8ku30j9IPdN8Bh2F_XbHpaTapVtQmSqJsIGbED1FdDArEpXo_CiREKUbKqygZvSJDbVSuGUBJTvtsP3yOVXFgNK_UvKXCRLHTyPh_aGH6MPRKuJLON1nkGP4KIYs21WoR0MkZ2lIl9Ov_ldeiahUiV352Zo7wniFFc0h06_P4nt8Jh_AzPvLLHYAa9wvRhkn9aXjaPW8xnirXfNAq6ghLPa1t4ukqWpvUgxVrxDjOz8f0brgIqE-PHKRuxYeTEzPoZwUaj4DiuYk9m7A"
        ]
    }
    
    
}
