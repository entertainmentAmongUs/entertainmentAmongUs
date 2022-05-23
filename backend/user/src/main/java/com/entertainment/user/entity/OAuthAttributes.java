//package com.entertainment.user.entity;
//
//import lombok.Builder;
//import lombok.Getter;
//
//import java.util.Map;
//
//@Getter
//public class OAuthAttributes {
//
//    private Map<String, Object> attributes;
//    private String nameAttributeKey, nickname, email;
//
//    @Builder
//    public OAuthAttributes(Map<String, Object> attributes, String nameAttributeKey, String nickname, String email){
//        this.attributes=attributes;
//        this.nameAttributeKey = nameAttributeKey;
//        this.nickname=nickname;
//        this.email=email;
//    }
//    public static OAuthAttributes of(String registrationId, String userNameAttributeName, Map<String, Object> attributes){
//        return ofGoogle(userNameAttributeName, attributes);
//    }
//
//    public static OAuthAttributes ofGoogle(String userNameAttributeName, Map<String, Object> attributes){
//        return OAuthAttributes.builder()
//                .nickname((String) attributes.get("name"))
//                .email((String) attributes.get("email"))
//                .attributes(attributes)
//                .nameAttributeKey(userNameAttributeName)
//                .build();
//    }
//
//    public User toEntity() {
//        return User.builder()
//                .nickname(nickname)
//                .email(email)
//                .role(Role.USER)
//                .build();
//    }
//
//}
