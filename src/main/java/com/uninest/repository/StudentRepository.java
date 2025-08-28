package com.uninest.repository;

import com.uninest.model.Student;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

public class StudentRepository {
    private static final Map<Integer, Student> STORE = new LinkedHashMap<>();
    private static final AtomicInteger ID_GEN = new AtomicInteger(1);

    static {
        // seed
        save(new Student(0, "Alice", "alice@example.com"));
        save(new Student(0, "Bob", "bob@example.com"));
    }

    public static List<Student> findAll() {
        return new ArrayList<>(STORE.values());
    }

    public static Student findById(int id) {
        return STORE.get(id);
    }

    public static Student save(Student s) {
        if (s.getId() == 0) {
            s.setId(ID_GEN.getAndIncrement());
        }
        STORE.put(s.getId(), s);
        return s;
    }
}
