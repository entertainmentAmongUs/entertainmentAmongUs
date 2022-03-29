package com.entertainment.user.service;

import com.entertainment.user.request.ChangePwReq;
import com.entertainment.user.request.RegisterReq;
import com.entertainment.user.entity.User;
import com.entertainment.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@Service
public class UserServiceImpl implements UserService{

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JavaMailSender javaMailSender;

    public static final String ePw = createKey();

    @Override
    public void registerUser(RegisterReq registerDto) {

        User user = new User(registerDto);
        System.out.println(user.getEmail()+" "+user.getNickname()+" "+user.getPassword());
        userRepository.save(user);
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
    public boolean validateAccount(String email, String password) {
        List<User> userList = userRepository.findAll();
        for(User u: userList){
            if(u.getEmail().equals(email) && u.getPassword().equals(password)){
                return true;
            }
        }
        return false;
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

    public boolean sendMail(int userId){

        User user = userRepository.getById(userId);

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
        return false;
    }

    @Override
    public boolean changePassword(int userId, ChangePwReq changePwReq) {
        if(changePwReq.getPassword().equals(changePwReq.getPasswordCheck())){
            User myUser = userRepository.getById(userId);
            myUser.setPassword(changePwReq.getPassword());
            userRepository.save(myUser);
            //System.out.println("password changed");
        }else{
            //System.out.println("password is not same");
        }
        return false;
    }

    @Override
    public boolean authorization(int userId, String code) {
        if(code.equals(ePw)){
            System.out.println("코드 승인 완료");
            return true;
        }else{
            System.out.println("코드가 다릅니다.");
            return false;
        }
    }

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
}
