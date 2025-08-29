<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Login" active="">
  <jsp:body>
    <h1 style="margin-top:0;">Login</h1>
    <c:if test="${not empty error}">
      <div class="alert error">${error}</div>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/login">
      <p><label>Email<br/><input name="email" type="email" autocomplete="username" required /></label></p>
      <p><label>Password<br/><input name="password" type="password" autocomplete="current-password" required /></label></p>
      <p><button class="btn" type="submit">Login</button></p>
    </form>
  </jsp:body>
</layout:page>
