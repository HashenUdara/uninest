<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dashboard-new title="Admin Dashboard" active="admin" breadcrumb="Admin Dashboard">
  <jsp:body>
    <div class="c-section">
      <div class="c-state">
        <div class="c-state__icon">
          <i data-lucide="shield"></i>
        </div>
        <div class="c-state__body">
          <h2 class="c-state__title">Welcome, ${sessionScope.authUser.email}</h2>
          <p class="c-state__text">As an admin, you have full system privileges including user and content management.</p>
        </div>
      </div>
      
      <div class="o-grid o-grid--cards">
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">Manage Students</h3>
            <p class="c-card__meta">View and manage student accounts</p>
            <a href="${pageContext.request.contextPath}/students" class="c-btn c-btn--secondary">View Students</a>
          </div>
        </article>
        
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">Organizations</h3>
            <p class="c-card__meta">Manage organizations and approvals</p>
            <a href="${pageContext.request.contextPath}/admin/organizations" class="c-btn c-btn--secondary">Manage Organizations</a>
          </div>
        </article>
        
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">System Settings</h3>
            <p class="c-card__meta">Configure system-wide settings</p>
            <a href="#" class="c-btn c-btn--secondary">Settings</a>
          </div>
        </article>
      </div>
    </div>
  </jsp:body>
</layout:dashboard-new>
