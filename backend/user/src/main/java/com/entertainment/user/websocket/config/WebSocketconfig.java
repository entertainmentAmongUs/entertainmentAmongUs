//package com.entertainment.user.websocket.config;
//
//import org.springframework.context.annotation.Configuration;
//import org.springframework.messaging.simp.config.MessageBrokerRegistry;
//import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
//import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
//import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
//
//@Configuration
//@EnableWebSocketMessageBroker
//public class WebSocketconfig implements WebSocketMessageBrokerConfigurer {
//
//    @Override
//    public void configureMessageBroker(MessageBrokerRegistry registry){
//        registry.enableSimpleBroker("/topic/"); //메모리 기반 메세지 브로커가 해당 apu 구독하고 있는 클라이언트에게 메세지 전달
//        registry.setApplicationDestinationPrefixes("/app"); //서버에서 클라이언트로부터이ㅡ 메세지를 받을 ㅁpi의 prefix
//    }
//
//    public void registerStompEndPoints(StompEndpointRegistry registry){
//        registry.addEndpoint("/websockethandler").withSockJS(); //여러가지 End Point 설정
//    }
//}
