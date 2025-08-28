<%@ page contentType="text/html;charset=UTF-8" %>
<c:set var="pageTitle" value="Add Student" />
<jsp:include page="fragments/header.jspf" />
<h1>Add Student</h1>
<form method="post" action="${pageContext.request.contextPath}/students/add">
  <label>Name: <input name="name" /></label><br />
  <label>Email: <input name="email" type="email" /></label><br />
  <button type="submit">Save</button>
</form>
<a href="${pageContext.request.contextPath}/students">Back</a>
<jsp:include page="fragments/footer.jspf" />
