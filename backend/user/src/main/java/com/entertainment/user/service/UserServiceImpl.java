package com.entertainment.user.service;

import com.entertainment.user.entity.Profile;
//import com.entertainment.user.entity.Role;
import com.entertainment.user.repository.ProfileRepository;
import com.entertainment.user.request.ChangePwReq;
import com.entertainment.user.request.CodeReq;
import com.entertainment.user.request.ProfileRegisterReq;
import com.entertainment.user.request.RegisterReq;
import com.entertainment.user.entity.User;
import com.entertainment.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@Service
public class UserServiceImpl implements UserService{

    @Autowired
    private UserRepository userRepository;


    @Autowired
    private ProfileRepository profileRepository;

    @Autowired
    private JavaMailSender javaMailSender;

    public static final String ePw = createKey();


    @Override
    public void registerUser(RegisterReq registerDto) {

        User user = new User(registerDto);
//        user.builder().role(Role.USER);
        System.out.println(user.getEmail()+" "+user.getNickname()+" "+user.getPassword());
        userRepository.save(user);
        ProfileRegisterReq profileRegisterReq=new ProfileRegisterReq(user.getId(),user.getNickname());
        Profile profile = new Profile(profileRegisterReq);
        //profile.setUser(userRepository.findById(user.getId()));
        profile.setUser(userRepository.getById(user.getId()));
        profileRepository.save(profile);
    }

