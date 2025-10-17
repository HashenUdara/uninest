<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:admin-dashboard title="Create Organization" active="organizations">
  <jsp:attribute name="content">
    <header class="c-page__header">
      <nav class="c-breadcrumbs" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
        <span class="c-breadcrumbs__sep">/</span>
        <a href="${pageContext.request.contextPath}/admin/organizations">Organizations</a>
        <span class="c-breadcrumbs__sep">/</span>
        <span aria-current="page">Create</span>
      </nav>
      <div class="c-page__titlebar">
        <div>
          <h1 class="c-page__title">Create organization</h1>
          <p class="c-page__subtitle u-text-muted">Add a new organization.</p>
        </div>
        <a class="c-btn c-btn--ghost" href="${pageContext.request.contextPath}/admin/organizations">
          <i data-lucide="arrow-left"></i> Back to Organizations
        </a>
      </div>
    </header>

    <section>
      <form class="c-form" action="${pageContext.request.contextPath}/admin/organizations/create" method="post">
        <div class="c-form-card">
          <div class="c-field">
            <label class="c-field__label" for="org-title">Title</label>
            <input class="c-field__input" id="org-title" name="title" type="text" 
                   placeholder="e.g., Northshore Group" required />
            <div class="c-field__error"></div>
          </div>

          <div class="c-field">
            <label class="c-field__label" for="org-desc">Description</label>
            <textarea class="c-field__input" id="org-desc" name="description" rows="4" 
                      placeholder="Brief description (what does this organization do?)" required></textarea>
            <div class="c-field__error"></div>
          </div>

          <div class="c-form-actions">
            <a class="c-btn c-btn--ghost" href="${pageContext.request.contextPath}/admin/organizations">Cancel</a>
            <button type="submit" class="c-btn">Create Organization</button>
          </div>
        </div>
      </form>
    </section>
  </jsp:attribute>
</layout:admin-dashboard>
