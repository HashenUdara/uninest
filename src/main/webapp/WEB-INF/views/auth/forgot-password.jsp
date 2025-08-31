<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Forgot Password" active="login">
  <jsp:body>
    <h1>Forgot Password</h1>
    <p>Enter your account email. If it exists we'll generate a reset token and show it (demo only).</p>
    <c:if test="${not empty error}">
      <div class="alert error">${error}</div>
    </c:if>
    <form method="post">
      <p><label>Email<br/><input type="email" name="email" value="${emailValue}" required autofocus /></label></p>
      <p><button class="btn" type="submit">Generate Reset Link</button></p>
      <p><a class="btn" href="${pageContext.request.contextPath}/login">Back to login</a></p>
    </form>
  </jsp:body>
</layout:page>
