<%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<html>
  <head>
    <title>Student Detail</title>
  </head>
  <body>
    <c:if test="${not empty student}">
      <h1>${student.name}</h1>
      <p>Email: ${student.email}</p>
    </c:if>
    <a href="${pageContext.request.contextPath}/students">Back</a>
  </body>
</html>
