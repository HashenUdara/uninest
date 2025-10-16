<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Pending Approval">
  <div class="c-state">
    <div class="c-state__icon">
      <i data-lucide="clock"></i>
    </div>
    <div class="c-state__body">
      <h1 class="c-state__title">Account Pending Approval</h1>
      <p class="c-state__text">
        Your moderator account has been created successfully. Please wait for an administrator to approve your account before you can access the system.
      </p>
      <p class="c-state__text">
        You will receive an email notification once your account has been approved.
      </p>
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
