<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
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
    
    <div class="c-field">
      <label for="password" class="c-field__label">New Password</label>
      <input
        type="password"
        id="password"
        name="password"
        class="c-field__input"
        placeholder="Enter your new password"
        required
        minlength="6"
        autofocus
      />
      <p class="c-field__error" data-error-for="password" aria-live="polite"></p>
    </div>
    
    <div class="c-field">
      <label for="confirm" class="c-field__label">Confirm Password</label>
      <input
        type="password"
        id="confirm"
        name="confirm"
        class="c-field__input"
        placeholder="Confirm your new password"
        required
        minlength="6"
      />
      <p class="c-field__error" data-error-for="confirm" aria-live="polite"></p>
    </div>
    
    <button type="submit" class="c-btn c-btn--primary c-auth__submit">Update Password</button>
  </form>
  <div class="c-auth__switch">
    <a href="${pageContext.request.contextPath}/login" class="c-link">Back to Login</a>
  </div>
  <footer class="c-auth__legal">
    <a href="#" class="c-link c-link--muted">Terms of Service</a>
    <span aria-hidden="true">·</span>
    <a href="#" class="c-link c-link--muted">Privacy Policy</a>
  </footer>
</layout:auth>
