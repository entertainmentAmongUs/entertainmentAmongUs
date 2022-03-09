//package com.entertainment.user.websocket.controller;
//
//import com.entertainment.user.websocket.entity.SocketVO;
//import org.springframework.messaging.handler.annotation.MessageMapping;
//import org.springframework.messaging.handler.annotation.SendTo;
//import org.springframework.web.bind.annotation.RestController;
//
//
//@RestController
//public class SocketController {
//
//    @MessageMapping("/hello")
//    @SendTo("/topic/roomId")
//    public SocketVO broadcasting(SocketVO message)throws Exception{
//        System.out.println("message: "+ message.getSendMessage());
//        return message;
//    }
//
//    @MessageMapping("/out")
//    @SendTo("/topic/out")
//    public String outroom(String message)throws Exception{
//        System.out.println("out message: "+ message);
//        return message;
//    }
//
//    @MessageMapping("/in")
//    @SendTo("/topic/in")
//    public String inroom(String message)throws Exception{
//        System.out.println("in message: "+ message);
//        return message;
//    }
//}
