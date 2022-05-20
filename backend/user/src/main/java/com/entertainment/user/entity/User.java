package com.entertainment.user.entity;

import com.entertainment.user.request.RegisterReq;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import java.util.Collection;

@ToString
@Getter
@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "user")
public class User implements UserDetails {

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

//    @Enumerated(EnumType.STRING)
//    @Column(nullable = false)
//    private Role role;

    @Builder
    public User(RegisterReq registerDto) {
        this.email = registerDto.getEmail();
        this.nickname = registerDto.getNickname();
        this.password = registerDto.getPassword();
        this.token = "Token"+this.nickname;
        this.code="";
    }

    public User update(String nickname) {
        this.nickname = nickname;
        return this;
    }

//    public String getRoleKey(){
//        return this.role.getKey();
//    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return null;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
