//package com.entertainment.user.repository;
//
//import com.entertainment.user.entity.User;
//import com.entertainment.user.request.ChangePwReq;
//import com.entertainment.user.request.RegisterReq;
//import com.entertainment.user.service.UserService;
//import com.entertainment.user.service.UserServiceImpl;
//import org.assertj.core.api.Assertions;
//import org.junit.jupiter.api.AfterEach;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.RequestBody;
//
//public class UserServiceTest {
//
//    @Autowired
//    UserServiceImpl userService = new UserServiceImpl();
//
//    @Autowired
//    private UserRepository userRepository;
//
//    @AfterEach
//    public void afterEach(){
//        userService.clearUser();
//    }
//
//    @Test
//    public void signUp(){
//
//        //given
//        RegisterReq registerReq = new RegisterReq("a","a","a");
//        User user = new User(registerReq);
//
//        //when
//        userRepository.save(user);
//
//        //then
//        User result = userRepository.getById(user.getId());
//        Assertions.assertThat(result).isEqualTo(user);
//    }
//
//}
