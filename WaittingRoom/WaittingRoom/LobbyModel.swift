//
//  LobbyModel.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/05/02.
//

import Foundation
import UIKit


struct lobbyRoom {
    
    let gametype: String
    let roomname: String
    let password: String
    let roompersonNum: String
    
}

var roomList: [lobbyRoom] = [lobbyRoom(gametype: "라이어",roomname: "제목이아주길게써지면어떻게될까과연??누가누가이길까과연알아맞춰봅시다",password: "1번방이다", roompersonNum:"3명"),
                             lobbyRoom(gametype: "이미지",roomname: "낙현들어와", password: "2번방이다" ,roompersonNum: "7명"),
                             lobbyRoom(gametype: "라이어",roomname: "나보다잘해?", password: "" ,roompersonNum: "5명")]
