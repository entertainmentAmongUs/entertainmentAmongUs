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
    
    func establishConnection() {
        
        socket.connect()
        
    }
    
    func closeConnection() {
        
        socket.disconnect()
        
    }
    
    func sendMessage(message: String, nickname: String){
        
//        socket.emit("chatMessage", nickname, message)
        let chatData: [String: Any] = ["nickName": nickname, "message": message]
        socket.emit("lobbyChatMessage", chatData)
        
    }
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: Any]) -> Void) {
        
        /*
        socket.on("newChatMessage") { dataArray, ack in
            var messageDictionary = [String: Any]()
            messageDictionary["nickname"] = dataArray[0] as! String
            messageDictionary["message"] = dataArray[1] as! String
            messageDictionary["date"] = dataArray[2] as! String
            
            completionHandler(messageDictionary)
        }
        */
        
        socket.on("newLobbyChatMessage") { dataArray, ack in
            print("새로운 메세지 확인")
            
            var messageDictionary = [String: Any]()
            let newData = dataArray[0] as! [String:Any]
            messageDictionary["nickname"] = newData["nickName"] as! String
            messageDictionary["message"] = newData["message"] as! String
            messageDictionary["date"] = "알아서 뭐하게?"
            
            completionHandler(messageDictionary)
        }
        
    }
    
    private func listenForOtherMessage() {
        
        socket.on("userConnectUpdate") { dataArray, ack in
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
            
        }
        
        socket.on("userExitUpdate") { dataArray, ack in
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
            
        }
        
        socket.on("userTypingUpdate") { dataArray, ack in
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
            
        }
    }
    
    func connectToServerWithNickName(nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]) -> Void) {
        
//        socket.emit("connectUser", nickname)
        let data: [String: Any] = ["userId": 150, "nickName": nickname]
        socket.emit("login", data)
        
//        socket.emit("join", "room1")
        
        /*
        socket.on("userList") { dataArray, ack in
            completionHandler(dataArray[0] as! [[String: AnyObject]])
        }
        */
        
        socket.on("connectedUserList") { dataArray, ack in
//            let userList: [[String:Any]] = dataArray[0] as! [[String:Any]]
//            print(userList[0]["nickName"])
            print("connectedUserList")
        }
        
        socket.on("roomList") { dataArray, ack in
            print("roomList")
        }
        
//        listenForOtherMessage()
        
    }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        
        socket.emit("exitUser", nickname)
        completionHandler()
        
    }
    
    func sendStartTypingMessage(nickname: String) {
        
        socket.emit("startType", nickname)
        
    }
    
    func sendStopTypingMessage(nickname: String) {
        
        socket.emit("stopType", nickname)
        
    }
    
    func createRoom(roomTitle: String, password: String?, gameType: Int, subject: String, maxUser: Int) {
        
        var newData: [String: Any] = ["title":roomTitle, "password":password, "gameType":gameType, "subject":subject, "maxUser": 6]
        
        socket.emit("createRoom", newData)
        
        socket.on("newRoom") { dataArray, ack in
            
            newData["roomId"] = dataArray[0] as! String
            NotificationCenter.default.post(name: Notification.Name(rawValue: "newRoomNotification"), object: newData as? [String: AnyObject])
            
        }
        
    }
    
    func joinRoom(roomId: String) {
        
        let newData: [String:String] = ["roomId":roomId]
        
        socket.emit("joinRoom", newData)
        
    }
    
    func getReady(userId: Int){
        
        socket.emit("getReady", userId)
        
    }
    
    override init(){
        super.init()
        
        socket = self.manager.socket(forNamespace: "/")
        
        
//        socket.emit("join", "room1")
        
        
    }
    
    
    
    
}
