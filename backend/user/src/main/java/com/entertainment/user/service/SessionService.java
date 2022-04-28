package com.entertainment.user.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;

@Service
public class SessionService {

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    public String getRedisStringValue(String key) {
        ValueOperations<String, String> stringValueOperations = stringRedisTemplate.opsForValue();
        String s = "{\"key\" : \"" + key + "\", \"value\" : \"" + stringValueOperations.get(key) + "\"}";
        return s;
        //System.out.println("Redis key : " + key);
        //System.out.println("Redis value : " + stringValueOperations.get(key));

    }

    public String setRedisStringValue(String key, String value) {
        ValueOperations<String, String> stringValueOperations = stringRedisTemplate.opsForValue();
        stringValueOperations.set(key, value);
        String s = "{\"key\" : \"" + key + "\", \"value\" : \"" + stringValueOperations.get(key) + "\"}";
        return s;
//        System.out.println("Redis key : " + key);
//        System.out.println("Redis value : " + stringValueOperations.get(key));
    }

    public String getSessionId(HttpSession httpSession) {
        String s = "{\"code\": \"200\", \"message\": \"세션ID\", \"sessionId\": \""+httpSession.getId()+"\"}";

        return s;
    }

    public String deleteSessionId(String email, HttpSession httpSession) {
        stringRedisTemplate.delete(email);
        String s = "{\"code\": \"200\", \"message\": \"세션ID\", \"sessionId\": \""+httpSession.getId()+"\"}";

        return s;
    }
}
