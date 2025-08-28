<%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Student Detail" />
<jsp:include page="fragments/header.jspf" />
<c:if test="${not empty student}">
  <h1>${student.name}</h1>
  <p>Email: ${student.email}</p>
</c:if>
<a href="${pageContext.request.contextPath}/students">Back</a>
<jsp:include page="fragments/footer.jspf" />
