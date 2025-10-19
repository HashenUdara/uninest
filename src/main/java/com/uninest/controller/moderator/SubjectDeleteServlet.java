package com.uninest.controller.moderator;

import com.uninest.model.Subject;
import com.uninest.model.User;
import com.uninest.model.dao.SubjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "subjectDelete", urlPatterns = "/moderator/subjects/delete")
public class SubjectDeleteServlet extends HttpServlet {
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User moderator = (User) req.getSession().getAttribute("authUser");
        
        if (moderator.getCommunityId() == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/dashboard");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects");
            return;
        }

        try {
            int subjectId = Integer.parseInt(idStr);
            Optional<Subject> subjectOpt = subjectDAO.findById(subjectId);
            
            if (subjectOpt.isEmpty() || subjectOpt.get().getCommunityId() != moderator.getCommunityId()) {
                resp.sendRedirect(req.getContextPath() + "/moderator/subjects?error=notfound");
                return;
            }

            subjectDAO.delete(subjectId);
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects?success=deleted");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/moderator/subjects?error=invalid");
        }
    }
}
