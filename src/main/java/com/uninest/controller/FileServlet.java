package com.uninest.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet(name = "fileServlet", urlPatterns = "/uploads/*")
public class FileServlet extends HttpServlet {
    
    private static final String UPLOAD_BASE_PATH = System.getProperty("user.home") + "/uninest-uploads";
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get the file path from the URL
        String requestedFile = req.getPathInfo(); // e.g., /resources/123456_document.pdf
        
        if (requestedFile == null || requestedFile.equals("/")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "File path is required");
            return;
        }
        
        // Remove leading slash
        if (requestedFile.startsWith("/")) {
            requestedFile = requestedFile.substring(1);
        }
        
        // Construct the full file path
        File file = new File(UPLOAD_BASE_PATH + File.separator + requestedFile);
        
        // Security check: make sure the file is within the upload directory
        String canonicalUploadPath = new File(UPLOAD_BASE_PATH).getCanonicalPath();
        String canonicalFilePath = file.getCanonicalPath();
        
        if (!canonicalFilePath.startsWith(canonicalUploadPath)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        if (!file.exists() || !file.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }
        
        // Set content type based on file extension
        String fileName = file.getName();
        String contentType = getServletContext().getMimeType(fileName);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        
        resp.setContentType(contentType);
        resp.setContentLengthLong(file.length());
        resp.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
        
        // Stream the file to the response
        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = resp.getOutputStream()) {
            
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
