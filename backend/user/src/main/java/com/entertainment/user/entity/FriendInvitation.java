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
@Table(name = "friend_invitation")
public class FriendInvitation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;     //친구초대장 고유 ID

    @Column(nullable = false)
    private String from_profile_id;       //친구 초대한 사람 ID

    @Column(nullable = false)
    private String to_profile_id;       //친구 초대 받은 사람 ID

    @Column(nullable = false)
    private int acceptance;       //초대 수락 여부(1: 수락/ 2: 보류/ 3: 거부)

}
