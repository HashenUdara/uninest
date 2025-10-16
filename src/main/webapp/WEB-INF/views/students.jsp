<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dashboard-new title="Students" active="students" breadcrumb="Students">
  <jsp:attribute name="alerts">
    <jsp:include page="fragments/alerts.jspf" />
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>console.log('Students page loaded');</script>
  </jsp:attribute>
  <jsp:body>
    <div class="c-page__header">
      <div class="c-input-group">
        <input
          class="c-input"
          type="search"
          placeholder="Search students by name or email"
          aria-label="Search students"
        />
        <button class="c-btn">Search</button>
      </div>
      <div class="c-tabs" role="tablist">
        <a href="#" class="c-tabs__link is-active" role="tab" aria-selected="true">All</a>
        <a href="#" class="c-tabs__link" role="tab" aria-selected="false">Active</a>
        <a href="#" class="c-tabs__link" role="tab" aria-selected="false">Inactive</a>
      </div>
    </div>
    
    <div class="c-section">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-6);">
        <h2 class="c-section-title">Student Directory</h2>
        <a href="${pageContext.request.contextPath}/students/add" class="c-btn">Add Student</a>
      </div>
      
      <div class="o-grid o-grid--cards">
        <c:forEach items="${students}" var="s">
          <article class="c-card">
            <div class="c-card__body">
              <h3 class="c-card__title">${s.name}</h3>
              <p class="c-card__meta">${s.email}</p>
              <div style="display: flex; gap: var(--space-2); margin-top: var(--space-3);">
                <a href="${pageContext.request.contextPath}/students/detail?id=${s.id}" class="c-btn c-btn--sm c-btn--secondary">View Details</a>
                <a href="#" class="c-btn c-btn--sm c-btn--ghost">Edit</a>
              </div>
            </div>
          </article>
        </c:forEach>
      </div>
      
      <c:if test="${empty students}">
        <div class="c-state">
          <div class="c-state__icon">
            <i data-lucide="users"></i>
          </div>
          <div class="c-state__body">
            <h3 class="c-state__title">No students found</h3>
            <p class="c-state__text">Get started by adding your first student.</p>
            <a href="${pageContext.request.contextPath}/students/add" class="c-btn">Add Student</a>
          </div>
        </div>
      </c:if>
    </div>
  </jsp:body>
</layout:dashboard-new>
