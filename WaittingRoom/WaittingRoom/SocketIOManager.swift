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
        //.log(true),
        .forceWebsockets(true),
        .reconnects(true)
      ])
    
    var socket: SocketIOClient!
    
    
    // MARK: - Connection Method
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
    
    // MARK: - Lobby Method
    
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
    
    // MARK: - WaitingRoom Method
    
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
            
        }
        
    }
    
    // MARK: - PlayingRoom Method
    
    func endAnnouncemnet(roomId: String, completionHandler: @escaping (_ tickTok: TickTok) -> Void) {
        
        let newData: [String: String] = ["roomId":roomId]
        
        self.socket.emit("loadingEnd", newData)
        
        self.socket.on("time") { dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return }
            
            guard let tickTok = try? JSONDecoder().decode(TickTok.self, from: jsonData) else { return }
            
            completionHandler(tickTok)
            
        }
        
    }
    
    func vote(roomId: String?, targetId: Int) {
        
        guard let roomId = roomId else { return }
        
        let voteData: [String: Any] = ["roomId" : roomId, "targetUserId" : targetId]
        
        socket.emit("vote", voteData)
        
    }
    
    
    func reVoting(completionHandler: @escaping (_ tickTok: TickTok) -> Void) {
        
        self.socket.on("reVoteTime") { dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return }
            
            guard let tickTok = try? JSONDecoder().decode(TickTok.self, from: jsonData) else { return }
            
            completionHandler(tickTok)
            
        }
        
        
    }
    
    
    func confirmVoting(completionHandler: @escaping (_ result: VoteResult) -> Void){
        
        self.socket.on("voteResult") { dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return }
            
            guard let voteResult = try? JSONDecoder().decode(VoteResult.self, from: jsonData) else { return }
            
            completionHandler(voteResult)
            
        }
        
    }
    
    func fetchGameChatting(completionHandler: @escaping (_ gameChat: GameChat) -> Void) {
        
        socket.on("gameChat") { dataArray, ack in
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dataArray[0]) else {
                return
            }
            guard let chat = try? JSONDecoder().decode(GameChat.self, from: jsonData) else {
                return
            }
            
            completionHandler(chat)
            
        }
        
    }
    
    func endGame(announce: UILabel?, completionHandler: @escaping () -> Void ){
        
        socket.on("endGame") { dataArray, ack in
            
            self.socket.off("time")
            
            self.socket.off("reVoteTime")
            
            self.socket.off("voteResult")
            
            self.socket.off("gameChat")
            
            self.socket.off("endGame")
            
            announce?.text = "5초 뒤 게임에서 나갑니다."
            
            let timer = Timer(timeInterval: TimeInterval(5), repeats: false) { timer in
                completionHandler()
            }
            
            RunLoop.main.add(timer, forMode: .common)
            
//            timer.fire()
            
        }
        
    }
    
    // MARK: - Chatting Method
    
    func sendMessage(roomId: String, message: String, nickname: String){
        
        let chatData: [String: String] = ["nickName": nickname, "message": message, "roomId": roomId]
        
        socket.emit("chat", chatData)
        
    }
    
    func sendGameMessage(status: String, roomId: String, message: String, nickname: String){
        
        let chatData: [String: String] = ["nickName": nickname, "message": message, "roomId": roomId, "status": status]
        
        socket.emit("gameChat", chatData)
        
    }
    
    // MARK: - Initialize
    
    override private init(){
        super.init()
        
        socket = self.manager.socket(forNamespace: "/")
        
        
    }
    
    
    
    
}
