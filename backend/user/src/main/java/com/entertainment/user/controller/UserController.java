package com.entertainment.user.controller;

import com.entertainment.user.config.security.JwtTokenProvider;
import com.entertainment.user.entity.Profile;
import com.entertainment.user.entity.SessionKey;
import com.entertainment.user.repository.UserRepository;
import com.entertainment.user.request.ChangePwReq;
import com.entertainment.user.request.CodeReq;
import com.entertainment.user.request.LoginReq;
import com.entertainment.user.entity.User;
import com.entertainment.user.request.RegisterReq;
import com.entertainment.user.response.BaseRes;
import com.entertainment.user.service.KakaoAPI;
import com.entertainment.user.service.SessionService;
import com.entertainment.user.service.UserService;
import com.fasterxml.jackson.databind.ser.Serializers;
//import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
//@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private SessionService sessionNRedisTestService;

    @Autowired
    private SessionService sessionService;

    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final UserRepository userRepository;

    @PostMapping("/users/new-user")
    //@ApiOperation(value = "hello, world api", notes = "hello world swagger check")
//    public ResponseEntity signUp(@RequestBody RegisterReq registerDto){
    public ResponseEntity signUp(@RequestBody RegisterReq registerDto){
        //log.info(String.valueOf(registerDto));
        String s;
        //email 중복 확인
        if(checkEmail(registerDto.getEmail()).getStatusCodeValue()!=200){
            s = "\"code\": \"SIGNUP_ERROR_100\", \"message\": \"이메일 중복\"";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //System.out.println(s);
            //BaseRes baseRes = new BaseRes(401, "이메일 중복");
            //return 401;
        }

        //nickname 중복 확인
        if(checkNickname(registerDto.getNickname()).getStatusCodeValue()!=200){
            s = "\"code\": \"SIGNUP_ERROR_101\", \"message\": \"닉네임 중복\"";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //System.out.println(s);
            //return false;

            //BaseRes baseRes = new BaseRes(402, "닉네임 중복");
            //return 402;
        }

        //이메일 & 닉네임 중복 없을 때
        userService.registerUser(registerDto);
        s = "\"code\": \"200, SUCCESS\", \"message\": "+registerDto.getNickname()+"님 회원가입이 되었습니다.";
        return ResponseEntity.status(HttpStatus.OK).body(s);
        //System.out.println(s);
        //return true;

        //BaseRes baseRes = new BaseRes(200, "회원가입 완료");
        //return 200;
    }

    @GetMapping("/users/checkEmail/{email}")
    public ResponseEntity checkEmail(@PathVariable String email){
        String s;
        if(userService.doExistUserEmail(email)){

            s = "\"code\": \"SIGNUP_ERROR_100\", \"message\": \"이메일 중복\"";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return true;            //이메일 중복일 때
            //BaseRes baseRes = new BaseRes(401, "이메일 중복");
            //return 401;
        }
        s = "\"code\": \"200, SUCCESS\", \"message\": "+"이메일 중복 X";
        return ResponseEntity.status(HttpStatus.OK).body(s);
        //return false;               //이메일 중복 아닐 때
        //BaseRes baseRes = new BaseRes(200, "이메일 중복아님");
        //return 200;
    }

    @GetMapping("/users/checkNickname/{nickname}")
    public ResponseEntity checkNickname(@PathVariable String nickname){
        String s;
        if(userService.doExistUserNickname(nickname)){
            s = "\"code\": \"SIGNUP_ERROR_101\", \"message\": \"닉네임 중복\"";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 402;            //닉네임 중복일 때
        }
        s = "\"code\": \"200, SUCCESS\", \"message\": "+"닉네임 중복 X";
        return ResponseEntity.status(HttpStatus.OK).body(s);
        //return 200;               //닉네임 중복 아닐 때
    }

    @PostMapping("/users/login")
