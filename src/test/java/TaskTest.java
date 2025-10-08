package model;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

class TaskTest {
    private Task task1;
    private Task task2;
    private Task task3;

    @BeforeEach
    void setUp() {
        task1 = new Task(12, 1, "Math Homework", "Complete exercises 1–10", LocalDateTime.of(2025,10,15,9,30), "TODO");
        task2 = new Task(14, 1, "Science Project", "Build a volcano model", LocalDateTime.of(2025,9,20,12,30), "IN_PROGRESS");
        task3 = new Task();
    }

    @Test
    void testSetAndGetId() {
        assertNotNull(task1.getId());
        assertEquals(12, task1.getId());
        Task task3 = new Task();
        task3.setId(1);
        assertEquals(1, task3.getId());
    }

    @Test
    void testSetAndGetUserId() {assertNotNull(task1.getUserId());
        assertEquals(1, task1.getUserId());
        task3.setUserId(2);
        assertEquals(2,task3.getUserId());
    }

    @Test
    void testSetAndGetTitle() {
        assertNotNull(task1.getTitle());
        assertEquals("Math Homework", task1.getTitle());
        String title = "Python tasks";
        task3.setTitle(title);
        assertEquals(title, task3.getTitle());
    }

    @Test
    void testSetAndGetDescription() {
        assertNotNull(task1.getDescription());
        assertEquals("Complete exercises 1–10", task1.getDescription());
        String description = "Coming to the exam";
        task3.setDescription(description);
        assertEquals(description, task3.getDescription());
    }

    @Test
    void testSetAndGetDueDate() {
        assertNotNull(task1.getDueDate());
        assertEquals(LocalDateTime.of(2025,10,15,9,30), task1.getDueDate());
        LocalDateTime dueDate = LocalDateTime.of(2025,12,2,8,0);
        task3.setDueDate(dueDate);
        assertEquals(dueDate, task3.getDueDate());
    }

    @Test
    void testSetAndGetStatus() {
        assertNotNull(task1.getStatus());
        assertEquals("TODO", task1.getStatus());
        String status = "IN_PROGRESS";
        task3.setStatus(status);
        assertEquals(status, task3.getStatus());
    }

}