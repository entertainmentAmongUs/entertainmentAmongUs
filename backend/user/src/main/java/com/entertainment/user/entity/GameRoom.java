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
@Table(name = "game_room")
public class GameRoom {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;     //게임의 고유 ID

    @Column(nullable = false)
    private int liar_number;       //라이어 번호

    @Column
    private Double time;       //게임 시간

    @OneToOne
    @JoinColumn(name="room_id")
    private Room room; // 방 번호

    @OneToOne
    @JoinColumn(name="liargame_depth3_id")
    private LiargameDepth3 liargameDepth3; // 게임 제시어


}
