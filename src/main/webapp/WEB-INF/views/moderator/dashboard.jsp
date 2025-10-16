<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Moderator Dashboard" active="moderator">
  <jsp:body>
    <h1>Moderator Dashboard</h1>
    <p>Welcome, <strong>${sessionScope.authUser.email}</strong> (role: ${sessionScope.authUser.role})</p>
    <p>As a moderator, you can review, edit, or remove inappropriate resources.</p>
    <ul>
      <li><a class="btn" href="${pageContext.request.contextPath}/students">Manage Students</a></li>
      <li><form style="display:inline;" method="post" action="${pageContext.request.contextPath}/logout"><button class="btn danger" type="submit">Logout</button></form></li>
    </ul>
  </jsp:body>
</layout:page>
