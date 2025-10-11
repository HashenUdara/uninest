<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="auth" tagdir="/WEB-INF/tags/auth" %>
<layout:auth title="Login">
  <h1 class="c-auth__title" id="auth-title">Welcome back</h1>
  <c:if test="${not empty error}">
    <div class="c-field__error" style="text-align: center; font-size: var(--fs-sm); margin-bottom: var(--space-4);">${error}</div>
  </c:if>
  <form class="c-auth__form js-auth-form" method="post" action="${pageContext.request.contextPath}/login" novalidate>
    <auth:field 
      id="email" 
      name="email" 
      label="Email or username" 
      type="email" 
      placeholder="Enter your email or username" 
      required="true" 
      autocomplete="username"
      autofocus="true"
    />
    <auth:field 
      id="password" 
      name="password" 
      label="Password" 
      type="password" 
      placeholder="Enter your password" 
      required="true" 
      autocomplete="current-password"
      minlength="6"
    />
    <div class="c-auth__meta">
      <auth:link href="${pageContext.request.contextPath}/forgot-password" text="Forgot Password?" />
    </div>
    <auth:button text="Login" />
  </form>
  <footer class="c-auth__legal">
    <auth:link href="#" text="Terms of Service" muted="true" />
    <span aria-hidden="true">·</span>
    <auth:link href="#" text="Privacy Policy" muted="true" />
  </footer>
  <jsp:attribute name="scripts">
    <script>
      document.querySelector(".js-auth-form").classList.add("js-validate");
    </script>
  </jsp:attribute>
</layout:auth>
