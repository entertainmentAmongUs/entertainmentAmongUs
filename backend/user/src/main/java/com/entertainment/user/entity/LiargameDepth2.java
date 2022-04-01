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
@Table(name = "liargame_depth2")
public class LiargameDepth2 {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;     //depth2의 고유 ID

    @Column(nullable = false)
    private String title;       //depth2의 주제

    @ManyToOne
    @JoinColumn(name = "liargame_depth1_id")
    private LiargameDepth1 liargameDepth1;

    @Builder.Default
    @OneToMany(mappedBy = "liargameDepth2")
    private List<LiargameDepth3> liargameDepth3List = new ArrayList<>();

}
