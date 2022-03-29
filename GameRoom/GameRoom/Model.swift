//
//  Model.swift
//  GameRoom
//
//  Created by 김윤수 on 2022/03/05.
//

import Foundation
import UIKit

/* 유저의 프로필 정보 */
struct Profile {
    
    var userID: Int?
    var image: UIImage?
    var nickname: String
    var score: Int
    var victoryRate: Double {
        return Double(100*winCount/(loseCount+winCount))
    }
    var winCount: Int
    var loseCount: Int
}

/* 채팅 정보 */
struct Chat {
    
    let nickname: String
    let message: String
}

/* 게임 진행에 필요한 데이터 */
struct Process {
    
    let playerOrder: [Int]
    let liarID: Int
    let keyword: String
}

/* 나의 프로필 정보*/
var myProfile = Profile(userID: 99, image: UIImage(named: "ic_user_loading"), nickname: "초보입니다", score: 380, winCount: 32, loseCount: 50)


var players: [Profile] = [
    Profile(userID: 15, image: UIImage(named: "ic_user_loading"), nickname: "내가라이어", score: 1000, winCount: 12, loseCount: 15),
    Profile(userID: 51, image: UIImage(named: "ic_user_loading"), nickname: "김깝심", score: 1500, winCount: 67, loseCount: 52),
    Profile(userID: 99, image: UIImage(named: "ic_user_loading"), nickname: "초보입니다", score: 380, winCount: 32, loseCount: 50),
    Profile(userID: 114, image: UIImage(named: "ic_user_loading"), nickname: "이거재밌는맛이네", score: 777, winCount: 653, loseCount: 581),
    Profile(userID: 13, image: UIImage(named: "ic_user_loading"), nickname: "트롤러", score: 32, winCount: 2, loseCount: 410),
    Profile(userID: 43, image: UIImage(named: "ic_user_loading"), nickname: "랭킹1위", score: 5612, winCount: 910, loseCount: 421),
    Profile(userID: 27, image: UIImage(named: "ic_user_loading"), nickname: "거짓말못하는사람", score: 415, winCount: 172, loseCount: 811),
    Profile(userID: 8, image: UIImage(named: "ic_user_loading"), nickname: "수현아사랑해", score: 2273, winCount: 347, loseCount: 539)
]

var chattings: [Chat] = []

let process = Process(playerOrder: [2,1,5,3,0,4,7,6], liarID: 27, keyword: "유재석")

var sections: [String] = []

var vote:[Int:Int] = [15:0, 51:0, 99:0, 114:0, 13:0, 43:0, 27:0, 8:0]
