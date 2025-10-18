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

@WebServlet(name = "adminEditModerator", urlPatterns = "/admin/moderators/edit")
public class EditModeratorServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final CommunityDAO communityDAO = new CommunityDAO();
    private final UniversityDAO universityDAO = new UniversityDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/moderators");
            return;
        }

        int id = Integer.parseInt(idStr);
        Optional<User> moderatorOpt = userDAO.findById(id);
        
        if (moderatorOpt.isEmpty() || !moderatorOpt.get().isModerator()) {
            resp.sendRedirect(req.getContextPath() + "/admin/moderators");
            return;
        }

        req.setAttribute("moderator", moderatorOpt.get());
        req.setAttribute("communities", communityDAO.findByStatus("approved"));
        req.setAttribute("universities", universityDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/edit-moderator.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/moderators");
            return;
        }

        int id = Integer.parseInt(idStr);
        Optional<User> moderatorOpt = userDAO.findById(id);
        
        if (moderatorOpt.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/moderators");
            return;
        }

        User moderator = moderatorOpt.get();
        
        String name = req.getParameter("name");
        if (name != null && !name.isEmpty()) {
            moderator.setName(name);
        } else {
            moderator.setName(null);
        }
        
        moderator.setEmail(req.getParameter("email"));
        
        String academicYearStr = req.getParameter("academicYear");
        if (academicYearStr != null && !academicYearStr.isEmpty()) {
            moderator.setAcademicYear(Integer.parseInt(academicYearStr));
        } else {
            moderator.setAcademicYear(null);
        }
        
        String universityIdStr = req.getParameter("universityId");
        if (universityIdStr != null && !universityIdStr.isEmpty()) {
            moderator.setUniversityId(Integer.parseInt(universityIdStr));
        } else {
            moderator.setUniversityId(null);
        }
        
        String communityIdStr = req.getParameter("communityId");
        if (communityIdStr != null && !communityIdStr.isEmpty()) {
            moderator.setCommunityId(Integer.parseInt(communityIdStr));
        } else {
            moderator.setCommunityId(null);
        }
        
        // Handle password reset if provided
        String newPassword = req.getParameter("newPassword");
        if (newPassword != null && !newPassword.isEmpty()) {
            String passwordHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            userDAO.updatePassword(moderator.getId(), passwordHash);
        }

        userDAO.update(moderator);
        resp.sendRedirect(req.getContextPath() + "/admin/moderators?success=updated");
    }
}
