<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<c:set var="isEdit" value="${not empty topic}" />
<c:set var="formTitle" value="${isEdit ? 'Edit Topic' : 'Create Topic'}" />

<layout:moderator-dashboard pageTitle="${formTitle}" activePage="subjects">
  <header class="c-page__header">
    <nav class="c-breadcrumbs" aria-label="Breadcrumb">
      <a href="${pageContext.request.contextPath}/moderator/dashboard">Moderator</a>
      <span class="c-breadcrumbs__sep">/</span>
      <a href="${pageContext.request.contextPath}/moderator/subjects">Subjects</a>
      <span class="c-breadcrumbs__sep">/</span>
      <a href="${pageContext.request.contextPath}/moderator/topics?subjectId=${subject.subjectId}">${subject.name}</a>
      <span class="c-breadcrumbs__sep">/</span>
      <span aria-current="page">${formTitle}</span>
    </nav>
    <div class="c-page__titlebar">
      <div>
        <h1 class="c-page__title">${formTitle}</h1>
        <p class="c-page__subtitle u-text-muted">${isEdit ? 'Update topic information' : 'Add a new topic to this subject'}</p>
      </div>
    </div>
  </header>

  <c:if test="${not empty error}">
    <div class="c-alert c-alert--danger" role="alert">
      <i data-lucide="alert-circle"></i>
      <span>${error}</span>
    </div>
  </c:if>

  <section>
    <div class="o-panel" style="max-width: 600px;">
      <form method="post" action="${pageContext.request.contextPath}/moderator/topics/${isEdit ? 'edit' : 'create'}">
        <input type="hidden" name="subjectId" value="${subject.subjectId}" />
        <c:if test="${isEdit}">
          <input type="hidden" name="id" value="${topic.topicId}" />
        </c:if>

        <div class="c-form-group">
          <label for="title" class="c-form-label">Topic Title <span style="color: var(--color-danger);">*</span></label>
          <input type="text" id="title" name="title" class="c-input" required 
                 value="${isEdit ? topic.title : ''}" 
                 placeholder="e.g., Trees & Graphs" />
        </div>

        <div class="c-form-group">
          <label for="description" class="c-form-label">Description</label>
          <textarea id="description" name="description" class="c-input" rows="4" 
                    placeholder="Brief description of the topic">${isEdit ? topic.description : ''}</textarea>
        </div>

        <div class="c-form-actions" style="display: flex; gap: var(--space-3); justify-content: flex-end; margin-top: var(--space-6);">
          <a href="${pageContext.request.contextPath}/moderator/topics?subjectId=${subject.subjectId}" class="c-btn c-btn--ghost">Cancel</a>
          <button type="submit" class="c-btn c-btn--primary">
            <i data-lucide="${isEdit ? 'save' : 'plus'}"></i>
            ${isEdit ? 'Update Topic' : 'Create Topic'}
          </button>
        </div>
      </form>
    </div>
  </section>
</layout:moderator-dashboard>
