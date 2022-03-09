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
@Table(name = "invitation")
public class Invitation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;     //초대장 고유 ID

    @Column(nullable = false)
    private String from_profile_id;       //초대한 사람 ID

    @Column(nullable = false)
    private String to_profile_id;       //초대 받은 사람 ID

    @Column(nullable = false)
    private int acceptance;       //초대 수락 여부(1: 수락/ 2: 보류/ 3: 거부)

    @ManyToOne
    @JoinColumn(name = "room_id")
    private Room room;

}
