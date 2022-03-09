package com.entertainment.user.repository;

import com.entertainment.user.entity.Game;
import com.entertainment.user.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GameRepository extends JpaRepository<Game, Integer> {

}
