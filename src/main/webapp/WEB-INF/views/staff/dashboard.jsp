<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Staff Dashboard" active="staff">
  <jsp:body>
    <h1>Staff Dashboard</h1>
  <p>Welcome, <strong>${sessionScope.authUser.email}</strong> (role: ${sessionScope.authUser.role})</p>
    <ul>
      <li><a class="btn" href="${pageContext.request.contextPath}/students">View Students</a></li>
      <li><form style="display:inline;" method="post" action="${pageContext.request.contextPath}/logout"><button class="btn danger" type="submit">Logout</button></form></li>
    </ul>
  </jsp:body>
</layout:page>
