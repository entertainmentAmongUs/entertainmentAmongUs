package com.entertainment.user.controller;

import com.entertainment.user.service.SessionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;

@RestController
public class SessionController {

    @Autowired
    private SessionService sessionService;

    String s;

    @PostMapping(value = "/getRedisStringValue")
    public ResponseEntity getRedisStringValue(String key) {
        String s = sessionService.getRedisStringValue(key);
        //String s;
        //s = "{\"code\": \"200\", \"key\": \""+key+"세션ID\", \"sessionId\": \""+httpSession.getId()+"\"}";

        return ResponseEntity.status(HttpStatus.OK).body(s);
    }

    @PostMapping(value = "/setRedisStringValue")
    public ResponseEntity setRedisStringValue(String key, String value) {

        String s = sessionService.setRedisStringValue(key, value);
        return ResponseEntity.status(HttpStatus.OK).body(s);
    }


    @GetMapping("/getSessionId")
    public ResponseEntity getSessionId(HttpSession httpSession){
        //s = "{\"code\": \"200\", \"message\": \"세션ID\", \"sessionId\": \""+httpSession.getId()+"\"}";
        s = sessionService.getSessionId(httpSession);
        return ResponseEntity.status(HttpStatus.OK).body(s);
    }
}
