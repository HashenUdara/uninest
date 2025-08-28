package com.uninest.controller;

import com.uninest.repository.StudentRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "studentDetail", urlPatterns = "/students/detail")
public class StudentDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/students");
            return;
        }
        try {
            int id = Integer.parseInt(idStr);
            com.uninest.model.Student student = StudentRepository.findById(id);
            if (student == null) {
                req.setAttribute("message", "Student not found");
                req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
                return;
            }
            req.setAttribute("student", student);
            req.getRequestDispatcher("/WEB-INF/views/student-detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            req.setAttribute("message", "Invalid ID");
            req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
        }
    }
}
