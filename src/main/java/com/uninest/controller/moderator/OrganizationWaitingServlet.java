package com.uninest.controller.moderator;

import com.uninest.model.Organization;
import com.uninest.model.User;
import com.uninest.model.dao.OrganizationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "organizationWaiting", urlPatterns = "/moderator/organization/waiting")
public class OrganizationWaitingServlet extends HttpServlet {
    private final OrganizationDAO organizationDAO = new OrganizationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        Optional<Organization> orgOpt = organizationDAO.findByCreatorUserId(user.getId());
        orgOpt.ifPresent(org -> req.setAttribute("organization", org));
        req.getRequestDispatcher("/WEB-INF/views/moderator/organization-waiting.jsp").forward(req, resp);
    }
}
