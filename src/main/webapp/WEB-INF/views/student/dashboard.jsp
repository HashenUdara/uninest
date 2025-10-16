<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dashboard-new title="Student Dashboard" active="student" breadcrumb="Student Dashboard">
  <jsp:body>
    <div class="c-section">
      <div class="c-state">
        <div class="c-state__icon">
          <i data-lucide="graduation-cap"></i>
        </div>
        <div class="c-state__body">
          <h2 class="c-state__title">Welcome, ${sessionScope.authUser.email}</h2>
          <p class="c-state__text">Access your student resources and manage your academic journey.</p>
        </div>
      </div>
      
      <div class="o-grid o-grid--cards">
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">My Subjects</h3>
            <p class="c-card__meta">View your enrolled subjects and progress</p>
            <a href="#" class="c-btn c-btn--secondary">View Subjects</a>
          </div>
        </article>
        
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">Resources</h3>
            <p class="c-card__meta">Access study materials and resources</p>
            <a href="#" class="c-btn c-btn--secondary">View Resources</a>
          </div>
        </article>
        
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">Join Organization</h3>
            <p class="c-card__meta">Join student organizations</p>
            <a href="${pageContext.request.contextPath}/student/join-organization" class="c-btn c-btn--secondary">Join Organization</a>
          </div>
        </article>
        
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">View Students</h3>
            <p class="c-card__meta">Browse other students</p>
            <a href="${pageContext.request.contextPath}/students" class="c-btn c-btn--secondary">View Students</a>
          </div>
        </article>
      </div>
    </div>
  </jsp:body>
</layout:dashboard-new>
