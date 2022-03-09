package com.entertainment.user.repository;

import com.entertainment.user.entity.Room;
import com.entertainment.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RoomRepository extends JpaRepository<Room, Integer> {

}
