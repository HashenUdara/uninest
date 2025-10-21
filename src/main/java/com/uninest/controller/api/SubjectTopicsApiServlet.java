package com.uninest.controller.api;

import com.uninest.model.Topic;
import com.uninest.model.dao.TopicDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "subjectTopicsApi", urlPatterns = "/api/subjects/*/topics")
public class SubjectTopicsApiServlet extends HttpServlet {
    private final TopicDAO topicDAO = new TopicDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Parse subject ID from path like /api/subjects/1/topics
            String[] pathParts = req.getRequestURI().split("/");
            int subjectId = -1;
            for (int i = 0; i < pathParts.length; i++) {
                if ("subjects".equals(pathParts[i]) && i + 1 < pathParts.length) {
                    subjectId = Integer.parseInt(pathParts[i + 1]);
                    break;
                }
            }

            if (subjectId == -1) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid subject ID");
                return;
            }

            List<Topic> topics = topicDAO.findBySubjectId(subjectId);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            PrintWriter out = resp.getWriter();
            
            // Manual JSON construction to avoid gson dependency
            out.print("[");
            for (int i = 0; i < topics.size(); i++) {
                Topic t = topics.get(i);
                out.print("{");
                out.print("\"topicId\":" + t.getTopicId() + ",");
                out.print("\"name\":\"" + escapeJson(t.getTitle()) + "\",");
                out.print("\"description\":\"" + escapeJson(t.getDescription()) + "\"");
                out.print("}");
                if (i < topics.size() - 1) out.print(",");
            }
            out.print("]");
            out.flush();
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid subject ID format");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching topics");
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
