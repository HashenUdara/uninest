<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="auth" tagdir="/WEB-INF/tags/auth" %>
<layout:auth title="Forgot Password">
  <h1 class="c-auth__title" id="auth-title">Reset your password</h1>
  <p
    class="u-text-muted"
    style="
      margin-top: -0.75rem;
      margin-bottom: var(--space-8);
      font-size: var(--fs-sm);
    "
  >
    Enter the email associated with your account and we'll send you a reset link.
  </p>
  <c:if test="${not empty error}">
    <div class="c-field__error" style="text-align: center; font-size: var(--fs-sm); margin-bottom: var(--space-4);">${error}</div>
  </c:if>
  <form class="c-auth__form js-forgot-form js-validate" method="post" novalidate>
    <auth:field 
      id="resetEmail" 
      name="email" 
      label="Email" 
      type="email" 
      placeholder="Enter your email" 
      required="true" 
      autocomplete="email"
      value="${emailValue}"
      autofocus="true"
    />
    <auth:button text="Send reset link" />
  </form>
  <div class="c-auth__switch">
    Remembered your password?
    <auth:link href="${pageContext.request.contextPath}/login" text="Login" />
  </div>
  <footer class="c-auth__legal">
    <auth:link href="#" text="Terms of Service" muted="true" />
    <span aria-hidden="true">·</span>
    <auth:link href="#" text="Privacy Policy" muted="true" />
  </footer>
</layout:auth>
