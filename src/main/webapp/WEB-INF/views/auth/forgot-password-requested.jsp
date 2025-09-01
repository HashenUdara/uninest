<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Reset Requested" active="login">
  <jsp:body>
    <h1>Reset Requested</h1>
    <p>If the email exists, a reset link has been sent (check your inbox and spam folder).</p>
    <c:if test="${emailSent == false}">
      <div class="alert error">Failed to send email: ${mailError}</div>
    </c:if>
    <p><a class="btn" href="${pageContext.request.contextPath}/login">Back to login</a></p>
  </jsp:body>
</layout:page>
