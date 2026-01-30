package com.uninest.controller.student;

import com.uninest.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;

@WebServlet(name = "profileImageServlet", urlPatterns = "/student/profile-image")
public class ProfileImageServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID required");
            return;
        }

        try {
            int userId = Integer.parseInt(idStr);
            byte[] imageData = userDAO.getProfileImage(userId);

            if (imageData != null && imageData.length > 0) {
                resp.setContentType("image/jpeg"); // Default to JPEG
                resp.setContentLength(imageData.length);
                try (OutputStream out = resp.getOutputStream()) {
                    out.write(imageData);
                }
            } else {
                // If no image, redirect to default avatar or return 404
                // Redirecting to the default avatar url used in User model
                resp.sendRedirect("https://i.pravatar.cc/300?img=12");
            }

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid User ID");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching image");
        }
    }
}
