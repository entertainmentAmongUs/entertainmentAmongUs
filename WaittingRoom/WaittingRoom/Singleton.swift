//
//  Singleton.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/05/04.
//

import Foundation

class Singleton: NSObject {
    
    static let shared = Singleton()
    
    var userId = -1
    var nickName = ""
    
    var connectedUserList: [[String:Any]] = []
    var lobbyChattings: [[String:String]] = []
    var roomList: [[String:Any]] = []
    
    func readyToGetLobbyData(){
        
        
        
    }
    
    override init() {
        super.init()
    }
    
    
}
