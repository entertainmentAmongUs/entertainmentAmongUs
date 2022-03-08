//
//  Model.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/02/19.
//

import Foundation
import UIKit

/* 친구 */
struct Friend {
    
    let friendID: Int
    let nickname: String
    
}

/* 게임 타입(라이어, 이미지)에 대한 정보 */
struct Game {
    
    let gameId: Int
    let title: String
    let info: String
    let maxUserNumber: Int
    
}

/* 주제 카테고리 (depth2) */
struct Category {
    var categoryID: Int
    var subjectID: Int
}

/* 주제 (depth1) */
struct Subject {
    let title: String
    let category: [String]
}

/* 게임방에 대한 정보 */
struct Room {
    
    let roomID: Int
    var gameType: Int
    var password: String?
    var category: Category
    var maxUserNumber: Int
    var masterUserID: Int
    var users: [Profile]
    var roomTitle: String
    
}

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

struct Chat {
    
    let nickname: String
    let message: String
}

/* 친구 요청 상태에 대한 정보 */
struct FriendRequest {
    
    let senderID: Int
    let responderID: Int
    
    /* 0: 결정되지 않음, 1: 수락함, 2: 거절함 */
    let status: Int
    
}

/* 설정 가능한 게임 목록 */
let games = [Game(gameId: 0, title: "라이어 게임", info: "거짓말하는 사람을 찾아내는 게임입니다.", maxUserNumber: 8), Game(gameId: 1, title: "이미지 게임", info: "이미지를 보고 무엇인지 맞추는 게임입니다.", maxUserNumber: 6)]

/* 설정 가능한 주제 카테고리 목록 */
let subjects = [Subject(title: "인물", category: ["배우", "가수", "유명인사", "아이돌"]), Subject(title: "문화", category: ["음악", "영화"])]

/* 나의 프로필 정보*/
var myProfile = Profile(userID: 99, image: UIImage(named: "ic_user_loading"), nickname: "초보입니다", score: 380, winCount: 32, loseCount: 50)

/* 대기방에 존재하는 유저들의 프로필 */
var profiles: [Profile] = [
    Profile(userID: 15, image: UIImage(named: "ic_user_loading"), nickname: "내가라이어", score: 1000, winCount: 12, loseCount: 15),
    Profile(userID: 51, image: UIImage(named: "ic_user_loading"), nickname: "김깝심", score: 1500, winCount: 67, loseCount: 52),
    Profile(userID: 99, image: UIImage(named: "ic_user_loading"), nickname: "초보입니다", score: 380, winCount: 32, loseCount: 50),
    Profile(userID: 114, image: UIImage(named: "ic_user_loading"), nickname: "이거재밌는맛이네", score: 777, winCount: 653, loseCount: 581),
    Profile(userID: 13, image: UIImage(named: "ic_user_loading"), nickname: "트롤러", score: 32, winCount: 2, loseCount: 410),
    Profile(userID: 43, image: UIImage(named: "ic_user_loading"), nickname: "랭킹1위", score: 5612, winCount: 910, loseCount: 421),
    Profile(userID: 27, image: UIImage(named: "ic_user_loading"), nickname: "거짓말못하는사람", score: 415, winCount: 172, loseCount: 811),
    Profile(userID: 8, image: UIImage(named: "ic_user_loading"), nickname: "수현아사랑해", score: 2273, winCount: 347, loseCount: 539)
]


/* 나의 친구 목록 */
var myFriends: [Friend] = [
    Friend(friendID: 51, nickname: "김깝심"),
    Friend(friendID: 13, nickname: "트롤러"),
    Friend(friendID: 43, nickname: "랭킹1위"),
    Friend(friendID: 8, nickname: "수현아사랑해"),
]

/* 나의 친구 요청 목록 */
var myFriendRequest: [FriendRequest] = []

/* 현재 대기중인 방 정보 */
var Myroom = Room(roomID: 100, gameType: 0, password: nil, category: Category(categoryID: 1, subjectID: 1), maxUserNumber: 6, masterUserID: 99, users: profiles, roomTitle: "즐겜합시다~")

/* 방에서 입력된 채팅 데이터 */
var chattings: [Chat] = [Chat(nickname: "김깝심", message: "레디하세요"),
                         Chat(nickname: "초보입니다", message: "이거 재밌나요?"),
                         Chat(nickname: "랭킹1위", message: "할거없음 개노잼"),
                         Chat(nickname: "거짓말못하는사람", message: "ㄹㄷㄹㄷㄹㄷㄹㄷ"),
                         Chat(nickname: "김깝심", message: "레디하세요 다들"),
                         Chat(nickname: "수현아사랑해", message: "미워도 사랑한다"),
                         Chat(nickname: "트롤러", message: "이번판 제가 라이어임 ㅋㅋㅋㅋㅋㅋㅋ")]
