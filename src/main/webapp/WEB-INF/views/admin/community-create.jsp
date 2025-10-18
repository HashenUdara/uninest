<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:admin-dashboard pageTitle="Create Community" activePage="communities">
  <header class="c-page__header">
      <nav class="c-breadcrumbs" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
        <span class="c-breadcrumbs__sep">/</span>
        <a href="${pageContext.request.contextPath}/admin/communities">Communities</a>
        <span class="c-breadcrumbs__sep">/</span>
        <span aria-current="page">Create</span>
      </nav>
      <div class="c-page__titlebar">
        <div>
          <h1 class="c-page__title">Create community</h1>
          <p class="c-page__subtitle u-text-muted">Add a new community.</p>
        </div>
        <a class="c-btn c-btn--ghost" href="${pageContext.request.contextPath}/admin/communities">
          <i data-lucide="arrow-left"></i> Back to Communities
        </a>
      </div>
    </header>

    <section>
      <form class="c-form" action="${pageContext.request.contextPath}/admin/communities/create" method="post">
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
                      placeholder="Brief description (what does this community do?)" required></textarea>
            <div class="c-field__error"></div>
          </div>

          <div class="c-form-actions">
            <a class="c-btn c-btn--ghost" href="${pageContext.request.contextPath}/admin/communities">Cancel</a>
            <button type="submit" class="c-btn">Create Community</button>
          </div>
        </div>
      </form>
    </section>
</layout:admin-dashboard>