//    public ResponseEntity logIn(@RequestBody LoginReq loginDto){
    public ResponseEntity logIn(@RequestBody LoginReq loginDto, HttpSession httpSession){
        String s;

        //email과 password 일치 확인
        if(!userService.validateAccount(loginDto.getEmail(),loginDto.getPassword())){
            s = "\"code\": \"LOGIN_ERROR_100\", \"message\": \"이메일과 비밀번호가 일치하지 않습니다.\"";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 403;     //이메일 비번 일치하지 않음
        }

        //String id = sessionService.getSessionId(httpSession);
        //sessionService.setRedisStringValue(loginDto.getEmail(), id);
        httpSession.setAttribute(SessionKey.LOGIN_USER_ID, loginDto.getEmail());
        sessionService.setRedisStringValue(loginDto.getEmail(), sessionService.getSessionId(httpSession));
        User user = userService.getUserNicknameByUserEmail(loginDto.getEmail());

        //s = "\"님 환영합니다!\"";
        //본문
//        s = "{\"token\": \"";
//        s += jwtTokenProvider.createToken(user.getUsername())+"\"}";

        //테스트용
        s = jwtTokenProvider.createToken(user.getUsername());

        return ResponseEntity.status(HttpStatus.OK).body(s);
        // 200;             //로그인 성공
    }
    @PostMapping("/users/auth")
    public ResponseEntity auth(@RequestParam(name = "email") String email,HttpServletRequest request) {
        String s="";
        String token = jwtTokenProvider.resolveToken(request);
        if(jwtTokenProvider.getUserEmail(token).equals(email)) {
            //name: message value: true
            s = "{\"message\": \"true\"}";
            return ResponseEntity.status(HttpStatus.OK).body(s);
        }else{
            s = "{\"message\": \"false\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }
//        if(jwtTokenProvider.getUserEmail(token).equals("z")){
//            s = "{\"email\": "+"\"true\" }";
//            return ResponseEntity.status(HttpStatus.OK).body(s);
//        }
//        else {
//            s = "{\"email\": " + "\"false\" }";
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
//        }
        //s += "{\"validate\": " + "\"true\" }";
        //return ResponseEntity.status(HttpStatus.OK).body(s);


//        if(jwtTokenProvider.validateToken(token)) {
//            if(jwtTokenProvider.getUserEmail(token).equals("z")){
//                s = "{\"email\": "+"\"true\" }";
//            }
//            else {
//                s = "{\"email\": " + "\"false\" }";
//            }
//            s += "{\"validate\": " + "\"true\" }";
//            return ResponseEntity.status(HttpStatus.OK).body(s);
//        }else{
//            s += "{\"validate\": "+"\"false\" }";
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
//        }
    }

    @DeleteMapping("/users/logout/{email}")
    public ResponseEntity logOut(@PathVariable(name = "email") String email, HttpSession httpSession) {
        httpSession.removeAttribute(email);
        String s = sessionService.deleteSessionId(email, httpSession);
        return ResponseEntity.status(HttpStatus.OK).body(s);
    }

    @DeleteMapping("/users/{userId}")
    public ResponseEntity deleteUser(@PathVariable(name = "userId") int userId){
        String s;
        if(userService.deleteUser(userId)){
            s = "\"code\": \"200, SUCCESS\", \"message\": "+"님 회원삭제가 되었습니다.";
            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return 200;
        }else { //아이디가 존재하지 않음
            s = "\"code\": \"LOGIN_ERROR_100\", \"message\": \"아이디 존재 X.\"";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 405;     //아이디 존재 X
        }
    }

    @GetMapping("/emails/{email}/email")
    public ResponseEntity sendMail(@PathVariable(name = "email") String email){
        String s;
        if(userService.sendMail(email)){
            s = "\"code\": \"200, SUCCESS\", \"message\": "+"님 이메일 전송이 되었습니다.";
            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return 200;
        }else{
            s = "\"code\": \"LOGIN_ERROR_100\", \"message\": \"이메일 존재 X\"";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 406 ;        //이메일 존재 X
        }
    }

    @PostMapping("/emails/email-code")
    public ResponseEntity Authorization(@RequestBody CodeReq codeReq){
        String s;

        if(userService.authorization(codeReq)){
            s = "\"code\": \"200, SUCCESS\", \"message\": "+"님 인증이 되었습니다.";
            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return 200;
        }else{
            s = "\"code\": \"LOGIN_ERROR_100\", \"message\": \"코드 인증 X\"";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 407;         //코드인증 안됨
        }
    }

    @PatchMapping("/users/{email}/password")
    public ResponseEntity changePassword(@PathVariable(name = "email")String email, @RequestBody ChangePwReq changePwReq){
        String s;
        if(userService.changePassword(email, changePwReq)){
            s = "\"code\": \"200, SUCCESS\", \"message\": "+"님 비밀번호 변경이 되었습니다.";

            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return 200;
        }else {
            s = "\"code\": \"LOGIN_ERROR_100\", \"message\": \"비번 일치 X.\"";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 408;     //비번일치 X
        }
    }

    @GetMapping("/profile/{profileId}/mypage")
    public ResponseEntity myPage(@PathVariable(name = "profileId")int profileId) {
        String s;
        String profile = userService.showProfile(profileId);
        if(!profile.isEmpty()){
            s = "{\"code\": \"200, SUCCESS\", \"message\": "+"님 프로필이 조회되었습니다.}";
            return ResponseEntity.status(HttpStatus.OK).body(s+"\n"+profile);
        }else{
            s = "{\"code\": \"400, ERROR\", \"message\": "+"님은 존재하지 않습니다.}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }
    }
//    @GetMapping("/profile/{nickName}/mypage")
//    public ResponseEntity myPage(@PathVariable(name = "nickName")String nickName) {
//        String s;
//        String profile = userService.showProfile(nickName);
//        if(!profile.isEmpty()){
//            s = "{\"code\": \"200, SUCCESS\", \"message\": "+"님 프로필이 조회되었습니다.}";
//            return ResponseEntity.status(HttpStatus.OK).body(s+"\n"+profile);
//        }else{
//            s = "{\"code\": \"400, ERROR\", \"message\": "+"님은 존재하지 않습니다.}";
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
//        }
//    }


    @GetMapping("/profile/{profileId}/list-up")
    public ResponseEntity listUp(@PathVariable(name = "profileId")int profileId) {
        String s;
        String profile = userService.showProfile(profileId);
        if(!profile.equals("")){
            s = "{\"code\": \"200, SUCCESS\", \"message\": "+"님 프로필이 조회되었습니다.}";
            return ResponseEntity.status(HttpStatus.OK).body(s+"\n"+profile);
        }else{
            s = "{\"code\": \"400, ERROR\", \"message\": "+"님은 존재하지 않습니다.}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }
    }
//    @GetMapping("/profile/{nickName}/list-up")
//    public ResponseEntity listUp(@PathVariable(name = "nickName")String nickName) {
//        String s;
//        String profile = userService.showProfile(nickName);
//        if(!profile.equals("")){
//            s = "{\"code\": \"200, SUCCESS\", \"message\": "+"님 프로필이 조회되었습니다.}";
//            return ResponseEntity.status(HttpStatus.OK).body(s+"\n"+profile);
//        }else{
//            s = "{\"code\": \"400, ERROR\", \"message\": "+"님은 존재하지 않습니다.}";
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
//        }
//    }

//    //kakao 소셜 로그인
//    KakaoAPI kakaoApi = new KakaoAPI();
//
//    @RequestMapping(value="/kakaologin")
//    public ModelAndView login(@RequestParam("code") String code, HttpSession session) {
//        ModelAndView mav = new ModelAndView();
//        // 1번 인증코드 요청 전달
//        String accessToken = kakaoApi.getAccessToken(code);
//        // 2번 인증코드로 토큰 전달
//        HashMap<String, Object> userInfo = kakaoApi.getUserInfo(accessToken);
//
//        System.out.println("login info : " + userInfo.toString());
//
//        if(userInfo.get("email") != null) {
//            session.setAttribute("userId", userInfo.get("email"));
//            session.setAttribute("accessToken", accessToken);
//        }
//        mav.addObject("userId", userInfo.get("email"));
//        mav.setViewName("index");
//        return mav;
//    }
//
//    @RequestMapping(value="/kakaologout")
//    public ModelAndView logout(HttpSession session) {
//        ModelAndView mav = new ModelAndView();
//
//        kakaoApi.kakaoLogout((String)session.getAttribute("accessToken"));
//        session.removeAttribute("accessToken");
//        session.removeAttribute("userId");
//        mav.setViewName("index");
//        return mav;
//    }

}
