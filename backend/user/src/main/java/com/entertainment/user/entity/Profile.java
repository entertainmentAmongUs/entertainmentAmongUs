package com.entertainment.user.entity;

import lombok.*;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@ToString
@Getter
@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "profile")
public class Profile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;     //계정 생성시 자동 생성되는 ID

    @Column(nullable = false)
    private String nickname;       //사용자의 닉네임

    @Column(nullable = false)
    private int score;       //사용자의 점수  (처음 1000으로 초기화)

    @Column(nullable = false)
    private int win_number;       //사용자의 이긴 횟수

    @Column(nullable = false)
    private int lose_number;       //사용자의 진 횟수

    // 이부분은 Spring Security 공부 후 추가 구현 필요//////////////
    @Column(nullable = false)
    private boolean login_status;   //로그인 유무
    ///////////////////////////////////////////////////////////

    @OneToOne
    @JoinColumn(name="user_id")     //사용자의 UserId (이메일등 다른 값을 받아오기위해 사용)
    private User user;

    @ManyToOne
    @JoinColumn(name = "room_id")
    private Room room;            //사용자의 방 번호

    @OneToMany(mappedBy = "profile")
    private List<Friend> friendList = new ArrayList<>();

//    public Profile(ProfileReq profileReq) {
//        this.id = profileReq.id;
//        this.nickname = profileReq.nickname;
//        this.score = 1000;
//        this.win_number = 0;
//        this.lose_number = 0;
//    }
}
