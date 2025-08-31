<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Reset Requested" active="login">
  <jsp:body>
    <h1>Reset Requested</h1>
    <p>If the email exists, a reset token has been generated.</p>
    <c:if test="${not empty resetToken}">
      <p><strong>Demo Token:</strong> ${resetToken}</p>
      <p><a class="btn" href="${pageContext.request.contextPath}/reset-password?token=${resetToken}">Continue to reset</a></p>
    </c:if>
    <p><a class="btn" href="${pageContext.request.contextPath}/login">Back to login</a></p>
  </jsp:body>
</layout:page>
