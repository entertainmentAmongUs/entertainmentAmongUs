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
@Table(name = "friend")
public class Friend {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;     //친구의 고유 ID

    @Column(nullable = false)
    private String nickname;       //친구 닉네임

    @ManyToOne
    @JoinColumn(name = "profile_id")        //누구의 친구인가
    private Profile profile;

}
