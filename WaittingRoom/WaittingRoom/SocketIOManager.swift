//
//  SocketIOManager.swift
//  SocketExample
//
//  Created by 김윤수 on 2022/03/26.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
//    var manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!)
    var manager = SocketManager(socketURL: URL(string: "ws://13.209.69.156:8080")!, config: [
        .log(true),
        .forceWebsockets(true)
      ])
    
    var socket: SocketIOClient!
    
    func establishConnection(userId: Int, nickName: String) {
        
        // 웹소켓 서버에 연결 시도
        socket.connect()
        
        // 연결 완료되면 서버로 내 정보를 담은 login 이벤트 발송
        socket.on("connect") { [unowned self] _,_ in
            
            let userData: [String:Any] = ["userId":userId, "nickName":nickName]
            
            socket.emit("login", userData)
            
        }
        
    }
    
    func closeConnection() {
        
        socket.disconnect()
        
    }
    
    func getRoomList(completionHandler: @escaping (_ roomList: [Room]) -> Void) {
        
        socket.on("roomList") { dataArray, ack in
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]){
                if let rooms = try? JSONDecoder().decode([Room].self, from: jsonData) {
                    
                    completionHandler(rooms)
                    
                }
            }
            
        }
        
    }
    
    func getLobbyChatting() {
        
        
        socket.on("newLobbyChatMessage") { dataArray, ack in
            
            
            NotificationCenter.default.post(name: Notification.Name("newLobbyChatMessageNotification"), object: dataArray[0] as! [String: String])
            
        }
        
    }
    
    func getConnectedUserList() {
        
        
        socket.on("connectedUserList") { dataArray, ack in
            
            NotificationCenter.default.post(name: Notification.Name("getConnectedUserListNotification"), object: dataArray[0] as! [[String: Any]])
            
        }
        
    }
    
    
    func sendMessage(message: String, nickname: String){
        
        let chatData: [String: String] = ["nickName": nickname, "message": message]
        
        socket.emit("lobbyChatMessage", chatData)
        
    }
    
    
    func createRoom(room: [String:Any]) {
        
        var newRoom = room
        socket.emit("createRoom", newRoom)
        
        socket.on("newRoom") { dataArray, ack in
            
            newRoom["id"] = dataArray[0] as! String
            newRoom["userCount"] = 1
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: newRoom){
                if let roomData = try? JSONDecoder().decode(Room.self, from: jsonData) {
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "enterCreatedRoomNotification"), object: roomData)
                    
                }
            }
        }
        
    }
    
    func joinRoom(roomId: String, completionHanlder: @escaping (_ userList: [[String:Any]])->Void) {
        
        let newData: [String:String] = ["roomId":roomId]
        
        socket.emit("joinRoom", newData)
        
        socket.on("userList") { dataArray, ack in
            
            completionHanlder(dataArray[0] as! [[String:Any]])
            
        }
        
    }
    
    func leaveRoom(){
        
        socket.emit("leaveRoom")
        
        
    }
    
    func getReady(userId: Int){
        
        socket.emit("getReady", userId)
        
    }
    
    override private init(){
        super.init()
        
        socket = self.manager.socket(forNamespace: "/")
        
        
    }
    
    
    
    
}
