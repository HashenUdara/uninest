package com.uninest.controller.admin;

import com.uninest.model.User;
import com.uninest.model.dao.UserDAO;
import com.uninest.model.dao.CommunityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;

@WebServlet(name = "adminAddStudent", urlPatterns = "/admin/students/add")
public class AddStudentServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final CommunityDAO communityDAO = new CommunityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("communities", communityDAO.findByStatus("approved"));
        req.getRequestDispatcher("/WEB-INF/views/admin/add-student.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String academicYearStr = req.getParameter("academicYear");
        String university = req.getParameter("university");
        String communityIdStr = req.getParameter("communityId");

        User student = new User();
        student.setEmail(email);
        student.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
        student.setRole("student");
        
        if (academicYearStr != null && !academicYearStr.isEmpty()) {
            student.setAcademicYear(Integer.parseInt(academicYearStr));
        }
        
        if (university != null && !university.isEmpty()) {
            student.setUniversity(university);
        }
        
        if (communityIdStr != null && !communityIdStr.isEmpty()) {
            student.setCommunityId(Integer.parseInt(communityIdStr));
        }

        userDAO.create(student);
        resp.sendRedirect(req.getContextPath() + "/admin/students?success=added");
    }
}
