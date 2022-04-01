package com.entertainment.user.entity;

import com.entertainment.user.request.RegisterReq;
import lombok.*;

import javax.persistence.*;

@ToString
@Getter
@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "user")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;     //계정 생성시 자동 생성되는 ID

    @Column(nullable = false)
    private String email;       //사용자의 이메일

    @Column(nullable = false)
    private String nickname;       //사용자의 닉네임

    @Column(nullable = false)
    private String password;        //사용자의 비밀번호

    @Column(nullable = false)
    private String token;           //사용자의 토큰

    @Column
    private String code;            //사용자의 이메일 인증 코드

    public User(RegisterReq registerDto) {
        this.email = registerDto.getEmail();
        this.nickname = registerDto.getNickname();
        this.password = registerDto.getPassword();
        this.token = "Token"+this.nickname;
        this.code="";
    }
}
