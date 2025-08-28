<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Add Student" active="add">
  <jsp:body>
    <h1 style="margin-top:0;">Add Student</h1>
    <form method="post" action="${pageContext.request.contextPath}/students/add">
      <p><label>Name:<br/><input name="name" /></label></p>
      <p><label>Email:<br/><input name="email" type="email" /></label></p>
      <p><button class="btn" type="submit">Save</button></p>
    </form>
    <p><a class="btn" href="${pageContext.request.contextPath}/students">Back</a></p>
  </jsp:body>
</layout:page>
