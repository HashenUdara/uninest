<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="auth" tagdir="/WEB-INF/tags/auth" %>
<layout:auth title="Reset Requested">
  <div class="c-state">
    <div class="c-state__icon">
      <i data-lucide="check"></i>
    </div>
    <div class="c-state__body">
      <h1 class="c-state__title">Check your email</h1>
      <p class="c-state__text">
        If the email exists, a reset link has been sent. Check your inbox and spam folder.
      </p>
      <c:if test="${emailSent == false}">
        <p class="c-field__error" style="text-align: center;">Failed to send email: ${mailError}</p>
      </c:if>
    </div>
  </div>
  <div class="c-auth__switch" style="margin-top: var(--space-8);">
    <auth:link href="${pageContext.request.contextPath}/login" text="Back to Login" />
  </div>
  <footer class="c-auth__legal">
    <auth:link href="#" text="Terms of Service" muted="true" />
    <span aria-hidden="true">·</span>
    <auth:link href="#" text="Privacy Policy" muted="true" />
  </footer>
</layout:auth>
