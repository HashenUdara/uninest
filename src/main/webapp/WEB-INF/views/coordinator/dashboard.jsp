<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dashboard-new title="Coordinator Dashboard" active="coordinator" breadcrumb="Coordinator Dashboard">
  <jsp:body>
    <div class="c-section">
      <div class="c-state">
        <div class="c-state__icon">
          <i data-lucide="book-open"></i>
        </div>
        <div class="c-state__body">
          <h2 class="c-state__title">Welcome, ${sessionScope.authUser.email}</h2>
          <p class="c-state__text">As a subject coordinator, you can manage subjects, topics, and upload resources.</p>
        </div>
      </div>
      
      <div class="o-grid o-grid--cards">
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">Manage Subjects</h3>
            <p class="c-card__meta">Create and manage subject content</p>
            <a href="#" class="c-btn c-btn--secondary">Manage Subjects</a>
          </div>
        </article>
        
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">Upload Resources</h3>
            <p class="c-card__meta">Upload study materials and resources</p>
            <a href="#" class="c-btn c-btn--secondary">Upload Resources</a>
          </div>
        </article>
        
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">Student Management</h3>
            <p class="c-card__meta">Manage students in your subjects</p>
            <a href="${pageContext.request.contextPath}/students" class="c-btn c-btn--secondary">Manage Students</a>
          </div>
        </article>
      </div>
    </div>
  </jsp:body>
</layout:dashboard-new>
