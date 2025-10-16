<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Students" active="students">
  <jsp:attribute name="alerts">
    <jsp:include page="fragments/alerts.jspf" />
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>console.log('Students page loaded');</script>
  </jsp:attribute>
  <jsp:body>
    <h1 style="margin-top:0;">Students</h1>
    <p><a class="btn" href="${pageContext.request.contextPath}/students/add">Add Student</a></p>
    <table class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Email</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
      <c:forEach items="${students}" var="s">
        <tr>
          <td>${s.id}</td>
          <td>${s.name}</td>
          <td>${s.email}</td>
          <td><a class="btn" href="${pageContext.request.contextPath}/students/detail?id=${s.id}">View</a></td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </jsp:body>
</layout:page>
