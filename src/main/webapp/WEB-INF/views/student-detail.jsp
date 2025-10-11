<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Student Detail" active="students">
  <jsp:body>
    <c:if test="${not empty student}">
      <h1>${student.name}</h1>
      <p>Email: ${student.email}</p>
    </c:if>
    <p><a class="btn" href="${pageContext.request.contextPath}/students">Back</a></p>
  </jsp:body>
</layout:page>
