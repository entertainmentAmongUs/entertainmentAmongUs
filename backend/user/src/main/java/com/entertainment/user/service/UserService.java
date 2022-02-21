package com.entertainment.user.service;

import com.entertainment.user.request.RegisterReq;
import com.entertainment.user.entity.User;
import org.springframework.stereotype.Service;

@Service
public interface UserService {
    void registerUser(RegisterReq registerDto);
    boolean doExistUserEmail(String email);
    boolean doExistUserNickname(String nickname);

    boolean validateAccount(String email, String password);

    User getUserNicknameByUserEmail(String email);
}
