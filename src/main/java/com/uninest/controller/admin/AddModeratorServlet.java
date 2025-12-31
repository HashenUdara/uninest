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

@WebServlet(name = "adminAddModerator", urlPatterns = "/admin/moderators/add")
public class AddModeratorServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final CommunityDAO communityDAO = new CommunityDAO();
    private final UniversityDAO universityDAO = new UniversityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("communities", communityDAO.findByStatus("approved"));
        req.setAttribute("universities", universityDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/add-moderator.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String academicYearStr = req.getParameter("academicYear");
        String universityIdStr = req.getParameter("universityId");
        String communityIdStr = req.getParameter("communityId");

        User moderator = new User();
        moderator.setEmail(email);
        if (name != null && !name.isEmpty()) {
            moderator.setName(name);
        }
        moderator.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
        moderator.setRole("moderator");
        
        if (academicYearStr != null && !academicYearStr.isEmpty()) {
            moderator.setAcademicYear(Integer.parseInt(academicYearStr));
        }
        
        if (universityIdStr != null && !universityIdStr.isEmpty()) {
            moderator.setUniversityId(Integer.parseInt(universityIdStr));
        }
        
        if (communityIdStr != null && !communityIdStr.isEmpty()) {
            moderator.setCommunityId(Integer.parseInt(communityIdStr));
        }

        userDAO.create(moderator);
        resp.sendRedirect(req.getContextPath() + "/admin/moderators?success=added");
    }
}
