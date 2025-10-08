package model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class UserTest {
    private User user1;
    private User user2;

    @BeforeEach
    void setUp() {

        user1 = new User("Alice", "pass123");
        user2 = new User("Bob", "1234", "1234");

    }
    //    @DisplayName("Testing setId and getId: ");
    @Test
    void testSetAndGetId() {
        int identifier = 1;
        user1.setId(identifier);
        assertNotNull(user1.getId());
        assertEquals(identifier, user1.getId());
        assertNotEquals(5, user1.getId());

    }

    @Test
    void testSetAndGetUsername() {
        String username2 = "David";
        user1.setUsername(username2);
        assertNotNull(user1.getUsername());
        assertEquals(username2, user1.getUsername());

    }

    @Test
    void testGetUsernameAndPassword() {
        assertNotNull(user1.getUsername());
        assertNotNull(user1.getPassword());
        assertNotNull(user2.getUsername());
        assertNotNull(user2.getPassword());
        assertEquals("pass123", user1.getPassword());
        assertEquals("1234", user2.getPassword());
    }

    @Test
    void setUsernameAndPassword() {
        User user3 = new User("","");
        String username3 = "David";
        String password3 = "password";
        user3.setUsername(username3);
        user3.setPassword(password3);
        assertNotNull(user3.getUsername());
        assertNotNull(user3.getPassword());
        assertEquals(password3, user3.getPassword());
    }

    @Test
    void testConfirmPassword() {
        assertNotNull(user2.getConfirmPassword());
        User user4 = new User("Matt","1212","1212");
        assertEquals(user4.getPassword(), user4.getConfirmPassword());
        User user5 = new User("Bill", "1111", "");
        user5.setConfirmPassword("1111");
        assertEquals(user5.getPassword(), user5.getConfirmPassword());
    }

}