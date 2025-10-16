<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Pending Approval">
  <div class="c-state">
    <div class="c-state__icon">
      <i data-lucide="clock"></i>
    </div>
    <div class="c-state__body">
      <h1 class="c-state__title">Organization Pending Approval</h1>
      <p class="c-state__text">
        Your organization "<strong>${organization.title}</strong>" has been submitted for review.
      </p>
      <p class="c-state__text">
        Please wait for the administrator to approve your organization. You will be able to access the dashboard once approved.
      </p>
      <c:if test="${organization.status == 'rejected'}">
        <p class="c-field__error" style="text-align: center; margin-top: var(--space-4);">
          Your organization has been rejected. Please contact the administrator for more information.
        </p>
      </c:if>
    </div>
  </div>
  <div class="c-auth__switch" style="margin-top: var(--space-8);">
    <form method="post" action="${pageContext.request.contextPath}/logout" style="display: inline;">
      <button type="submit" class="c-link" style="background: none; border: none; cursor: pointer; padding: 0;">Logout</button>
    </form>
  </div>
  <footer class="c-auth__legal">
    <a href="#" class="c-link c-link--muted">Terms of Service</a>
    <span aria-hidden="true">·</span>
    <a href="#" class="c-link c-link--muted">Privacy Policy</a>
  </footer>
</layout:auth>
