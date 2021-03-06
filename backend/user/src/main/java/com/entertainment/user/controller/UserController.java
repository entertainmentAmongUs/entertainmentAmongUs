package com.entertainment.user.controller;

import com.entertainment.user.config.security.JwtTokenProvider;
import com.entertainment.user.entity.Profile;
import com.entertainment.user.entity.SessionKey;
//import com.entertainment.user.entity.SessionUser;
import com.entertainment.user.repository.UserRepository;
import com.entertainment.user.request.*;
import com.entertainment.user.entity.User;
import com.entertainment.user.response.BaseRes;
import com.entertainment.user.service.KakaoAPI;
import com.entertainment.user.service.SessionService;
import com.entertainment.user.service.UserService;
import com.fasterxml.jackson.databind.ser.Serializers;
//import io.swagger.annotations.ApiOperation;
import io.jsonwebtoken.ExpiredJwtException;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Slf4j
@RequiredArgsConstructor
@Api(value = "SwaggerTestController")
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
    private final HttpSession httpSession;

    //1??? ??????
    @ApiOperation(value = "test", notes="??????????????????.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK!"),
            @ApiResponse(code = 404, message = "page not found!")
    })
    @PostMapping("/users/new-user")
    //@ApiOperation(value = "hello, world api", notes = "hello world swagger check")
