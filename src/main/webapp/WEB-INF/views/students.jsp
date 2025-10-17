<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:admin-dashboard pageTitle="Students" activePage="students">
  <jsp:attribute name="alerts">
    <jsp:include page="fragments/alerts.jspf" />
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>console.log('Students page loaded');</script>
  </jsp:attribute>
  <jsp:body>
    <p><a class="c-btn" href="${pageContext.request.contextPath}/students/add"><i data-lucide="plus"></i> Add Student</a></p>
    <div class="c-table-wrap">
      <table class="c-table" aria-label="Students list">
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
            <td><a class="c-btn c-btn--sm" href="${pageContext.request.contextPath}/students/detail?id=${s.id}">View</a></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </jsp:body>
</layout:admin-dashboard>
