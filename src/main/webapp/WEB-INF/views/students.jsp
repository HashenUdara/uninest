<%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Students" />
<jsp:include page="fragments/header.jspf" />
<h1>Students</h1>
<a href="${pageContext.request.contextPath}/students/add">Add Student</a>
<table border="1" cellpadding="5" cellspacing="0">
  <tr>
    <th>ID</th>
    <th>Name</th>
    <th>Email</th>
    <th>Action</th>
  </tr>
  <c:forEach items="${students}" var="s">
    <tr>
      <td>${s.id}</td>
      <td>${s.name}</td>
      <td>${s.email}</td>
      <td>
        <a href="${pageContext.request.contextPath}/students/detail?id=${s.id}"
          >View</a
        >
      </td>
    </tr>
  </c:forEach>
</table>
<jsp:include page="fragments/footer.jspf" />
