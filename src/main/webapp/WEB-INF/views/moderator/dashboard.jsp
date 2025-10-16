<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dashboard-new title="Moderator Dashboard" active="moderator" breadcrumb="Moderator Dashboard">
  <jsp:body>
    <div class="c-section">
      <div class="c-state">
        <div class="c-state__icon">
          <i data-lucide="shield-check"></i>
        </div>
        <div class="c-state__body">
          <h2 class="c-state__title">Welcome, ${sessionScope.authUser.email}</h2>
          <p class="c-state__text">As a moderator, you can review, edit, or remove inappropriate resources.</p>
        </div>
      </div>
      
      <div class="o-grid o-grid--cards">
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">Content Review</h3>
            <p class="c-card__meta">Review and moderate content</p>
            <a href="#" class="c-btn c-btn--secondary">Review Content</a>
          </div>
        </article>
        
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">Organization Management</h3>
            <p class="c-card__meta">Manage organization requests</p>
            <a href="${pageContext.request.contextPath}/moderator/organization-waiting" class="c-btn c-btn--secondary">Manage Organizations</a>
          </div>
        </article>
        
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">Student Management</h3>
            <p class="c-card__meta">Manage student accounts</p>
            <a href="${pageContext.request.contextPath}/students" class="c-btn c-btn--secondary">Manage Students</a>
          </div>
        </article>
      </div>
    </div>
  </jsp:body>
</layout:dashboard-new>
