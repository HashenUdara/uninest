package com.uninest.controller;

import com.uninest.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "debugUser", urlPatterns = "/debug/user")
public class DebugUserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        
        User user = (User) req.getSession().getAttribute("authUser");
        
        out.println("<html><body>");
        out.println("<h1>Current User Debug Info</h1>");
        
        if (user == null) {
            out.println("<p style='color: red;'>No user logged in!</p>");
        } else {
            out.println("<table border='1' cellpadding='10'>");
            out.println("<tr><th>Property</th><th>Value</th></tr>");
            out.println("<tr><td>User ID</td><td>" + user.getId() + "</td></tr>");
            out.println("<tr><td>Email</td><td>" + user.getEmail() + "</td></tr>");
            out.println("<tr><td>Name</td><td>" + user.getName() + "</td></tr>");
            out.println("<tr><td>Role Name</td><td><strong style='color: blue;'>" + user.getRole() + "</strong></td></tr>");
            out.println("<tr><td>Community ID</td><td>" + user.getCommunityId() + "</td></tr>");
            out.println("<tr><td>Community Name</td><td>" + user.getCommunityName() + "</td></tr>");
            out.println("<tr><td>Academic Year</td><td>" + user.getAcademicYear() + "</td></tr>");
            out.println("<tr><td>Is Student?</td><td>" + user.isStudent() + "</td></tr>");
            out.println("<tr><td>Is Subject Coordinator?</td><td><strong style='color: " + (user.isSubjectCoordinator() ? "green" : "red") + ";'>" + user.isSubjectCoordinator() + "</strong></td></tr>");
            out.println("<tr><td>Is Moderator?</td><td>" + user.isModerator() + "</td></tr>");
            out.println("<tr><td>Is Admin?</td><td>" + user.isAdmin() + "</td></tr>");
            out.println("</table>");
            
            out.println("<br><h2>How to fix 403 Forbidden:</h2>");
            if (!user.isSubjectCoordinator()) {
                out.println("<p style='color: red;'>❌ You are NOT a subject coordinator. You need to:</p>");
                out.println("<ol>");
                out.println("<li>Login with a subject coordinator account, OR</li>");
                out.println("<li>Update your role in the database to 'subject_coordinator'</li>");
                out.println("</ol>");
            } else {
                out.println("<p style='color: green;'>✅ You ARE a subject coordinator. The /coordinator/* routes should work!</p>");
            }
        }
        
        out.println("</body></html>");
    }
}
