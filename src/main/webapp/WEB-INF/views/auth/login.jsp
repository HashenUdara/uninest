<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Login">
  <h1 class="c-auth__title" id="auth-title">Welcome back</h1>
  <c:if test="${not empty error}">
    <div class="c-field__error" style="text-align: center; font-size: var(--fs-sm); margin-bottom: var(--space-4);">${error}</div>
  </c:if>
  <form class="c-auth__form js-auth-form" method="post" action="${pageContext.request.contextPath}/login" novalidate>
    <div class="c-field">
      <label for="email" class="c-field__label">Email or username</label>
      <input
        type="email"
        id="email"
        name="email"
        class="c-field__input"
        placeholder="Enter your email or username"
        required
        autocomplete="username"
        autofocus
      />
      <p class="c-field__error" data-error-for="email" aria-live="polite"></p>
    </div>
    
    <div class="c-field">
      <label for="password" class="c-field__label">Password</label>
      <input
        type="password"
        id="password"
        name="password"
        class="c-field__input"
        placeholder="Enter your password"
        required
        autocomplete="current-password"
        minlength="6"
      />
      <p class="c-field__error" data-error-for="password" aria-live="polite"></p>
    </div>
    
    <div class="c-auth__meta">
      <a href="${pageContext.request.contextPath}/forgot-password" class="c-link">Forgot Password?</a>
    </div>
    
    <button type="submit" class="c-btn c-btn--primary c-auth__submit">Login</button>
  </form>
  
  <div class="c-auth__switch">
    Don't have an account? <a href="${pageContext.request.contextPath}/signup" class="c-link">Sign Up</a>
  </div>
  
  <footer class="c-auth__legal">
    <a href="#" class="c-link c-link--muted">Terms of Service</a>
    <span aria-hidden="true">·</span>
    <a href="#" class="c-link c-link--muted">Privacy Policy</a>
  </footer>
  
    <script>
      document.querySelector(".js-auth-form").classList.add("js-validate");
    </script>

</layout:auth>
