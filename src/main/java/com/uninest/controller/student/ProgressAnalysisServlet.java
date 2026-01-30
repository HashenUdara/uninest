package com.uninest.controller.student;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "progressAnalysis", urlPatterns = "/student/progress-analysis/gpa-calculator")
public class ProgressAnalysisServlet extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Construct the config object to match app.js expectation:
        // { years: { "1st Year": { "Semester 1": [], ... }, ... }, scale: {...} }

        Map<String, Object> data = new HashMap<>();

        // 1. Years and Semesters structure
        Map<String, Map<String, List<Object>>> yearsMap = new HashMap<>();

        String[] academicYears = { "1st Year", "2nd Year", "3rd Year", "4th Year" };
        String[] semesters = { "Semester 1", "Semester 2" };

        for (String year : academicYears) {
            Map<String, List<Object>> yearData = new HashMap<>();
            for (String sem : semesters) {
                // Initialize with empty list of subjects for now
                // In future, this comes from DB: List<Subject> ...
                yearData.put(sem, new ArrayList<>());
            }
            yearsMap.put(year, yearData);
        }

        data.put("years", yearsMap);

        // 2. Grading Scale (matching default in app.js for now)
        // We can make this dynamic later if needed
        Map<String, Double> scale = new HashMap<>();
        scale.put("A+", 4.0);
        scale.put("A", 4.0);
        scale.put("A-", 3.7);
        scale.put("B+", 3.3);
        scale.put("B", 3.0);
        scale.put("B-", 2.7);
        scale.put("C+", 2.3);
        scale.put("C", 2.0);
        scale.put("C-", 1.7);
        scale.put("D", 1.0);
        scale.put("F", 0.0);

        data.put("scale", scale);

        // Serialize to JSON
        String json = gson.toJson(data);

        // Pass to JSP
        req.setAttribute("gpaDataJson", json);
        req.getRequestDispatcher("/WEB-INF/views/student/progress-analysis/gpa-calculator.jsp").forward(req, resp);
    }
}
