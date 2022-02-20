package com.entertainment.user.service;

import com.entertainment.user.request.RegisterReq;
import com.entertainment.user.entity.User;
import com.entertainment.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService{

    @Autowired
    private UserRepository userRepository;

    @Override
    public void registerUser(RegisterReq registerDto) {

        User user = new User(registerDto);
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
}
