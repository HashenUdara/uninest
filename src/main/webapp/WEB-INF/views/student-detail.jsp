<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<layout:admin-dashboard pageTitle="Student Detail" activePage="students">
  <jsp:body>
    <c:if test="${not empty student}">
      <dash:section title="${student.name}">
        <p><strong>Email:</strong> ${student.email}</p>
      </dash:section>
    </c:if>
    <p><a class="c-btn c-btn--ghost" href="${pageContext.request.contextPath}/students"><i data-lucide="arrow-left"></i> Back to Students</a></p>
  </jsp:body>
</layout:admin-dashboard>
