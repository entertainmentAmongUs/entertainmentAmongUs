package com.entertainment.user.service;

import com.entertainment.user.entity.Profile;
//import com.entertainment.user.entity.Role;
import com.entertainment.user.repository.ProfileRepository;
import com.entertainment.user.request.*;
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
import java.util.LinkedList;
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
            if(u.getEmail().equals(email) && u.getPassword().equals(password)){ // ???????????? ???????????? ?????? ????????? ??????

                return "Email & Password Valid";
            }else if(u.getEmail().equals(email) && !u.getPassword().equals(password)){  //???????????? ???????????? ??????????????? ????????????
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
        if(userRepository.existsById(userId)){  //???????????? ???????????????
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
            return false;       //????????? ?????? X
        }
        //?????? ????????? ?????? arraylist
        ArrayList<String> toUserList = new ArrayList<>();
        //?????? ?????? ??????
        toUserList.add(user.getEmail());
        //?????? ?????? ??????
        int toUserSize = toUserList.size();
        //SimpleMessage
        SimpleMailMessage simpleMailMessage = new SimpleMailMessage();
        //????????? ??????
        simpleMailMessage.setTo((String[]) toUserList.toArray(new String[toUserSize]));
        //?????? ??????
        simpleMailMessage.setSubject("?????????????????? ????????????");
        //?????? ??????
        simpleMailMessage.setText("??????????????? "+ePw+"?????????. \n?????????????????? ??????????????? ???????????? ????????? ????????????.");
        //?????? ??????
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
                return "No Email";       //????????? ?????? X
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
            return "????????? ?????? X";       //????????? ?????? X
        }
        //User user = userRepository.getById(userId);
        //System.out.println((user.getId()+" "+user.getCode()));

        System.out.println((codeReq.getCode()+" "+user.getCode()));
        if(codeReq.getCode().equals(user.getCode())){
            //System.out.println("?????? ?????? ??????");
            return "?????? ?????? ??????";
        }else{
            //System.out.println("????????? ????????????.");
            return "????????? ???????????? ????????????.";
        }
    }

    @Override
    public String showProfile(int userId) {
        List<Profile> list = profileRepository.findAll();
        String s="";
        for(Profile p : list){
            if(p.getUser().getId()==userId){
                //"{\"code\": \"200, SUCCESS\", \"message\": "+"??? ???????????? ?????????????????????.}";
                s+="{\"id\": "+p.getId()+", \"nickname\": \""+p.getNickname()+"\", \"score\": "+p.getScore()+", \"win_number\": "+p.getWin_number()+", \"lose_number\": "+p.getLose_number()+", \"user_id\": "+p.getUser().getId()+"}";
                return s;
            }
        }
        return s;
    }

    @Override
    public int getProfileIdByUserNickname(String nickname) {
        List<Profile> list = profileRepository.findAll();
        for(Profile p : list){
            if(p.getNickname().equals(nickname)){
                //"{\"code\": \"200, SUCCESS\", \"message\": "+"??? ???????????? ?????????????????????.}";
                return p.getId();
            }
        }
        return -1;      //?????? ???????????? ????????????
    }

    @Override
    public boolean gameOutCome(OutcomeReq outcomeReq) {
        if(outcomeReq.getIsVictory()){
            User user = userRepository.getById(outcomeReq.getUserId());
            List<Profile> profiles=new LinkedList<>();
            Profile profile=new Profile();
            profiles=profileRepository.findAll();
            for(Profile p:profiles){
                if(p.getUser().getId()==user.getId()){
                    profile=p;
                }
            }
            int winnum=profile.getWin_number()+1;
            profile.setWin_number(winnum);
            profileRepository.save(profile);
        }else{
            User user = userRepository.getById(outcomeReq.getUserId());
            List<Profile> profiles=new LinkedList<>();
            Profile profile=new Profile();
            profiles=profileRepository.findAll();
            for(Profile p:profiles){
                if(p.getUser().getId()==user.getId()){
                    profile=p;
                }
            }
            int losenum=profile.getLose_number()+1;
            profile.setLose_number(losenum);
            profileRepository.save(profile);
        }
        return true;
    }

//    @Override
//    public String showProfile(String nickName) {
//        List<Profile> list = profileRepository.findAll();
//        String s="";
//        for(Profile p : list){
//            if(p.getNickname().equals(nickName)){
//                //"{\"code\": \"200, SUCCESS\", \"message\": "+"??? ???????????? ?????????????????????.}";
//                s+="{\n\t\"id\": "+p.getId()+",\n\t\"nickname\": \""+p.getNickname()+"\",\n\t\"score\": "+p.getScore()+",\n\t\"win_number\": "+p.getWin_number()+",\n\t\"lose_number\": "+p.getLose_number()+",\n\t\"user_id\": "+p.getUser().getId()+"\n}";
//                return s;
//            }
//        }
//        return s;
//    }

    public static String createKey() {
        StringBuffer key = new StringBuffer();
        Random rnd = new Random();
        //???????????? 8??????
        for(int i = 0; i < 8; i++) {
            //0~2 ?????? ??????
            int index = rnd.nextInt(3);
            switch(index) {
                case 0:
                    //a ~ z (1+ 97 = 98. => (char)98 = 'b'
                    key.append((char) ((int)(rnd.nextInt(26)) + 97));
                    break;
                case 1:
                    //?????? ???????????? A ~ Z
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
                .orElseThrow(() -> new UsernameNotFoundException("???????????? ?????? ??? ????????????."));
    }
}
