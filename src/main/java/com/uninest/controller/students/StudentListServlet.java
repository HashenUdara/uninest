package com.uninest.controller.students;

import com.uninest.model.dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "studentList", urlPatterns = "/students")
public class StudentListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("1".equals(req.getParameter("added"))) {
            req.setAttribute("flash_success", "Student added successfully");
        }
        req.setAttribute("students", new StudentDAO().findAll());
        req.getRequestDispatcher("/WEB-INF/views/students.jsp").forward(req, resp);
    }
}
