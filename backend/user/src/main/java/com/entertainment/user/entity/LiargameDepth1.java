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
@Table(name = "liargame_depth1")
public class LiargameDepth1 {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;     //depth1의 고유 ID

    @Column(nullable = false)
    private String title;       //depth1의 주제

    @Builder.Default
    @OneToMany(mappedBy = "liargameDepth1")
    private List<LiargameDepth2> liargameDepth2List = new ArrayList<>();

}
