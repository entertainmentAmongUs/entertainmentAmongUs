//
//  Room.swift
//  withoutStroyBoard_Entertainment_AmongUs
//
//  Created by 남궁광 on 2022/03/31.
//

import Foundation
import UIKit


struct Room {
    let gametype: String
    let roomname: String
    let password: String
    let roompersonNum: String
}

var roomList: [Room] = [Room(gametype: "라이어 게임",roomname: "1번방입니다",password: "1번방이다", roompersonNum:"3명"),
                        Room(gametype: "이미지 게임",roomname: "낙현들어와", password: "2번방이다" ,roompersonNum: "7명"),
                        Room(gametype: "라이어 게임",roomname: "나보다잘해?", password: "" ,roompersonNum: "5명")]
