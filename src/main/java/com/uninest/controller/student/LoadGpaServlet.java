package com.uninest.controller.student;

import com.google.gson.Gson;
import com.uninest.model.GpaEntry;
import com.uninest.model.User;
import com.uninest.model.dao.GpaEntryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "LoadGpaServlet", urlPatterns = "/student/api/gpa/load")
public class LoadGpaServlet extends HttpServlet {

    private final GpaEntryDAO gpaEntryDAO = new GpaEntryDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
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

            List<GpaEntry> entries = gpaEntryDAO.findByStudentYearSemester(user.getId(), year, semester);

            resp.getWriter().write(gson.toJson(entries));

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid format for year or semester");
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
        }
    }
}
