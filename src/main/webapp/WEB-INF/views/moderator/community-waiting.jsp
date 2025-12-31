<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Awaiting Approval">
  <div class="c-state">
    <div class="c-state__icon">
      <i data-lucide="hourglass"></i>
    </div>
    <div class="c-state__body">
      <h1 class="c-state__title">Your community is pending approval</h1>
      <p class="c-state__text">
        <c:choose>
          <c:when test="${not empty community}">
            "${community.title}" has been submitted. An admin will review it shortly.
          </c:when>
          <c:otherwise>
            Your request is being processed. Please wait for admin approval.
          </c:otherwise>
        </c:choose>
      </p>
      <p class="c-state__text c-text--muted">You cannot proceed until approval is granted.</p>
    </div>
  </div>
  <div class="c-auth__switch" style="margin-top: var(--space-8);">
    <form method="post" action="${pageContext.request.contextPath}/logout">
      <button class="c-btn c-btn--ghost" type="submit">Logout</button>
    </form>
  </div>
</layout:auth>
