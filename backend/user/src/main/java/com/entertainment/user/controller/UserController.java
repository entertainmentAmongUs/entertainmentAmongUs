package com.entertainment.user.controller;

import com.entertainment.user.config.security.JwtTokenProvider;
import com.entertainment.user.entity.Profile;
import com.entertainment.user.entity.SessionKey;
//import com.entertainment.user.entity.SessionUser;
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

    //1번 기능
    @ApiOperation(value = "test", notes="테스트입니다.")
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
        //email 중복 확인
        if(checkEmail(registerDto.getEmail()).getStatusCodeValue()!=200){
            s = "{\"message\": \"이메일 중복\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //System.out.println(s);
            //BaseRes baseRes = new BaseRes(401, "이메일 중복");
            //return 401;
        }


        //nickname 중복 확인
        if(checkNickname(registerDto.getNickname()).getStatusCodeValue()!=200){
            s = "{\"message\": \"닉네임 중복\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //System.out.println(s);
            //return false;

            //BaseRes baseRes = new BaseRes(402, "닉네임 중복");
            //return 402;
        }

        //이메일 & 닉네임 중복 없을 때
        userService.registerUser(registerDto);
        s = "{\"message\": \"회원가입이 되었습니다.\"}";
        return ResponseEntity.status(HttpStatus.OK).body(s);
        //System.out.println(s);
        //return true;

        //BaseRes baseRes = new BaseRes(200, "회원가입 완료");
        //return 200;
    }

    //2번 기능
    @GetMapping("/users/checkEmail/{email}")
    public ResponseEntity checkEmail(@PathVariable String email){
        String s;
        if(userService.doExistUserEmail(email)){

            s = "{\"message\": \"이메일 중복\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return true;            //이메일 중복일 때
            //BaseRes baseRes = new BaseRes(401, "이메일 중복");
            //return 401;
        }
        s = "{\"message\": \"이메일 사용이 가능합니다.\"}";
        return ResponseEntity.status(HttpStatus.OK).body(s);
        //return false;               //이메일 중복 아닐 때
        //BaseRes baseRes = new BaseRes(200, "이메일 중복아님");
        //return 200;
    }

    //3번 기능
    @GetMapping("/users/checkNickname/{nickname}")
    public ResponseEntity checkNickname(@PathVariable String nickname){
        String s;
        if(userService.doExistUserNickname(nickname)){
            s = "{\"message\": \"닉네임 중복\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 402;            //닉네임 중복일 때
        }
        s = "{\"message\": \"닉네임 사용이 가능합니다.\"}";
        return ResponseEntity.status(HttpStatus.OK).body(s);
        //return 200;               //닉네임 중복 아닐 때
    }

    //12번 기능
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/googleLogin")
    public ResponseEntity googleLogin( @AuthenticationPrincipal OAuth2User user){
        String email = user.getAttribute("email");
        String nickname = user.getAttribute("name");
        //String s=email+" "+nickname;
        String s="";

        //회원이 처음 로그인 했다면 회원가입 하기
        //email 중복이라면 로그인하기
        if(checkEmail(email).getStatusCodeValue()!=200){
            //s = "{\"message\": \"이메일 중복\"}";
            //로그인 기능
            httpSession.setAttribute(SessionKey.LOGIN_USER_ID, email);
            sessionService.setRedisStringValue(email, sessionService.getSessionId(httpSession));
            User user1 = userService.getUserNicknameByUserEmail(email);

            int profileId = userService.getProfileIdByUserNickname(user1.getNickname());
            if(profileId==-1){
                System.out.println("해당 유저의 프로필이 존재하지 않습니다.");
            }

            int userId = user1.getId();
            //테스트용
            s = "{ \"Token\": \""+jwtTokenProvider.createToken(user1.getUsername())+"\"," +
                    "\"profileId\": \""+profileId+"\"," +
                    "\"userId\": \""+user1.getId()+"\"," +
                    "\"nickname\": \""+user1.getNickname()+"\"}";
            //------------------------------------------------------
            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return s;
        }

        //nickname 중복이라면 nickname+rand()해서 닉네임 입력
        else if(checkNickname(nickname).getStatusCodeValue()!=200){
            //s = "{\"message\": \"닉네임 중복\"}";
            //닉네임 랜덤 돌리기 기능
            while(true){
                String temp = createNickname();
                if(checkNickname(nickname+temp).getStatusCodeValue()==200){
                    nickname+=temp;
                    break;
                }
            }
            //-------------------------
            //회원가입 후 로그인
            //password random 값 입력
            String password = createPassword();
            RegisterReq registerDto = new RegisterReq(email, nickname, password);
            userService.registerUser(registerDto);
            //s = "{\"message\": \"회원가입이 되었습니다.\"}";
            //로그인 기능
            httpSession.setAttribute(SessionKey.LOGIN_USER_ID, email);
            sessionService.setRedisStringValue(email, sessionService.getSessionId(httpSession));
            User user1 = userService.getUserNicknameByUserEmail(email);

            int profileId = userService.getProfileIdByUserNickname(user1.getNickname());
            if(profileId==-1){
                System.out.println("해당 유저의 프로필이 존재하지 않습니다.");
            }

            int userId = user1.getId();
            //테스트용
            s = "{ \"Token\": \""+jwtTokenProvider.createToken(user1.getUsername())+"\"," +
                    "\"profileId\": \""+profileId+"\"," +
                    "\"userId\": \""+user1.getId()+"\"," +
                    "\"nickname\": \""+user1.getNickname()+"\"}";
            //------------------------------------------------------
            return ResponseEntity.status(HttpStatus.OK).body(s);
        }
        String password = createPassword();
        System.out.println("password Create");
        //회원가입 후 로그인
        //password random 값 입력
        RegisterReq registerDto = new RegisterReq(email,nickname, password);
        userService.registerUser(registerDto);

        System.out.println("register success");
        //s = "{\"message\": \"회원가입이 되었습니다.\"}";
        //로그인 기능
        httpSession.setAttribute(SessionKey.LOGIN_USER_ID, email);
        sessionService.setRedisStringValue(email, sessionService.getSessionId(httpSession));
        User user1 = userService.getUserNicknameByUserEmail(email);

        int profileId = userService.getProfileIdByUserNickname(user1.getNickname());
        if(profileId==-1){
            System.out.println("해당 유저의 프로필이 존재하지 않습니다.");
        }

        int userId = user1.getId();
        //테스트용

        s = "{ \"Token\": \""+jwtTokenProvider.createToken(user1.getUsername())+"\"," +
                "\"profileId\": \""+profileId+"\"," +
                "\"userId\": \""+user1.getId()+"\"," +
                "\"nickname\": \""+user1.getNickname()+"\"}";
//        //------------------------------------------------------
        return ResponseEntity.status(HttpStatus.OK).body(s);
    }

    private String createNickname() {
        StringBuffer key = new StringBuffer();
        Random rnd = new Random();
        //인증코드 8자리
        for (int i = 0; i < 4; i++) {
            //0~2 까지 랜덤
            int index = rnd.nextInt(3);
            switch (index) {
                case 0:
                    //a ~ z (1+ 97 = 98. => (char)98 = 'b'
                    key.append((char) ((int) (rnd.nextInt(26)) + 97));
                    break;
                case 1:
                    //위와 비슷하게 A ~ Z
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

    //4번 기능
    @PostMapping("/users/login")
//    public ResponseEntity logIn(@RequestBody LoginReq loginDto){
    public ResponseEntity logIn(@RequestBody LoginReq loginDto, HttpSession httpSession){
        String s;

        //email과 password 일치 확인
        String answer = userService.validateAccount(loginDto.getEmail(),loginDto.getPassword());
        if(answer.equals("Email No")){
            s = "{\"message\": \"이메일이 존재하지 않습니다.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 403;     //이메일 비번 일치하지 않음
        }else if(answer.equals("Email Valid & Password NO")){
            s = "{\"message\": \"비밀번호가 일치하지 않습니다.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
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

        int profileId = userService.getProfileIdByUserNickname(user.getNickname());
        if(profileId==-1){
            System.out.println("해당 유저의 프로필이 존재하지 않습니다.");
        }

        int userId = user.getId();
        //테스트용
        s = "{ \"Token\": \""+jwtTokenProvider.createToken(user.getUsername())+"\"," +
                "\"profileId\": \""+profileId+"\"," +
                "\"userId\": \""+user.getId()+"\"," +
                "\"nickname\": \""+user.getNickname()+"\"}";


        return ResponseEntity.status(HttpStatus.OK).body(s);
        // 200;             //로그인 성공
    }

    //5번 기능
    @PostMapping("/users/auth")
    public ResponseEntity auth(@RequestParam(name = "email") String email,HttpServletRequest request) {
        String s="";
        String token = jwtTokenProvider.resolveToken(request);
        try{
            if(jwtTokenProvider.getUserEmail(token).equals(email)) {
                //name: message value: true
                s = "{\"message\": \"토큰 인증\"}";
                return ResponseEntity.status(HttpStatus.OK).body(s);
            }else{
                s = "{\"message\": \"토큰 인증 불가\"}";
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            }
        }catch (ExpiredJwtException e){
            s = "{ \"Token\": \""+jwtTokenProvider.createToken(email)+"\"," +
                    "\"message\": \"토큰 인증\"}";
            return ResponseEntity.status(HttpStatus.OK).body(s);
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

    //없앤 기능
    @DeleteMapping("/users/logout/{email}")
    public ResponseEntity logOut(@PathVariable(name = "email") String email, HttpSession httpSession) {
        httpSession.removeAttribute(email);
        String s = sessionService.deleteSessionId(email, httpSession);
        return ResponseEntity.status(HttpStatus.OK).body(s);
    }

    //6번 기능
    @DeleteMapping("/users/{userId}")
    public ResponseEntity deleteUser(@PathVariable(name = "userId") int userId){
        String s;
        if(userService.deleteUser(userId)){
            s = "{\"message\": \"회원삭제가 되었습니다.\"}";
            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return 200;
        }else { //아이디가 존재하지 않음
            s = "{\"message\": \"아이디 존재 X.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 405;     //아이디 존재 X
        }
    }

    //7번 기능
    @GetMapping("/emails/{email}/email")
    public ResponseEntity sendMail(@PathVariable(name = "email") String email){
        String s;
        if(userService.sendMail(email)){
            s = "{\"message\": \"이메일 전송이 되었습니다.\"}";
            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return 200;
        }else{
            s = "{\"message\": \"이메일 존재 X.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 406 ;        //이메일 존재 X
        }
    }

    //8번 기능
    @PostMapping("/emails/email-code")
    public ResponseEntity Authorization(@RequestBody CodeReq codeReq){
        String s;
        String answer = userService.authorization(codeReq);

        if(answer.equals("코드 승인 완료")){
            s = "{\"message\": \"코드 인증이 되었습니다.\"}";
            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return 200;
        }else if(answer.equals("이메일 존재 X")){
            s = "{\"message\": \"이메일 존재 X.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 407;         //코드인증 안됨
        }else{
            s = "{\"message\": \"코드가 올바르지 않습니다.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }
    }

    //9번 기능
    @PatchMapping("/users/{email}/password")
    public ResponseEntity changePassword(@PathVariable(name = "email")String email, @RequestBody ChangePwReq changePwReq){
        String s;

        String answer = userService.changePassword(email, changePwReq);
        if(answer.equals("True")){
            s = "{\"message\": \"비밀번호 변경이 되었습니다.\"}";

            return ResponseEntity.status(HttpStatus.OK).body(s);
            //return 200;
        }else if(answer.equals("Password is not Same")){
            s = "{\"message\": \"비번 일치 X.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
            //return 408;     //비번일치 X
        }else {
            s = "{\"message\": \"이메일이 존재하지 않습니다.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }
    }

    //10번 기능
    @GetMapping("/profile/{profileId}/mypage")
    public ResponseEntity myPage(@PathVariable(name = "profileId")int profileId) {
        String s;
        String profile = userService.showProfile(profileId);
        if(!profile.isEmpty()){
            s = "{\"message\": \"프로필이 조회되었습니다.\"}";
            return ResponseEntity.status(HttpStatus.OK).body(s+"\n"+profile);
        }else{
            s = "{\"message\": \"프로필이 존재하지 않습니다.\"}";
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


    //11번 기능
    @GetMapping("/profile/{profileId}/list-up")
    public ResponseEntity listUp(@PathVariable(name = "profileId")int profileId) {
        String s;
        String profile = userService.showProfile(profileId);
        if(!profile.equals("")){
            s = "{\"message\": \"프로필이 조회되었습니다.\"}";
            return ResponseEntity.status(HttpStatus.OK).body(s+"\n"+profile);
        }else{
            s = "{\"message\": \"프로필이 존재하지 않습니다.\"}";
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(s);
        }
    }

    public static String createPassword() {
        StringBuffer key = new StringBuffer();
        Random rnd = new Random();
        //인증코드 8자리
        for (int i = 0; i < 8; i++) {
            //0~2 까지 랜덤
            int index = rnd.nextInt(3);
            switch (index) {
                case 0:
                    //a ~ z (1+ 97 = 98. => (char)98 = 'b'
                    key.append((char) ((int) (rnd.nextInt(26)) + 97));
                    break;
                case 1:
                    //위와 비슷하게 A ~ Z
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
