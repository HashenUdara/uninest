package com.uninest.controller.admin;

import com.uninest.model.User;
import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "adminStudents", urlPatterns = "/admin/students")
public class StudentsServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String searchTerm = req.getParameter("search");
        List<User> students;



        

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            students = userDAO.searchUsers("student", searchTerm.trim());
            req.setAttribute("searchTerm", searchTerm);
        } else {
            students = userDAO.findByRole("student");
        }



        req.setAttribute("students", students);
        req.getRequestDispatcher("/WEB-INF/views/admin/students.jsp").forward(req, resp);
    }
}
