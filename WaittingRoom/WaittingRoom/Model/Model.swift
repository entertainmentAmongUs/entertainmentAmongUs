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

enum PlayStatus: String, Codable {
    
    case ready = "READY"
    case hint = "HINT"
    case freeChat = "FREE_CHAT"
    case vote = "VOTE"
}

enum VoteStatus: String, Codable {
    
    case voteEnd = "VOTE_END"
    case reVote = "RE_VOTE"
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

struct GameChat: Codable {
    
    var roomId: String
    var nickName: String
    var status: PlayStatus
    var message: String
    
}

struct PlayingInfo: Codable {
    
    var keyword: String
    var order: [Int]
    var liarNumber: Int
    
}

struct TickTok: Codable {
    
    var time: Int
    var status: PlayStatus
    var order: Int
    
}

struct VotedPlayer: Codable {
    
    var userId: Int
    var count: Int
}

struct VoteResult: Codable {
    
    var status: VoteStatus
    var result: [VotedPlayer]
    
}

struct Outcome: Codable {
    
    var isVictory: Bool
    var userId: Int
    
}

/* 유저의 프로필 정보 */
struct Profile: Codable {
    
    var userId: Int
    var profileId: Int
    var nickName: String
    var score: Int
    var winCount: Int
    var loseCount: Int
    var victoryRate: Double {
        if winCount + loseCount == 0 {
            return 0
        }
        return Double(100*winCount/(loseCount+winCount))
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case profileId = "id"
        case nickName = "nickname"
        case winCount = "win_number"
        case loseCount = "lose_number"
        case score
    }
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


/* 나의 친구 요청 목록 */
var myFriendRequest: [FriendRequest] = []

let baseURL = "http://52.78.47.148:8080/"
