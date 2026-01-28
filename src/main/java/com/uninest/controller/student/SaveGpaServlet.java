package com.uninest.controller.student;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.uninest.model.GpaEntry;
import com.uninest.model.User;
import com.uninest.model.dao.GpaEntryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SaveGpaServlet", urlPatterns = "/student/api/gpa/save")
public class SaveGpaServlet extends HttpServlet {

    // Request DTO classes
    private static class SaveRequest {
        int year;
        int semester;
        List<GradeEntry> entries;
    }

    private static class GradeEntry {
        String courseName;
        String grade;
        int credits;
    }

    private final GpaEntryDAO gpaEntryDAO = new GpaEntryDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "User not logged in");
            resp.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            // Read JSON body
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = req.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }

            SaveRequest saveReq = gson.fromJson(sb.toString(), SaveRequest.class);

            if (saveReq == null || saveReq.entries == null || saveReq.entries.isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "No grade data provided");
                resp.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            int successCount = 0;
            for (GradeEntry entry : saveReq.entries) {
                GpaEntry gpaEntry = new GpaEntry(
                        user.getId(),
                        saveReq.year,
                        saveReq.semester,
                        entry.courseName,
                        entry.grade,
                        entry.credits);

                if (gpaEntryDAO.saveOrUpdate(gpaEntry)) {
                    successCount++;
                }
            }

            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("message", "GPA records saved successfully");
            jsonResponse.addProperty("savedCount", successCount);

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Server error: " + e.getMessage());
        }

        resp.getWriter().write(gson.toJson(jsonResponse));
    }
}
