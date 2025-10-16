<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Join Organization">
  <h1 class="c-auth__title">Enter your organization ID</h1>
  <p class="c-text c-text--muted">Ask your moderator for the approved organization ID.</p>
  <c:if test="${not empty error}">
    <div class="c-field__error" style="text-align: center; font-size: var(--fs-sm); margin-bottom: var(--space-4);">${error}</div>
  </c:if>
  <form class="c-auth__form js-auth-form" method="post" action="${pageContext.request.contextPath}/student/join-organization" novalidate>
    <div class="c-field" style="grid-column: 1 / -1;">
      <label for="organizationId" class="c-field__label">Organization ID</label>
      <input type="number" id="organizationId" name="organizationId" class="c-field__input" placeholder="e.g. 1024" required />
      <p class="c-field__error" data-error-for="organizationId" aria-live="polite"></p>
    </div>
    <button type="submit" class="c-btn c-btn--primary c-auth__submit" style="grid-column: 1 / -1;">Join</button>
  </form>
</layout:auth>
