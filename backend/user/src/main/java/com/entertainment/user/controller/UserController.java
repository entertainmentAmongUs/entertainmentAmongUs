package com.entertainment.user.controller;

import com.entertainment.user.request.LoginReq;
import com.entertainment.user.request.RegisterReq;
import com.entertainment.user.entity.User;
import com.entertainment.user.service.KakaoAPI;
import com.entertainment.user.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;

@Slf4j
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/signup")
    public ResponseEntity signUp(@RequestBody RegisterReq registerDto){
        log.info(String.valueOf(registerDto));
        String s;
        //email 중복 확인
        if(checkEmail(registerDto.getEmail())){
            s = "\"code\": \"SIGNUP_ERROR_100\", \"message\": \"이메일 중복\"";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }

        //nickname 중복 확인
        if(checkNickname(registerDto.getNickname())){
            s = "\"code\": \"SIGNUP_ERROR_101\", \"message\": \"닉네임 중복\"";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }

        //이메일 & 닉네임 중복 없을 때
        userService.registerUser(registerDto);
        s = "\"code\": \"200, SUCCESS\", \"message\": "+registerDto.getNickname()+"님 회원가입이 되었습니다.";
        return ResponseEntity.status(HttpStatus.OK).body(s);
    }

    @GetMapping("/checkEmail/{email}")
    public boolean checkEmail(@PathVariable String email){
        if(userService.doExistUserEmail(email)){
            return true;            //이메일 중복일 때
        }
        return false;               //이메일 중복 아닐 때
    }

    @GetMapping("/checkNickname/{nickname}")
    public boolean checkNickname(@PathVariable String nickname){
        if(userService.doExistUserNickname(nickname)){
            return true;            //닉네임 중복일 때
        }
        return false;               //닉네임 중복 아닐 때
    }

    @PutMapping("/login")
//    public ResponseEntity logIn(@RequestBody LoginReq loginDto){
    public boolean logIn(@RequestBody LoginReq loginDto){
        String s;

        //email과 password 일치 확인
        if(!userService.validateAccount(loginDto.getEmail(),loginDto.getPassword())){
//            s = "\"code\": \"LOGIN_ERROR_100\", \"message\": \"이메일과 비밀번호가 일치하지 않습니다.\"";
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            return false;
        }

//        User user = userService.getUserNicknameByUserEmail(loginDto.getEmail());
//        s = "\"님 환영합니다!\"";
//        return ResponseEntity.status(HttpStatus.OK).body(user.getNickname()+s);
        return true;
    }


    //kakao 소셜 로그인
    KakaoAPI kakaoApi = new KakaoAPI();

    @RequestMapping(value="/kakaologin")
    public ModelAndView login(@RequestParam("code") String code, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        // 1번 인증코드 요청 전달
        String accessToken = kakaoApi.getAccessToken(code);
        // 2번 인증코드로 토큰 전달
        HashMap<String, Object> userInfo = kakaoApi.getUserInfo(accessToken);

        System.out.println("login info : " + userInfo.toString());

        if(userInfo.get("email") != null) {
            session.setAttribute("userId", userInfo.get("email"));
            session.setAttribute("accessToken", accessToken);
        }
        mav.addObject("userId", userInfo.get("email"));
        mav.setViewName("index");
        return mav;
    }

    @RequestMapping(value="/kakaologout")
    public ModelAndView logout(HttpSession session) {
        ModelAndView mav = new ModelAndView();

        kakaoApi.kakaoLogout((String)session.getAttribute("accessToken"));
        session.removeAttribute("accessToken");
        session.removeAttribute("userId");
        mav.setViewName("index");
        return mav;
    }

}
