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
import java.util.*;

@WebServlet(name = "GpaSummaryServlet", urlPatterns = "/student/api/gpa/summary")
public class GpaSummaryServlet extends HttpServlet {

    private final GpaEntryDAO gpaEntryDAO = new GpaEntryDAO();
    private final Gson gson = new Gson();

    // Response structure
    private static class GpaSummary {
        String cumulative;
        List<TermGpa> terms = new ArrayList<>();
    }

    private static class TermGpa {
        int year;
        int semester;
        String gpa;

        TermGpa(int year, int semester, String gpa) {
            this.year = year;
            this.semester = semester;
            this.gpa = gpa;
        }
    }

    // Grade scale map
    private static final Map<String, Double> SCALE = new HashMap<>();
    static {
        SCALE.put("A+", 4.0);
        SCALE.put("A", 4.0);
        SCALE.put("A-", 3.7);
        SCALE.put("B+", 3.3);
        SCALE.put("B", 3.0);
        SCALE.put("B-", 2.7);
        SCALE.put("C+", 2.3);
        SCALE.put("C", 2.0);
        SCALE.put("C-", 1.7);
        SCALE.put("D", 1.0);
        SCALE.put("F", 0.0);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        try {
            List<GpaEntry> entries = gpaEntryDAO.findAllByStudent(user.getId());

            // Calculate Cum GPA
            double totalPoints = 0;
            double totalCredits = 0;

            // Group by term
            Map<String, List<GpaEntry>> termGroups = new LinkedHashMap<>();

            for (GpaEntry entry : entries) {
                if (entry.getGrade() == null || !SCALE.containsKey(entry.getGrade()))
                    continue;

                double points = SCALE.get(entry.getGrade()) * entry.getCredits();
                totalPoints += points;
                totalCredits += entry.getCredits();

                String termKey = entry.getAcademicYear() + "-" + entry.getSemester();
                termGroups.computeIfAbsent(termKey, k -> new ArrayList<>()).add(entry);
            }

            GpaSummary summary = new GpaSummary();
            summary.cumulative = totalCredits > 0 ? String.format("%.2f", totalPoints / totalCredits) : "0.00";

            // Calculate Term GPAs
            for (Map.Entry<String, List<GpaEntry>> group : termGroups.entrySet()) {
                String[] parts = group.getKey().split("-");
                int year = Integer.parseInt(parts[0]);
                int sem = Integer.parseInt(parts[1]);

                double termPoints = 0;
                double termCredits = 0;

                for (GpaEntry e : group.getValue()) {
                    termPoints += SCALE.get(e.getGrade()) * e.getCredits();
                    termCredits += e.getCredits();
                }

                String termGpa = termCredits > 0 ? String.format("%.2f", termPoints / termCredits) : "0.00";
                summary.terms.add(new TermGpa(year, sem, termGpa));
            }

            // Sort terms newest first? Or oldest first?
            // Let's sort simply by year then semester (Ascending)
            summary.terms.sort(Comparator.comparingInt((TermGpa t) -> t.year).thenComparingInt(t -> t.semester));

            resp.getWriter().write(gson.toJson(summary));

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error calculating GPA summary: " + e.getMessage());
        }
    }
}
