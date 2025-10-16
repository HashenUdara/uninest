<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Moderator Dashboard" active="moderator">
  <jsp:body>
    <h1>Moderator Dashboard</h1>
    <p>Welcome, <strong>${sessionScope.authUser.email}</strong> (role: ${sessionScope.authUser.role})</p>
    <p>As a moderator, you can review, edit, or remove inappropriate resources.</p>
    
    <c:if test="${not empty organization}">
      <div style="background-color: #e7f3ff; border: 1px solid #b3d9ff; padding: 1rem; margin: 1rem 0; border-radius: 4px;">
        <h3 style="margin-top: 0;">Your Organization</h3>
        <p><strong>Name:</strong> ${organization.title}</p>
        <p><strong>Organization ID:</strong> <code style="background-color: #fff; padding: 0.25rem 0.5rem; border-radius: 3px; font-size: 1.1em;">${organization.id}</code></p>
        <p style="color: #666; font-size: 0.9em;">Share this ID with students so they can join your organization.</p>
      </div>
    </c:if>
    
    <ul>
      <li><a class="btn" href="${pageContext.request.contextPath}/students">Manage Students</a></li>
      <li><form style="display:inline;" method="post" action="${pageContext.request.contextPath}/logout"><button class="btn danger" type="submit">Logout</button></form></li>
    </ul>
  </jsp:body>
</layout:page>
