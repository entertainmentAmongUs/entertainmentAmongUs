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
@Table(name = "liargame_depth3")
public class LiargameDepth3 {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;     //depth3의 고유 ID

    @Column(nullable = false)
    private String title;       //depth3의 주제

    @ManyToOne
    @JoinColumn(name = "liargame_depth2_id")
    private LiargameDepth2 liargameDepth2;

}
