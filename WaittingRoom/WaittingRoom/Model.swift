//
//  Model.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/02/19.
//

import Foundation
import UIKit

struct Profile {
    
    var id: Int?
    var image: UIImage?
    var nickname: String
    var score: Int
    var victoryRate: Double {
        return Double(100*winCount/(loseCount+winCount))
    }
    var winCount: Int
    var loseCount: Int
}

struct Chat {
    
    let nickname: String
    let message: String
}

var dummy: [Profile] = [
    Profile(id: 1, image: UIImage(named: "ic_user_loading"), nickname: "내가라이어", score: 1000, winCount: 12, loseCount: 15),
    Profile(id: 2, image: UIImage(named: "ic_user_loading"), nickname: "김깝심", score: 1500, winCount: 67, loseCount: 52),
    Profile(id: 3, image: UIImage(named: "ic_user_loading"), nickname: "초보입니다", score: 380, winCount: 32, loseCount: 50),
    Profile(id: 4, image: UIImage(named: "ic_user_loading"), nickname: "이거재밌는맛이네", score: 777, winCount: 653, loseCount: 581),
    Profile(id: 5, image: UIImage(named: "ic_user_loading"), nickname: "트롤러", score: 32, winCount: 2, loseCount: 410),
    Profile(id: 6, image: UIImage(named: "ic_user_loading"), nickname: "랭킹1위", score: 5612, winCount: 910, loseCount: 421),
    Profile(id: 7, image: UIImage(named: "ic_user_loading"), nickname: "거짓말못하는사람", score: 415, winCount: 172, loseCount: 811),
    Profile(id: 8, image: UIImage(named: "ic_user_loading"), nickname: "수현아사랑해", score: 2273, winCount: 347, loseCount: 539)
]

var chattings: [Chat] = [Chat(nickname: "김깝심", message: "레디하세요"),
                         Chat(nickname: "초보입니다", message: "이거 재밌나요?"),
                         Chat(nickname: "랭킹1위", message: "할거없음 개노잼"),
                         Chat(nickname: "거짓말못하는사람", message: "ㄹㄷㄹㄷㄹㄷㄹㄷ"),
                         Chat(nickname: "김깝심", message: "레디하세요 다들"),
                         Chat(nickname: "수현아사랑해", message: "미워도 사랑한다"),
                         Chat(nickname: "트롤러", message: "이번판 제가 라이어임 ㅋㅋㅋㅋㅋㅋㅋ")]
