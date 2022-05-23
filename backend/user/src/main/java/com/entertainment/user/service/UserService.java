package com.entertainment.user.service;

import com.entertainment.user.entity.Profile;
import com.entertainment.user.request.ChangePwReq;
import com.entertainment.user.request.CodeReq;
import com.entertainment.user.request.RegisterReq;
import com.entertainment.user.entity.User;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public interface UserService extends UserDetailsService {
    void registerUser(RegisterReq registerDto);
    boolean doExistUserEmail(String email);
    boolean doExistUserNickname(String nickname);

    String validateAccount(String email, String password);

    User getUserNicknameByUserEmail(String email);
    boolean deleteUser(int UserId);
    boolean sendMail(String email);

    String changePassword(String email, ChangePwReq changePwReq);

    String authorization(CodeReq codeReq);

    String showProfile(int profileId);

    int getProfileIdByUserNickname(String nickname);

    //Optional<User> findByEmail(String email);
}
