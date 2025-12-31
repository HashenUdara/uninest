package com.uninest.controller.admin;

import com.uninest.model.User;
import com.uninest.model.dao.UserDAO;
import com.uninest.model.dao.CommunityDAO;
import com.uninest.model.dao.UniversityDAO;
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
    private final UniversityDAO universityDAO = new UniversityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("communities", communityDAO.findByStatus("approved"));
        req.setAttribute("universities", universityDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/add-student.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String academicYearStr = req.getParameter("academicYear");
        String universityIdStr = req.getParameter("universityId");
        String communityIdStr = req.getParameter("communityId");

        User student = new User();
        student.setEmail(email);
        if (name != null && !name.isEmpty()) {
            student.setName(name);
        }
        student.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
        student.setRole("student");
        
        if (academicYearStr != null && !academicYearStr.isEmpty()) {
            student.setAcademicYear(Integer.parseInt(academicYearStr));
        }
        
        if (universityIdStr != null && !universityIdStr.isEmpty()) {
            student.setUniversityId(Integer.parseInt(universityIdStr));
        }
        
        if (communityIdStr != null && !communityIdStr.isEmpty()) {
            student.setCommunityId(Integer.parseInt(communityIdStr));
        }

        userDAO.create(student);
        resp.sendRedirect(req.getContextPath() + "/admin/students?success=added");
    }
}
