package com.entertainment.user.entity;

import lombok.*;

import javax.persistence.*;

@ToString
@Getter
@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "game")
public class Game {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;     //게임의 고유 ID

    @Column(nullable = false)
    private String game_title;       //게임 이름

    @Column(nullable = false)
    private String info;       //게임 설명

    @Column(nullable = false)
    private int max_user;       //게임 종류의 최대 인원

    @OneToOne
    @JoinColumn(name="liargame_depth2_id")
    private LiargameDepth2 liargameDepth2; // 게임 제시어

}