//    public ResponseEntity signUp(@RequestBody RegisterReq registerDto){
    public ResponseEntity signUp(@RequestBody RegisterReq registerDto){
        //log.info(String.valueOf(registerDto));
        String s;
        //email ?????? ??????
        if(checkEmail(registerDto.getEmail()).getStatusCodeValue()!=200){
            s = "{\"message\": \"????????? ??????\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //System.out.println(s);
            //BaseRes baseRes = new BaseRes(401, "????????? ??????");
            //return 401;
        }


        //nickname ?????? ??????
        if(checkNickname(registerDto.getNickname()).getStatusCodeValue()!=200){
            s = "{\"message\": \"????????? ??????\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //System.out.println(s);
            //return false;

            //BaseRes baseRes = new BaseRes(402, "????????? ??????");
            //return 402;
        }

        //????????? & ????????? ?????? ?????? ???
        userService.registerUser(registerDto);
        s = "{\"message\": \"??????????????? ???????????????.\"}";
        return ResponseEntity.status(HttpStatus.OK).body(s);
        //System.out.println(s);
        //return true;

        //BaseRes baseRes = new BaseRes(200, "???????????? ??????");
        //return 200;
    }

    //2??? ??????
    @GetMapping("/users/checkEmail/{email}")
    public ResponseEntity checkEmail(@PathVariable String email){
        String s;
        if(userService.doExistUserEmail(email)){

            s = "{\"message\": \"????????? ??????\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return true;            //????????? ????????? ???
            //BaseRes baseRes = new BaseRes(401, "????????? ??????");
            //return 401;
        }
        s = "{\"message\": \"????????? ????????? ???????????????.\"}";
        return ResponseEntity.status(HttpStatus.OK).body(s);
        //return false;               //????????? ?????? ?????? ???
        //BaseRes baseRes = new BaseRes(200, "????????? ????????????");
        //return 200;
    }

    //3??? ??????
    @GetMapping("/users/checkNickname/{nickname}")
    public ResponseEntity checkNickname(@PathVariable String nickname){
        String s;
        if(userService.doExistUserNickname(nickname)){
            s = "{\"message\": \"????????? ??????\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 402;            //????????? ????????? ???
        }
        s = "{\"message\": \"????????? ????????? ???????????????.\"}";
        return ResponseEntity.status(HttpStatus.OK).body(s);
        //return 200;               //????????? ?????? ?????? ???
    }

    //12??? ??????
    //@PreAuthorize("isAuthenticated()")
    @PostMapping("/users/googleLogin")
    public ResponseEntity googleLogin(@RequestBody GoogleLoginReq googleLoginReq){
        String email = googleLoginReq.getEmail();
        String nickname = googleLoginReq.getNickname();
        //String s=email+" "+nickname;
        String s="";

        //????????? ?????? ????????? ????????? ???????????? ??????
        //email ??????????????? ???????????????
        if(checkEmail(email).getStatusCodeValue()!=200){
            //s = "{\"message\": \"????????? ??????\"}";
            //????????? ??????
            httpSession.setAttribute(SessionKey.LOGIN_USER_ID, email);
            sessionService.setRedisStringValue(email, sessionService.getSessionId(httpSession));
            User user1 = userService.getUserNicknameByUserEmail(email);

            int profileId = userService.getProfileIdByUserNickname(user1.getNickname());
            if(profileId==-1){
                System.out.println("?????? ????????? ???????????? ???????????? ????????????.");
            }

            int userId = user1.getId();
            //????????????
            s = "{\"profileId\": \""+profileId+"\"," +
                    "\"userId\": \""+user1.getId()+"\"," +
                    "\"nickname\": \""+user1.getNickname()+"\"}";
            //------------------------------------------------------
            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return s;
        }

        //nickname ??????????????? nickname+rand()?????? ????????? ??????
        else if(checkNickname(nickname).getStatusCodeValue()!=200){
            //s = "{\"message\": \"????????? ??????\"}";
            //????????? ?????? ????????? ??????
            while(true){
                String temp = createNickname();
                if(checkNickname(nickname+temp).getStatusCodeValue()==200){
                    nickname+=temp;
                    break;
                }
            }
            //-------------------------
            //???????????? ??? ?????????
            //password random ??? ??????
            String password = createPassword();
            RegisterReq registerDto = new RegisterReq(email, nickname, password);
            userService.registerUser(registerDto);
            //s = "{\"message\": \"??????????????? ???????????????.\"}";
            //????????? ??????
            httpSession.setAttribute(SessionKey.LOGIN_USER_ID, email);
            sessionService.setRedisStringValue(email, sessionService.getSessionId(httpSession));
            User user1 = userService.getUserNicknameByUserEmail(email);

            int profileId = userService.getProfileIdByUserNickname(user1.getNickname());
            if(profileId==-1){
                System.out.println("?????? ????????? ???????????? ???????????? ????????????.");
            }

            int userId = user1.getId();
            //????????????
            s = "{\"profileId\": \""+profileId+"\"," +
                    "\"userId\": \""+user1.getId()+"\"," +
                    "\"nickname\": \""+user1.getNickname()+"\"}";
            //------------------------------------------------------
            return ResponseEntity.status(HttpStatus.OK).body(s);
        }
        String password = createPassword();
        System.out.println("password Create");
        //???????????? ??? ?????????
        //password random ??? ??????
        RegisterReq registerDto = new RegisterReq(email,nickname, password);
        userService.registerUser(registerDto);

        System.out.println("register success");
        //s = "{\"message\": \"??????????????? ???????????????.\"}";
        //????????? ??????
        httpSession.setAttribute(SessionKey.LOGIN_USER_ID, email);
        sessionService.setRedisStringValue(email, sessionService.getSessionId(httpSession));
        User user1 = userService.getUserNicknameByUserEmail(email);

        int profileId = userService.getProfileIdByUserNickname(user1.getNickname());
        if(profileId==-1){
            System.out.println("?????? ????????? ???????????? ???????????? ????????????.");
        }

        int userId = user1.getId();
        //????????????

        s = "{\"profileId\": \""+profileId+"\"," +
                "\"userId\": \""+user1.getId()+"\"," +
                "\"nickname\": \""+user1.getNickname()+"\"}";
//        //------------------------------------------------------
        return ResponseEntity.status(HttpStatus.OK).body(s);
    }

