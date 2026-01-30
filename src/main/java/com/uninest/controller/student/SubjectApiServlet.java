package com.uninest.controller.student;

import com.google.gson.Gson;
import com.uninest.model.Subject;
import com.uninest.model.User;
import com.uninest.model.dao.SubjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SubjectApiServlet", urlPatterns = "/student/api/subjects")
public class SubjectApiServlet extends HttpServlet {
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null || user.getCommunityId() == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not in a community");
            return;
        }

        String yearStr = req.getParameter("year");
        String semStr = req.getParameter("semester");

        if (yearStr == null || semStr == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing year or semester parameters");
            return;
        }

        try {
            int year = Integer.parseInt(yearStr);
            int semester = Integer.parseInt(semStr);

            List<Subject> subjects = subjectDAO.findByCommunityAndYearAndSemester(
                    user.getCommunityId(), year, semester
            );

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(gson.toJson(subjects));
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid format for year or semester");
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
        }
    }
}
