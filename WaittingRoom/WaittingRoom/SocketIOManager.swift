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
    
    var manager = SocketManager(socketURL: URL(string: "ws://13.209.69.156:8080")!, config: [
        .log(true),
        .forceWebsockets(true)
      ])
    
    var socket: SocketIOClient!
    
    func establishConnection(userId: Int, nickName: String) {
        
        // 웹소켓 서버에 연결 시도
        socket.connect()
        
        // 연결이 완료되면 로비에 참여했다고 알림
        socket.on("connect") {  [unowned self] _, _ in
            
            let userData: [String:Any] = ["userId":userId, "nickName":nickName]
            
            self.socket.emit("joinLobby", userData)
            
        }
        
    }
    
    func closeConnection() {
        
        socket.disconnect()
        
    }
    
    func refreshRoomList() {
        
        socket.emit("roomList")
        
    }
    
    func fetchRoomList(completionHandler: @escaping (_ roomList: [Room]) -> Void) {
        
        socket.on("roomList") { dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return
            }
            guard let roomList = try? JSONDecoder().decode(RoomList.self, from: jsonData) else {
                return
            }
            
            completionHandler(roomList.roomList)
            
        }
        
    }
    
    func fetchLobbyChatting() {
        
        
        socket.on("chat") { dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return
            }
            guard let chat = try? JSONDecoder().decode(Chat.self, from: jsonData) else {
                return
            }
            
            NotificationCenter.default.post(name: Notification.Name("newChatNotification"), object: chat)
        }
        
    }
    
    func fetchLobbyUserList() {
        
        
        socket.on("lobbyUserList") { dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return
            }
            guard let userList = try? JSONDecoder().decode(UserList.self, from: jsonData) else {
                return
            }
            
            NotificationCenter.default.post(name: Notification.Name("getLobbyUserListNotification"), object: userList.users)
        }
        
    }
    
    func fetchRoomInfo(roomId: String, completionHandler: @escaping (_ roomInfo: Room) -> Void) {
        
        let roomData:[String:String] = ["roomId":roomId]
        
        socket.emit("roomInfo", roomData)
        
        socket.on("roomInfo") { dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return
            }
            guard let roomInfo = try? JSONDecoder().decode(Room.self, from: jsonData) else {
                return
            }
            
            completionHandler(roomInfo)
        }
    
    }
    
    func fetchUserList(completionHandler: @escaping (_ userList: [UserInRoom]) -> Void) {
        
        socket.on("userList") { dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return
            }
            guard let userList = try? JSONDecoder().decode([UserInRoom].self, from: jsonData) else {
                return
            }
            
            completionHandler(userList)
        }
    
    }
    
    
    func sendMessage(roomId: String, message: String, nickname: String){
        
        let chatData: [String: String] = ["nickName": nickname, "message": message, "roomId": roomId]
        
        socket.emit("chat", chatData)
        
    }
    
    
    func createRoom(room: [String:Any]) {
        
        socket.emit("createRoom", room)
        
        socket.on("createRoom") { [unowned self] dataArray, ack in
            
            let roomId = (dataArray[0] as! [String:Any])["roomId"]
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "enterCreatedRoomNotification"), object: roomId)
                    
            self.socket.off("createRoom")
        }
        
    }
    
    func joinRoom(roomId: String, userId: Int, password:String?, completionHandler: @escaping (_ status: JoinStatus) -> Void) {
        
        let joinData: [String:Any] = ["roomId":roomId, "userId":userId, "password":password as Any]
        
        socket.emit("joinRoom", joinData)
        
        socket.on("joinRoom") { dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return }
            
            guard let status = try? JSONDecoder().decode(JoinRoom.self, from: jsonData) else { return }
            
            completionHandler(status.status)
            
            self.socket.off("joinRoom")
        }
        
    }
    
    func leaveRoom(roomId:String, userId: Int){
        
        let newData: [String: Any] = ["roomId":roomId, "userId": userId]
        
        socket.off("roomInfo")
        
        socket.off("kick")
        
        socket.off("startGame")
        
        socket.emit("leaveRoom", newData)
        
        
    }
    
    func getReady(roomId:String, userId: Int){
        
        let readyData: [String: Any] = ["roomId":roomId, "userId":userId]
        
        socket.emit("getReady", readyData)
        
    }
    
    func kick(roomId:String, userId: Int) {
        
        let kickData: [String: Any] = ["roomId":roomId,"userId": userId]
        
        socket.emit("kick", kickData)
        
    }
    
    func getKicked(completionHandler: @escaping (_ userId: Int) -> Void){
        
        socket.on("kick") { dataArray, ack in
            
            let userId = (dataArray[0] as! [String:Any])["userId"] as! Int
            
            completionHandler(userId)
            
        }
        
    }
    
    
    func editRoom(room: [String:Any], completionHandler: @escaping (_ status:EditStatus) -> Void) {
        
        socket.emit("editRoom", room)
        
        socket.on("editRoom") { [unowned self] dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return }
            
            guard let status = try? JSONDecoder().decode(EditRoom.self, from: jsonData) else { return }
            
            completionHandler(status.status)
            
            self.socket.off("editRoom")
        }
        
    }
    
    func startGame(completionHandler: @escaping (_ playingInfo: PlayingInfo) -> Void){
        
        socket.on("startGame") { dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return }
            
            guard let playingInfo = try? JSONDecoder().decode(PlayingInfo.self, from: jsonData) else { return }
            
            completionHandler(playingInfo)
            
            self.socket.off("startGame")
            
        }
        
    }
    
    func endAnnouncemnet(roomId: String, completionHandler: @escaping (_ playingTime: PlayingTime) -> Void) {
        
        let newData: [String: String] = ["roomId":roomId]
        
        self.socket.emit("loadingEnd", newData)
        
        self.socket.on("time") { dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return }
            
            guard let playingTime = try? JSONDecoder().decode(PlayingTime.self, from: jsonData) else { return }
            
            completionHandler(playingTime)
            
        }
        
    }
    
    override private init(){
        super.init()
        
        socket = self.manager.socket(forNamespace: "/")
        
        
    }
    
    
    
    
}
