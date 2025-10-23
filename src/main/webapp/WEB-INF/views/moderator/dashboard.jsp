<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<layout:moderator-dashboard activePage="dashboard">
  <dash:section title="Welcome, ${sessionScope.authUser.email}">
    <p>As a moderator, you can review, edit, or remove inappropriate resources.</p>
    <c:if test="${not empty community}">
      <p class="u-text-muted" style="margin-top: var(--space-2);">
        <strong>Community:</strong> ${community.title} <span style="color: var(--clr-text-muted);">(ID: ${community.id})</span>
      </p>
    </c:if>
  </dash:section>
  
  <dash:section title="Moderation Overview">
    <dash:grid>
      <dash:card title="Pending Reviews" meta="15 items awaiting review" />
      <dash:card title="Reported Content" meta="3 new reports" />
      <dash:card title="Approved Today" meta="28 resources approved" />
      <dash:card title="Rejected Items" meta="5 items rejected" />
    </dash:grid>
  </dash:section>
</layout:moderator-dashboard>
