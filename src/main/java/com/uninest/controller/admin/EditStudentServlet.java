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
import java.util.Optional;

@WebServlet(name = "adminEditStudent", urlPatterns = "/admin/students/edit")
public class EditStudentServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final CommunityDAO communityDAO = new CommunityDAO();
    private final UniversityDAO universityDAO = new UniversityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/students");
            return;
        }

        int id = Integer.parseInt(idStr);
        Optional<User> studentOpt = userDAO.findById(id);
        
        if (studentOpt.isEmpty() || !studentOpt.get().isStudent()) {
            resp.sendRedirect(req.getContextPath() + "/admin/students");
            return;
        }

        req.setAttribute("student", studentOpt.get());
        req.setAttribute("communities", communityDAO.findByStatus("approved"));
        req.setAttribute("universities", universityDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/edit-student.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/students");
            return;
        }

        int id = Integer.parseInt(idStr);
        Optional<User> studentOpt = userDAO.findById(id);
        
        if (studentOpt.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/students");
            return;
        }

        User student = studentOpt.get();
        
        String name = req.getParameter("name");
        if (name != null && !name.isEmpty()) {
            student.setName(name);
        } else {
            student.setName(null);
        }
        
        student.setEmail(req.getParameter("email"));
        
        String academicYearStr = req.getParameter("academicYear");
        if (academicYearStr != null && !academicYearStr.isEmpty()) {
            student.setAcademicYear(Integer.parseInt(academicYearStr));
        } else {
            student.setAcademicYear(null);
        }
        
        String universityIdStr = req.getParameter("universityId");
        if (universityIdStr != null && !universityIdStr.isEmpty()) {
            student.setUniversityId(Integer.parseInt(universityIdStr));
        } else {
            student.setUniversityId(null);
        }
        
        String communityIdStr = req.getParameter("communityId");
        if (communityIdStr != null && !communityIdStr.isEmpty()) {
            student.setCommunityId(Integer.parseInt(communityIdStr));
        } else {
            student.setCommunityId(null);
        }
        
        // Handle password reset if provided
        String newPassword = req.getParameter("newPassword");
        if (newPassword != null && !newPassword.isEmpty()) {
            String passwordHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            userDAO.updatePassword(student.getId(), passwordHash);
        }

        userDAO.update(student);
        resp.sendRedirect(req.getContextPath() + "/admin/students?success=updated");
    }
}
