//package com.entertainment.user.service;
//
//import com.entertainment.user.entity.OAuthAttributes;
//import com.entertainment.user.entity.SessionUser;
//import com.entertainment.user.entity.User;
//import com.entertainment.user.repository.UserRepository;
//import lombok.RequiredArgsConstructor;
//import org.springframework.security.core.authority.SimpleGrantedAuthority;
//import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
//import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
//import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
//import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
//import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
//import org.springframework.security.oauth2.core.user.OAuth2User;
//import org.springframework.stereotype.Service;
//
//import javax.servlet.http.HttpSession;
//import java.util.Collections;
//
//@RequiredArgsConstructor
//@Service
//public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {
//
//    private final UserRepository userRepository;
//    private final HttpSession httpSession;
//
//    @Override
//    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
//        OAuth2UserService<OAuth2UserRequest, OAuth2User> delegate = new DefaultOAuth2UserService();
//        OAuth2User oAuth2User = delegate.loadUser(userRequest);
//
//        //현재 로그인 진행 중인 서비스를 구분한다(구글로그인 or 애플로그인)
//        String registrationId = userRequest.getClientRegistration().getRegistrationId();
//
//        //OAuth2 로그인 진행시 키가되는 필드값(PK 개념, 구글은 sub)
//        String userNameAttributeName = userRequest.getClientRegistration().getProviderDetails()
//                .getUserInfoEndpoint().getUserNameAttributeName();
//
//        //CustomOAuth2UserService를 통해 가져온 OAuth2User의 attribute를 담을 클래스
//        OAuthAttributes attributes = OAuthAttributes.of(registrationId, userNameAttributeName, oAuth2User.getAttributes());
//
//        User user = saveOrUpdate(attributes);
//
//        //세션에 사용자 정보를 저장하기 위해 user를 직렬화 하는 sessionUser
//        httpSession.setAttribute("user", new SessionUser(user));
//
//        return new DefaultOAuth2User(
//                Collections.singleton(new SimpleGrantedAuthority(user.getRoleKey())),
//                attributes.getAttributes(),
//                attributes.getNameAttributeKey()
//        );
//
//    }
//
//    private User saveOrUpdate(OAuthAttributes attributes){
//        //기존 유저라면 update, 신규 유저라면 User를 생성
//        //기존 유저가 소셜서비스에서 이름을 바꾸면 이를 적용
//        User user = userRepository.findByEmail(attributes.getEmail())
//                .map(entity -> entity.update(attributes.getNickname()))
//                        .orElse(attributes.toEntity());
//        return userRepository.save(user);
//    }
//}
