<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Reset Password" active="login">
  <jsp:body>
    <h1>Reset Password</h1>
    <c:if test="${not empty error}"><div class="alert error">${error}</div></c:if>
    <form method="post" action="${pageContext.request.contextPath}/reset-password">
      <input type="hidden" name="token" value="${token}" />
      <p><label>New Password<br/><input type="password" name="password" required /></label></p>
      <p><label>Confirm Password<br/><input type="password" name="confirm" required /></label></p>
      <p><button class="btn" type="submit">Update Password</button></p>
      <p><a class="btn" href="${pageContext.request.contextPath}/login">Cancel</a></p>
    </form>
  </jsp:body>
</layout:page>
