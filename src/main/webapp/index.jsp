<%@ page contentType="text/html;charset=UTF-8" %>
<%
  // Simple welcome redirect to main students list to avoid duplicate layout code
  response.sendRedirect(request.getContextPath() + "/students");
%>
