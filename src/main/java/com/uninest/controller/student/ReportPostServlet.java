package com.uninest.controller.student;

import com.uninest.model.PostReport;
import com.uninest.model.User;
import com.uninest.model.dao.PostReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ReportPostServlet", urlPatterns = "/student/community/posts/report")
public class ReportPostServlet extends HttpServlet {

    private final PostReportDAO postReportDAO = new PostReportDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("authUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        try {
            int postId = Integer.parseInt(req.getParameter("postId"));
            String reason = req.getParameter("reason");
            String returnUrl = req.getParameter("returnUrl");

            if (returnUrl == null || returnUrl.isEmpty()) {
                returnUrl = req.getContextPath() + "/student/community";
            }

            // Prevent duplicate reports
            if (postReportDAO.hasUserReported(postId, user.getId())) {
                resp.sendRedirect(returnUrl + (returnUrl.contains("?") ? "&" : "?") + "error=already_reported");
                return;
            }

            PostReport report = new PostReport();
            report.setPostId(postId);
            report.setReporterUserId(user.getId());
            report.setReason(reason);

            postReportDAO.createReport(report);

            resp.sendRedirect(returnUrl + (returnUrl.contains("?") ? "&" : "?") + "msg=report_submitted");

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/community?error=invalid_post");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/student/community?error=server_error");
        }
    }
}
