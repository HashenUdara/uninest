<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
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
    <div class="c-field">
      <label for="resetEmail" class="c-field__label">Email</label>
      <input
        type="email"
        id="resetEmail"
        name="email"
        class="c-field__input"
        placeholder="Enter your email"
        required
        autocomplete="email"
        autofocus
        value="${emailValue}"
      />
      <p class="c-field__error" data-error-for="resetEmail" aria-live="polite"></p>
    </div>
    
    <button type="submit" class="c-btn c-btn--primary c-auth__submit">Send reset link</button>
  </form>
  <div class="c-auth__switch">
    Remembered your password?
    <a href="${pageContext.request.contextPath}/login" class="c-link">Login</a>
  </div>
  <footer class="c-auth__legal">
    <a href="#" class="c-link c-link--muted">Terms of Service</a>
    <span aria-hidden="true">·</span>
    <a href="#" class="c-link c-link--muted">Privacy Policy</a>
  </footer>
</layout:auth>
