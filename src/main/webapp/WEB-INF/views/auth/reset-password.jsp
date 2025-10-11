<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="auth" tagdir="/WEB-INF/tags/auth" %>
<layout:auth title="Reset Password">
  <h1 class="c-auth__title" id="auth-title">Set new password</h1>
  <p
    class="u-text-muted"
    style="
      margin-top: -0.75rem;
      margin-bottom: var(--space-8);
      font-size: var(--fs-sm);
    "
  >
    Enter your new password below.
  </p>
  <c:if test="${not empty error}">
    <div class="c-field__error" style="text-align: center; font-size: var(--fs-sm); margin-bottom: var(--space-4);">${error}</div>
  </c:if>
  <form class="c-auth__form js-reset-form js-validate" method="post" action="${pageContext.request.contextPath}/reset-password" novalidate>
    <input type="hidden" name="token" value="${token}" />
    <auth:field 
      id="password" 
      name="password" 
      label="New Password" 
      type="password" 
      placeholder="Enter your new password" 
      required="true" 
      minlength="6"
      autofocus="true"
    />
    <auth:field 
      id="confirm" 
      name="confirm" 
      label="Confirm Password" 
      type="password" 
      placeholder="Confirm your new password" 
      required="true" 
      minlength="6"
    />
    <auth:button text="Update Password" />
  </form>
  <div class="c-auth__switch">
    <auth:link href="${pageContext.request.contextPath}/login" text="Back to Login" />
  </div>
  <footer class="c-auth__legal">
    <auth:link href="#" text="Terms of Service" muted="true" />
    <span aria-hidden="true">·</span>
    <auth:link href="#" text="Privacy Policy" muted="true" />
  </footer>
</layout:auth>