//    //12??? ??????
//    @PreAuthorize("isAuthenticated()")
//    @GetMapping("/googleLogin")
//    public ResponseEntity googleLogin( @AuthenticationPrincipal OAuth2User user){
//        String email = user.getAttribute("email");
//        String nickname = user.getAttribute("name");
//        //String s=email+" "+nickname;
//        String s="";
//
//        //????????? ?????? ????????? ????????? ???????????? ??????
//        //email ??????????????? ???????????????
//        if(checkEmail(email).getStatusCodeValue()!=200){
//            //s = "{\"message\": \"????????? ??????\"}";
//            //????????? ??????
//            httpSession.setAttribute(SessionKey.LOGIN_USER_ID, email);
//            sessionService.setRedisStringValue(email, sessionService.getSessionId(httpSession));
//            User user1 = userService.getUserNicknameByUserEmail(email);
//
//            int profileId = userService.getProfileIdByUserNickname(user1.getNickname());
//            if(profileId==-1){
//                System.out.println("?????? ????????? ???????????? ???????????? ????????????.");
//            }
//
//            int userId = user1.getId();
//            //????????????
//            s = "{ \"Token\": \""+jwtTokenProvider.createToken(user1.getUsername())+"\"," +
//                    "\"profileId\": \""+profileId+"\"," +
//                    "\"userId\": \""+user1.getId()+"\"," +
//                    "\"nickname\": \""+user1.getNickname()+"\"}";
//            //------------------------------------------------------
//            return ResponseEntity.status(HttpStatus.OK).body(s);
//            //return s;
//        }
//
//        //nickname ??????????????? nickname+rand()?????? ????????? ??????
//        else if(checkNickname(nickname).getStatusCodeValue()!=200){
//            //s = "{\"message\": \"????????? ??????\"}";
//            //????????? ?????? ????????? ??????
//            while(true){
//                String temp = createNickname();
//                if(checkNickname(nickname+temp).getStatusCodeValue()==200){
//                    nickname+=temp;
//                    break;
//                }
//            }
//            //-------------------------
//            //???????????? ??? ?????????
//            //password random ??? ??????
//            String password = createPassword();
//            RegisterReq registerDto = new RegisterReq(email, nickname, password);
//            userService.registerUser(registerDto);
//            //s = "{\"message\": \"??????????????? ???????????????.\"}";
//            //????????? ??????
//            httpSession.setAttribute(SessionKey.LOGIN_USER_ID, email);
//            sessionService.setRedisStringValue(email, sessionService.getSessionId(httpSession));
//            User user1 = userService.getUserNicknameByUserEmail(email);
//
//            int profileId = userService.getProfileIdByUserNickname(user1.getNickname());
//            if(profileId==-1){
//                System.out.println("?????? ????????? ???????????? ???????????? ????????????.");
//            }
//
//            int userId = user1.getId();
//            //????????????
//            s = "{ \"Token\": \""+jwtTokenProvider.createToken(user1.getUsername())+"\"," +
//                    "\"profileId\": \""+profileId+"\"," +
//                    "\"userId\": \""+user1.getId()+"\"," +
//                    "\"nickname\": \""+user1.getNickname()+"\"}";
//            //------------------------------------------------------
//            return ResponseEntity.status(HttpStatus.OK).body(s);
//        }
//        String password = createPassword();
//        System.out.println("password Create");
//        //???????????? ??? ?????????
//        //password random ??? ??????
//        RegisterReq registerDto = new RegisterReq(email,nickname, password);
//        userService.registerUser(registerDto);
//
//        System.out.println("register success");
//        //s = "{\"message\": \"??????????????? ???????????????.\"}";
//        //????????? ??????
//        httpSession.setAttribute(SessionKey.LOGIN_USER_ID, email);
//        sessionService.setRedisStringValue(email, sessionService.getSessionId(httpSession));
//        User user1 = userService.getUserNicknameByUserEmail(email);
//
//        int profileId = userService.getProfileIdByUserNickname(user1.getNickname());
//        if(profileId==-1){
//            System.out.println("?????? ????????? ???????????? ???????????? ????????????.");
//        }
//
//        int userId = user1.getId();
//        //????????????
//
//        s = "{ \"Token\": \""+jwtTokenProvider.createToken(user1.getUsername())+"\"," +
//                "\"profileId\": \""+profileId+"\"," +
//                "\"userId\": \""+user1.getId()+"\"," +
//                "\"nickname\": \""+user1.getNickname()+"\"}";
////        //------------------------------------------------------
//        return ResponseEntity.status(HttpStatus.OK).body(s);
//    }

    private String createNickname() {
        StringBuffer key = new StringBuffer();
        Random rnd = new Random();
        //???????????? 8??????
        for (int i = 0; i < 4; i++) {
            //0~2 ?????? ??????
            int index = rnd.nextInt(3);
            switch (index) {
                case 0:
                    //a ~ z (1+ 97 = 98. => (char)98 = 'b'
                    key.append((char) ((int) (rnd.nextInt(26)) + 97));
                    break;
                case 1:
                    //?????? ???????????? A ~ Z
                    key.append((char) ((int) (rnd.nextInt(26)) + 65));
                    break;
                case 2:
                    //0 ~ 9
                    key.append((rnd.nextInt(10)));
                    break;
            }
        }
        return key.toString();
    }

    //4??? ??????
    @PostMapping("/users/login")
