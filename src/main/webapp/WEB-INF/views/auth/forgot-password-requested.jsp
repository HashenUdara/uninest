<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
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
    <a href="${pageContext.request.contextPath}/login" class="c-link">Back to Login</a>
  </div>
  <footer class="c-auth__legal">
    <a href="#" class="c-link c-link--muted">Terms of Service</a>
    <span aria-hidden="true">·</span>
    <a href="#" class="c-link c-link--muted">Privacy Policy</a>
  </footer>
</layout:auth>
