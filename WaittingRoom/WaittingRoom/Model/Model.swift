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
    
    let type: GameType
    let title: String
    let info: String
    let maxUserNumber: Int
    
}

enum GameType: String, Codable {
    
    case liar = "LIAR"
    case image = "IMAGE"
    
}

enum RoomStatus: String, Codable {
    
    case waiting = "WAITING"
    case playing = "PLAYING"
}

enum JoinStatus: String, Codable {
    
    case success = "SUCCESS"
    case passwordIncorrect = "PASSWORD_INCORRECT"
    case fullUser = "FULL_USER"
    case alreadyStarted = "ALREADY_STARTED"
    case unexist = "UN_EXIST"
}

enum EditStatus: String, Codable {
    
    case success = "SUCCESS"
    case overCount = "OVER_COUNT"
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

struct RoomList: Codable {
    
    var roomList: [Room]
    
}

struct UserList: Codable {
    
    var users: [User]
    
}


struct JoinRoom: Codable{
    
    var status: JoinStatus
}

struct EditRoom: Codable{
    
    var status: EditStatus
}

struct UserInRoom: Codable {
    
    var isReady: Bool
    var nickName: String
    var userId: Int
//    var socketId: String
    
}

struct RoomUserList: Codable {
    
    var userList: [UserInRoom]
    
}

/* 게임방에 대한 정보 */
struct Room: Codable {
    
    var roomId: String
    var maxUser: Int
    var title: String
    var password: String?
    var users: [UserInRoom]
    var gameType: GameType
    var subject: String
    var hostId: Int
    var status: RoomStatus
    
}

struct User: Codable {
    
    var userId: Int
    var nickName: String
    
}

struct Chat: Codable {
    
    let roomId: String
    let nickName: String
    let message: String
}

struct PlayingInfo: Codable {
    
    var keyword: String
    var order: [Int]
    var liarNumber: Int
    
}

struct PlayingTime: Codable {
    
    var time: Int
    var order: Int
    
}


/* 유저의 프로필 정보 */
struct Profile {
    
    var userID: Int
    var image: UIImage?
    var nickname: String
    var score: Int
    var victoryRate: Double {
        return Double(100*winCount/(loseCount+winCount))
    }
    var winCount: Int
    var loseCount: Int
}



/* 친구 요청 상태에 대한 정보 */
struct FriendRequest {
    
    let senderID: Int
    let responderID: Int
    
    /* 0: 결정되지 않음, 1: 수락함, 2: 거절함 */
    let status: Int
    
}

/* 설정 가능한 게임 목록 */
let games = [Game(type: .liar, title: "라이어", info: "거짓말하는 사람을 찾아내는 게임입니다.", maxUserNumber: 8), Game(type: .image, title: "이미지", info: "이미지를 보고 무엇인지 맞추는 게임입니다.", maxUserNumber: 6)]

/* 설정 가능한 주제 카테고리 목록 */
let subjects = [Subject(title: "국가", category: ["아시아", "유럽", "아메리카"]), Subject(title: "랜드마크", category: ["해외", "국내"])]

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
/*
var Myroom = Room(roomID: "roomExample", gameType: .liar, password: nil, category: Category(categoryID: 1, subjectID: 1), maxUserNumber: 6, masterUserID: 99, users: profiles, roomTitle: "즐겜합시다~")
 */

/* 방에서 입력된 채팅 데이터 */