//    public ResponseEntity logIn(@RequestBody LoginReq loginDto){
    public ResponseEntity logIn(@RequestBody LoginReq loginDto, HttpSession httpSession){
        String s;

        //email??? password ?????? ??????
        String answer = userService.validateAccount(loginDto.getEmail(),loginDto.getPassword());
        if(answer.equals("Email No")){
            s = "{\"message\": \"???????????? ???????????? ????????????.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 403;     //????????? ?????? ???????????? ??????
        }else if(answer.equals("Email Valid & Password NO")){
            s = "{\"message\": \"??????????????? ???????????? ????????????.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }

        //String id = sessionService.getSessionId(httpSession);
        //sessionService.setRedisStringValue(loginDto.getEmail(), id);
        httpSession.setAttribute(SessionKey.LOGIN_USER_ID, loginDto.getEmail());
        sessionService.setRedisStringValue(loginDto.getEmail(), sessionService.getSessionId(httpSession));
        User user = userService.getUserNicknameByUserEmail(loginDto.getEmail());

        //s = "\"??? ???????????????!\"";
        //??????
//        s = "{\"token\": \"";
//        s += jwtTokenProvider.createToken(user.getUsername())+"\"}";

        int profileId = userService.getProfileIdByUserNickname(user.getNickname());
        if(profileId==-1){
            System.out.println("?????? ????????? ???????????? ???????????? ????????????.");
        }

        int userId = user.getId();
        //????????????
        s = "{ \"Token\": \""+jwtTokenProvider.createToken(user.getUsername())+"\"," +
                "\"profileId\": \""+profileId+"\"," +
                "\"userId\": \""+user.getId()+"\"," +
                "\"nickname\": \""+user.getNickname()+"\"}";


        return ResponseEntity.status(HttpStatus.OK).body(s);
        // 200;             //????????? ??????
    }
    //5??? ??????
    @PostMapping("/users/auth")
    public ResponseEntity auth(@RequestBody AuthReq authReq) {
        String s="";
        //String token = jwtTokenProvider.resolveToken(request);
        //System.out.println(request.getHeader(request.));
        try{
            if(jwtTokenProvider.getUserEmail(authReq.getToken()).equals(authReq.getEmail())) {
                //name: message value: true
                //s = "{\"message\": \"?????? ??????\"}";
                User user = userService.getUserNicknameByUserEmail(authReq.getEmail());
                int profileId = userService.getProfileIdByUserNickname(user.getNickname());
                if(profileId==-1){
                    System.out.println("?????? ????????? ???????????? ???????????? ????????????.");
                }
                s = "{\"profileId\": \""+profileId+"\"," +
                        "\"userId\": \""+user.getId()+"\"," +
                        "\"nickname\": \""+user.getNickname()+"\"}";
                return ResponseEntity.status(HttpStatus.OK).body(s);
            }else{
                s = "{\"message\": \"?????? ?????? ??????\"}";
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            }
        }catch (ExpiredJwtException e){
//            s = "{ \"Token\": \""+jwtTokenProvider.createToken(authReq.getEmail())+"\"," +
//                    "\"message\": \"?????? ??????\"}";
            User user = userService.getUserNicknameByUserEmail(authReq.getEmail());
            int profileId = userService.getProfileIdByUserNickname(user.getNickname());
            if(profileId==-1){
                System.out.println("?????? ????????? ???????????? ???????????? ????????????.");
            }
            s = "{\"profileId\": \""+profileId+"\"," +
                    "\"userId\": \""+user.getId()+"\"," +
                    "\"nickname\": \""+user.getNickname()+"\"}";
            return ResponseEntity.status(HttpStatus.OK).body(s);
        }

    }


//    //5??? ??????
//    @PostMapping("/users/auth")
//    public ResponseEntity auth(@RequestParam(name = "token") String token) {
////    public ResponseEntity auth(@RequestParam(name = "email") String email, HttpServletRequest request) {
//        String s="";
//        String token = jwtTokenProvider.resolveToken(request);
//        System.out.println(request.getHeader(request.));
//        try{
//            if(jwtTokenProvider.getUserEmail(token).equals(email)) {
//                //name: message value: true
//                s = "{\"message\": \"?????? ??????\"}";
//                return ResponseEntity.status(HttpStatus.OK).body(s);
//            }else{
//                s = "{\"message\": \"?????? ?????? ??????\"}";
//                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
//            }
//        }catch (ExpiredJwtException e){
//            s = "{ \"Token\": \""+jwtTokenProvider.createToken(email)+"\"," +
//                    "\"message\": \"?????? ??????\"}";
//            return ResponseEntity.status(HttpStatus.OK).body(s);
//        }
//
////        if(jwtTokenProvider.getUserEmail(token).equals("z")){
////            s = "{\"email\": "+"\"true\" }";
////            return ResponseEntity.status(HttpStatus.OK).body(s);
////        }
////        else {
////            s = "{\"email\": " + "\"false\" }";
////            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
////        }
//        //s += "{\"validate\": " + "\"true\" }";
//        //return ResponseEntity.status(HttpStatus.OK).body(s);
//
//
////        if(jwtTokenProvider.validateToken(token)) {
////            if(jwtTokenProvider.getUserEmail(token).equals("z")){
////                s = "{\"email\": "+"\"true\" }";
////            }
////            else {
////                s = "{\"email\": " + "\"false\" }";
////            }
////            s += "{\"validate\": " + "\"true\" }";
////            return ResponseEntity.status(HttpStatus.OK).body(s);
////        }else{
////            s += "{\"validate\": "+"\"false\" }";
////            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
////        }
//    }
//
//    //?????? ??????
//    @DeleteMapping("/users/logout/{email}")
//    public ResponseEntity logOut(@PathVariable(name = "email") String email, HttpSession httpSession) {
//        httpSession.removeAttribute(email);
//        String s = sessionService.deleteSessionId(email, httpSession);
//        return ResponseEntity.status(HttpStatus.OK).body(s);
//    }

    //6??? ??????
    @DeleteMapping("/users/{userId}")
    public ResponseEntity deleteUser(@PathVariable(name = "userId") int userId){
        String s;
        if(userService.deleteUser(userId)){
            s = "{\"message\": \"??????????????? ???????????????.\"}";
            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return 200;
        }else { //???????????? ???????????? ??????
            s = "{\"message\": \"????????? ?????? X.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 405;     //????????? ?????? X
        }
    }

    //7??? ??????
    @GetMapping("/emails/{email}/email")
    public ResponseEntity sendMail(@PathVariable(name = "email") String email){
        String s;
        if(userService.sendMail(email)){
            s = "{\"message\": \"????????? ????????? ???????????????.\"}";
            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return 200;
        }else{
            s = "{\"message\": \"????????? ?????? X.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 406 ;        //????????? ?????? X
        }
    }

    //8??? ??????
    @PostMapping("/emails/email-code")
    public ResponseEntity Authorization(@RequestBody CodeReq codeReq){
        String s;
        String answer = userService.authorization(codeReq);

        if(answer.equals("?????? ?????? ??????")){
            s = "{\"message\": \"?????? ????????? ???????????????.\"}";
            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return 200;
        }else if(answer.equals("????????? ?????? X")){
            s = "{\"message\": \"????????? ?????? X.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 407;         //???????????? ??????
        }else{
            s = "{\"message\": \"????????? ???????????? ????????????.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }
    }

    //9??? ??????
    @PatchMapping("/users/{email}/password")
    public ResponseEntity changePassword(@PathVariable(name = "email")String email, @RequestBody ChangePwReq changePwReq){
        String s;

        String answer = userService.changePassword(email, changePwReq);
        if(answer.equals("True")){
            s = "{\"message\": \"???????????? ????????? ???????????????.\"}";

            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return 200;
        }else if(answer.equals("Password is not Same")){
            s = "{\"message\": \"?????? ?????? X.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 408;     //???????????? X
        }else {
            s = "{\"message\": \"???????????? ???????????? ????????????.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }
    }

    //10??? ??????
    @GetMapping("/profile/{userId}/mypage")
    public ResponseEntity myPage(@PathVariable(name = "userId")int userId) {
        String s;
        String profile = userService.showProfile(userId);
        if(!profile.isEmpty()){
            s = "{\"message\": \"???????????? ?????????????????????.\"}";
            return ResponseEntity.status(HttpStatus.OK).body(profile);
        }else{
            s = "{\"message\": \"???????????? ???????????? ????????????.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }
    }
//    @GetMapping("/profile/{nickName}/mypage")
//    public ResponseEntity myPage(@PathVariable(name = "nickName")String nickName) {
//        String s;
//        String profile = userService.showProfile(nickName);
//        if(!profile.isEmpty()){
//            s = "{\"code\": \"200, SUCCESS\", \"message\": "+"??? ???????????? ?????????????????????.}";
//            return ResponseEntity.status(HttpStatus.OK).body(s+"\n"+profile);
//        }else{
//            s = "{\"code\": \"400, ERROR\", \"message\": "+"?????? ???????????? ????????????.}";
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
//        }
//    }


    //11??? ??????
    @GetMapping("/profile/{userId}/list-up")
    public ResponseEntity listUp(@PathVariable(name = "userId")int userId) {
        String s;
        String profile = userService.showProfile(userId);
        if(!profile.equals("")){
            s = "{\"message\": \"???????????? ?????????????????????.\"}";
            return ResponseEntity.status(HttpStatus.OK).body(profile);
        }else{
            s = "{\"message\": \"???????????? ???????????? ????????????.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }
    }

    //12??? ??????
    @PostMapping("/profile/outcome")
    public ResponseEntity result(@RequestBody OutcomeReq outcomeReq){
        String s;
        if(userService.gameOutCome(outcomeReq)){
            s = "{\"message\": \"????????? ?????????????????????.\"}";
            return ResponseEntity.status(HttpStatus.OK).body(s);
        }else{
            s = "{\"message\": \"????????? ???????????? ???????????????.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }
    }

    public static String createPassword() {
        StringBuffer key = new StringBuffer();
        Random rnd = new Random();
        //???????????? 8??????
        for (int i = 0; i < 8; i++) {
            //0~2 ?????? ??????
            int index = rnd.nextInt(3);
            switch (index) {
                case 0:
                    //a ~ z (1+ 97 = 98. => (char)98 = 'b'
                    key.append((char) ((int) (rnd.nextInt(26)) + 97));
                    break;
                case 1:
                    //?????? ???????????? A ~ Z
                    key.append((char) ((int) (rnd.nextInt(26)) + 65));
                    break;
                case 2:
                    //0 ~ 9
                    key.append((rnd.nextInt(10)));
                    break;
            }
        }
        return key.toString();
    }
//    @GetMapping("/profile/{nickName}/list-up")
//    public ResponseEntity listUp(@PathVariable(name = "nickName")String nickName) {
//        String s;
//        String profile = userService.showProfile(nickName);
//        if(!profile.equals("")){
//            s = "{\"code\": \"200, SUCCESS\", \"message\": "+"??? ???????????? ?????????????????????.}";
//            return ResponseEntity.status(HttpStatus.OK).body(s+"\n"+profile);
//        }else{
//            s = "{\"code\": \"400, ERROR\", \"message\": "+"?????? ???????????? ????????????.}";
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
//        }
//    }

//    //kakao ?????? ?????????
//    KakaoAPI kakaoApi = new KakaoAPI();
//
//    @RequestMapping(value="/kakaologin")
//    public ModelAndView login(@RequestParam("code") String code, HttpSession session) {
//        ModelAndView mav = new ModelAndView();
//        // 1??? ???????????? ?????? ??????
//        String accessToken = kakaoApi.getAccessToken(code);
//        // 2??? ??????????????? ?????? ??????
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
