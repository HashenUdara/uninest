<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Join Organization">
  <jsp:body>
    <h1 class="c-auth__title" id="auth-title">Join an Organization</h1>
    <p class="c-auth__subtitle" style="text-align: center; margin-bottom: var(--space-6); color: var(--color-muted);">
      Enter your organization ID to continue
    </p>
    <c:if test="${not empty error}">
      <div class="c-field__error" style="text-align: center; font-size: var(--fs-sm); margin-bottom: var(--space-4);">${error}</div>
    </c:if>
    <form class="c-auth__form" method="post" action="${pageContext.request.contextPath}/student/join-organization" novalidate>
      <div class="c-field">
        <label for="organizationId" class="c-field__label">Organization ID</label>
        <input
          type="text"
          id="organizationId"
          name="organizationId"
          class="c-field__input"
          placeholder="Enter your organization ID"
          required
          autofocus
          value="${param.organizationId}"
        />
        <p class="c-field__hint" style="font-size: var(--fs-sm); color: var(--color-muted); margin-top: var(--space-2);">
          Ask your moderator for the organization ID
        </p>
        <p class="c-field__error" data-error-for="organizationId" aria-live="polite"></p>
      </div>
      
      <button type="submit" class="c-btn c-btn--primary c-auth__submit">Join Organization</button>
    </form>
    
    <div class="c-auth__switch" style="margin-top: var(--space-6);">
      <a href="${pageContext.request.contextPath}/logout" class="c-link">Logout</a>
    </div>
  </jsp:body>
</layout:auth>
