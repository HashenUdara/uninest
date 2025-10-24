<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<c:set var="isEdit" value="${not empty topic}" />
<c:set var="formTitle" value="${isEdit ? 'Edit Topic' : 'Create Topic'}" />

<layout:moderator-dashboard pageTitle="${formTitle}" activePage="subjects">
  <style>
    /* Professional Form Styling */
    .topic-form-container {
      max-width: 800px;
      margin: 0 auto;
    }

    .form-card {
      background: var(--color-white);
      border: 1px solid var(--color-border);
      border-radius: 8px;
      padding: var(--space-8);
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }

    .c-form-group {
      margin-bottom: var(--space-6);
    }

    .c-form-label {
      display: block;
      font-size: var(--fs-sm);
      font-weight: 600;
      color: var(--color-text);
      margin-bottom: var(--space-2);
    }

    .c-form-label .required {
      color: #dc2626;
      margin-left: 2px;
    }

    .c-input {
      width: 100%;
      padding: var(--space-3) var(--space-4);
      font-size: var(--fs-base);
      font-family: inherit;
      color: var(--color-text);
      background: var(--color-white);
      border: 1px solid var(--color-border);
      border-radius: 6px;
      transition: all 0.2s ease;
    }

    .c-input:focus {
      outline: none;
      border-color: var(--color-brand);
      box-shadow: 0 0 0 3px rgba(84, 44, 245, 0.1);
    }

    .c-input::placeholder {
      color: var(--color-text-muted);
    }

    textarea.c-input {
      resize: vertical;
      min-height: 120px;
      line-height: 1.6;
    }

    .c-form-actions {
      display: flex;
      gap: var(--space-3);
      justify-content: flex-end;
      margin-top: var(--space-8);
      padding-top: var(--space-6);
      border-top: 1px solid var(--color-border);
    }

    .c-btn {
      display: inline-flex;
      align-items: center;
      gap: var(--space-2);
      padding: var(--space-3) var(--space-5);
      font-size: var(--fs-sm);
      font-weight: 600;
      border-radius: 6px;
      border: 1px solid transparent;
      cursor: pointer;
      transition: all 0.2s ease;
      text-decoration: none;
    }

    .c-btn i {
      width: 18px;
      height: 18px;
    }

    .c-btn--ghost {
      color: var(--color-text-muted);
      background: transparent;
      border-color: var(--color-border);
    }

    .c-btn--ghost:hover {
      background: var(--color-surface);
      color: var(--color-text);
    }

    .c-btn--primary {
      color: white;
      background: var(--color-brand);
      border-color: var(--color-brand);
    }

    .c-btn--primary:hover {
      background: #6d4ef7;
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(84, 44, 245, 0.3);
    }

    .c-alert {
      display: flex;
      align-items: center;
      gap: var(--space-3);
      padding: var(--space-4) var(--space-5);
      border-radius: 6px;
      margin-bottom: var(--space-6);
      font-size: var(--fs-sm);
    }

    .c-alert i {
      width: 20px;
      height: 20px;
      flex-shrink: 0;
    }

    .c-alert--danger {
      background: #fef2f2;
      color: #991b1b;
      border: 1px solid #fecaca;
    }

    .c-page__header {
      margin-bottom: var(--space-8);
    }

    .c-breadcrumbs {
      display: flex;
      align-items: center;
      gap: var(--space-2);
      font-size: var(--fs-sm);
      color: var(--color-text-muted);
      margin-bottom: var(--space-4);
    }

    .c-breadcrumbs a {
      color: var(--color-text-muted);
      text-decoration: none;
      transition: color 0.2s;
    }

    .c-breadcrumbs a:hover {
      color: var(--color-brand);
    }

    .c-breadcrumbs__sep {
      color: var(--color-border);
    }

    .c-page__title {
      font-size: var(--fs-3xl);
      font-weight: 700;
      color: var(--color-text);
      margin: 0 0 var(--space-2) 0;
      letter-spacing: -0.02em;
    }

    .c-page__subtitle {
      font-size: var(--fs-base);
      color: var(--color-text-muted);
      margin: 0;
    }

    @media (max-width: 768px) {
      .form-card {
        padding: var(--space-6);
      }

      .c-form-actions {
        flex-direction: column-reverse;
      }

      .c-btn {
        width: 100%;
        justify-content: center;
      }
    }
  </style>
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

  <section class="topic-form-container">
    <div class="form-card">
      <form method="post" action="${pageContext.request.contextPath}/moderator/topics/${isEdit ? 'edit' : 'create'}">
        <input type="hidden" name="subjectId" value="${subject.subjectId}" />
        <c:if test="${isEdit}">
          <input type="hidden" name="id" value="${topic.topicId}" />
        </c:if>

        <div class="c-form-group">
          <label for="title" class="c-form-label">Topic Title <span class="required">*</span></label>
          <input type="text" id="title" name="title" class="c-input" required 
                 value="${isEdit ? topic.title : ''}" 
                 placeholder="e.g., Trees & Graphs" />
        </div>

        <div class="c-form-group">
          <label for="description" class="c-form-label">Description</label>
          <textarea id="description" name="description" class="c-input" 
                    placeholder="Brief description of the topic">${isEdit ? topic.description : ''}</textarea>
        </div>

        <div class="c-form-actions">
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