    @Override
    public boolean doExistUserEmail(String email) {
        List<User> userList = userRepository.findAll();
        for(User u: userList){
            if(u.getEmail().equals(email)){
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean doExistUserNickname(String nickname) {
        List<User> userList = userRepository.findAll();
        for(User u: userList){
            if(u.getNickname().equals(nickname)){
                return true;
            }
        }
        return false;
    }

    @Override
    public String validateAccount(String email, String password) {
        List<User> userList = userRepository.findAll();
        for(User u: userList){
            if(u.getEmail().equals(email) && u.getPassword().equals(password)){ // 이메일과 비밀번호 둘다 검증된 경우

                return "Email & Password Valid";
            }else if(u.getEmail().equals(email) && !u.getPassword().equals(password)){  //이메일은 검증되고 비밀번호는 다른경우
                return "Email Valid & Password NO";
            }
        }
        return "Email No";
    }

    @Override
    public User getUserNicknameByUserEmail(String email) {
        List<User> userList = userRepository.findAll();
        User user = null;
        for(User u: userList){
            if(u.getEmail().equals(email)){
                user = u;
            }
        }
        return user;
    }

    @Override
    public boolean deleteUser(int userId){
        List<User> userList = userRepository.findAll();
        if(userRepository.existsById(userId)){  //아이디가 존재한다면
            User user = null;
            for(User u: userList){
                if(u.getId()==userId){
                    user = u;
                    break;
                }
            }
            userRepository.delete(user);
            return true;
        }
        else {
            return false;
        }
    }

    public boolean sendMail(String email){
        List<User> userList = userRepository.findAll();
        User user=new User(); //= userRepository.getById(userId);
        user.setId(0);
        for(User u: userList){
            if(u.getEmail().equals(email)){
                user = u;
            }
        }
        if(user.getId()==0){
            return false;       //이메일 존재 X
        }
        //수신 대상을 담을 arraylist
        ArrayList<String> toUserList = new ArrayList<>();
        //수신 대상 추가
        toUserList.add(user.getEmail());
        //수신 대상 개수
        int toUserSize = toUserList.size();
        //SimpleMessage
        SimpleMailMessage simpleMailMessage = new SimpleMailMessage();
        //수신자 설정
        simpleMailMessage.setTo((String[]) toUserList.toArray(new String[toUserSize]));
        //메일 제목
        simpleMailMessage.setSubject("우리끼리예능 인증코드");
        //메일 내용
        simpleMailMessage.setText("인증코드는 "+ePw+"입니다. \n홈페이지에서 인증코드를 입력하여 주시기 바랍니다.");
        //메일 발송
        javaMailSender.send(simpleMailMessage);
        user.setCode(ePw);
        userRepository.save(user);
        return true;
    }

    @Override
    public String changePassword(String email, ChangePwReq changePwReq) {
        if(changePwReq.getPassword().equals(changePwReq.getPasswordCheck())){
            List<User> userList = userRepository.findAll();
            User user=new User(); //= userRepository.getById(userId);
            user.setId(1);
            for(User u: userList){
                if(u.getEmail().equals(email)){
                    System.out.println(email);
                    user=u;
                    break;
                }
            }
            if(user.getId()==1){
                return "No Email";       //이메일 존재 X
            }

            user.setPassword(changePwReq.getPassword());
            userRepository.save(user);
            //System.out.println("password changed");
            return "True";
        }else{
            //System.out.println("password is not same");
            return "Password is not Same";
        }
        //return false;
    }

    @Override
    public String authorization(CodeReq codeReq) {
        List<User> userList = userRepository.findAll();
        User user=new User(); //= userRepository.getById(userId);
        user.setId(0);
        for(User u: userList){
            if(u.getEmail().equals(codeReq.getEmail())){
                user = u;
            }
        }
        if(user.getId()==0){
            return "이메일 존재 X";       //이메일 존재 X
        }
        //User user = userRepository.getById(userId);
        //System.out.println((user.getId()+" "+user.getCode()));

        System.out.println((codeReq.getCode()+" "+user.getCode()));
        if(codeReq.getCode().equals(user.getCode())){
            //System.out.println("코드 승인 완료");
            return "코드 승인 완료";
        }else{
            //System.out.println("코드가 다릅니다.");
            return "코드가 올바르지 않습니다.";
        }
    }

    @Override
    public String showProfile(int profileId) {
        List<Profile> list = profileRepository.findAll();
        String s="";
        for(Profile p : list){
            if(p.getId()==profileId){
                //"{\"code\": \"200, SUCCESS\", \"message\": "+"님 프로필이 조회되었습니다.}";
                s+="{\"id\": "+p.getId()+", \"nickname\": \""+p.getNickname()+"\", \"score\": "+p.getScore()+", \"win_number\": "+p.getWin_number()+", \"lose_number\": "+p.getLose_number()+", \"user_id\": "+p.getUser().getId()+"}";
                return s;
            }
        }
        return s;
    }

    @Override
    public int getProfileIdByUserNickname(String nickname) {
        List<Profile> list = profileRepository.findAll();
        String s="";
        for(Profile p : list){
            if(p.getNickname().equals(nickname)){
                //"{\"code\": \"200, SUCCESS\", \"message\": "+"님 프로필이 조회되었습니다.}";
                return p.getId();
            }
        }
        return -1;      //해당 프로필이 없을경우
    }

//    @Override
//    public String showProfile(String nickName) {
//        List<Profile> list = profileRepository.findAll();
//        String s="";
//        for(Profile p : list){
//            if(p.getNickname().equals(nickName)){
//                //"{\"code\": \"200, SUCCESS\", \"message\": "+"님 프로필이 조회되었습니다.}";
//                s+="{\n\t\"id\": "+p.getId()+",\n\t\"nickname\": \""+p.getNickname()+"\",\n\t\"score\": "+p.getScore()+",\n\t\"win_number\": "+p.getWin_number()+",\n\t\"lose_number\": "+p.getLose_number()+",\n\t\"user_id\": "+p.getUser().getId()+"\n}";
//                return s;
//            }
//        }
//        return s;
//    }

    public static String createKey() {
        StringBuffer key = new StringBuffer();
        Random rnd = new Random();
        //인증코드 8자리
        for(int i = 0; i < 8; i++) {
            //0~2 까지 랜덤
            int index = rnd.nextInt(3);
            switch(index) {
                case 0:
                    //a ~ z (1+ 97 = 98. => (char)98 = 'b'
                    key.append((char) ((int)(rnd.nextInt(26)) + 97));
                    break;
                case 1:
                    //위와 비슷하게 A ~ Z
                    key.append((char) ((int)(rnd.nextInt(26)) + 65));
                    break;
                case 2:
                    //0 ~ 9
                    key.append((rnd.nextInt(10)));
                    break;
            }
        }
        return key.toString();
    }

    public void clearUser(){
        userRepository.deleteAll();
    }


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("사용자를 찾을 수 없습니다."));
    }
}
