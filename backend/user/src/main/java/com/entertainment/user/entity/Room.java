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
@Table(name = "room")
public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;     //방 생성시 자동 생성되는 ID

    @Column
    private String password;       //방의 비밀번호(NULL 가능)

    @Column(nullable = false)
    private String room_title;       //방의 이름

    @OneToOne
    @JoinColumn(name="game_id")       //게임의 id
    private Game game;

    @OneToOne
    @JoinColumn(name="host_id")
    private Profile profile;    //방장의 id

    @Column(nullable = false)
    private int max_user;       //해당 방의 max 인원

    @Column(nullable = false)
    private int room_status;        //방의 상태(1: 대기/2: 게임 중)

    @OneToMany(mappedBy = "room")
    private List<Profile> profileList = new ArrayList<>();

    @OneToMany(mappedBy = "room")
    private List<Invitation> invitationList = new ArrayList<>();

}
