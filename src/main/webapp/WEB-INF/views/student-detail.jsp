<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dashboard-new title="Student Detail" active="students" breadcrumb="Student Detail">
  <jsp:body>
    <c:if test="${not empty student}">
      <div class="c-section">
        <div class="c-card" style="max-width: 800px; margin: 0 auto;">
          <div class="c-card__body">
            <div style="display: flex; align-items: center; gap: var(--space-4); margin-bottom: var(--space-6);">
              <div class="c-user-mini__avatar" style="width: 64px; height: 64px; font-size: 1.5rem; display: flex; align-items: center; justify-content: center; background: var(--color-brand-soft); color: var(--color-brand);">
                ${student.name.charAt(0).toUpperCase()}
              </div>
              <div>
                <h2 class="c-page__title" style="margin: 0;">${student.name}</h2>
                <p class="c-page__meta" style="margin: 0;">Student ID: ${student.id}</p>
              </div>
            </div>
            
            <div class="c-kv-grid">
              <div>
                <div class="c-kv-grid__key">Email Address</div>
                <div class="c-kv-grid__val">${student.email}</div>
              </div>
              <div>
                <div class="c-kv-grid__key">Role</div>
                <div class="c-kv-grid__val">${student.role}</div>
              </div>
              <div>
                <div class="c-kv-grid__key">Status</div>
                <div class="c-kv-grid__val">
                  <span style="display: inline-flex; align-items: center; gap: var(--space-1); padding: var(--space-1) var(--space-2); background: var(--color-success-soft); color: var(--color-success); border-radius: var(--radius-pill); font-size: var(--fs-xs);">
                    <i data-lucide="check-circle" style="width: 12px; height: 12px;"></i>
                    Active
                  </span>
                </div>
              </div>
              <div>
                <div class="c-kv-grid__key">Member Since</div>
                <div class="c-kv-grid__val">January 2025</div>
              </div>
            </div>
            
            <div style="display: flex; gap: var(--space-3); margin-top: var(--space-6); padding-top: var(--space-4); border-top: 1px solid var(--color-border);">
              <a href="${pageContext.request.contextPath}/students" class="c-btn c-btn--ghost">
                <i data-lucide="arrow-left" style="width: 16px; height: 16px;"></i>
                Back to Students
              </a>
              <a href="#" class="c-btn c-btn--secondary">
                <i data-lucide="edit" style="width: 16px; height: 16px;"></i>
                Edit Student
              </a>
            </div>
          </div>
        </div>
      </div>
    </c:if>
    
    <c:if test="${empty student}">
      <div class="c-state">
        <div class="c-state__icon">
          <i data-lucide="user-x"></i>
        </div>
        <div class="c-state__body">
          <h3 class="c-state__title">Student not found</h3>
          <p class="c-state__text">The requested student could not be found.</p>
          <a href="${pageContext.request.contextPath}/students" class="c-btn">Back to Students</a>
        </div>
      </div>
    </c:if>
  </jsp:body>
</layout:dashboard-new>
