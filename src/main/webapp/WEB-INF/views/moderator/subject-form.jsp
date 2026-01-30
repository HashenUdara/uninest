<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<c:set var="isEdit" value="${not empty subject}" />
<c:set var="formTitle" value="${isEdit ? 'Edit Subject' : 'Create Subject'}" />

<layout:moderator-dashboard pageTitle="${formTitle}" activePage="subjects">
  <style>
    /* Professional Form Styling */
    .subject-form-container {
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
      min-height: 100px;
      line-height: 1.6;
    }

    select.c-input {
      cursor: pointer;
      appearance: none;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%236b7280' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
      background-repeat: no-repeat;
      background-position: right 12px center;
      padding-right: 40px;
    }

    .c-form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: var(--space-5);
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

      .c-form-row {
        grid-template-columns: 1fr;
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
      <span aria-current="page">${formTitle}</span>
    </nav>
    <div class="c-page__titlebar">
      <div>
        <h1 class="c-page__title">${formTitle}</h1>
        <p class="c-page__subtitle u-text-muted">${isEdit ? 'Update subject information' : 'Add a new subject to your community'}</p>
      </div>
    </div>
  </header>

  <c:if test="${not empty error}">
    <div class="c-alert c-alert--danger" role="alert">
      <i data-lucide="alert-circle"></i>
      <span>${error}</span>
    </div>
  </c:if>

  <section class="subject-form-container">
    <div class="form-card">
      <form method="post" action="${pageContext.request.contextPath}/moderator/subjects/${isEdit ? 'edit' : 'create'}">
        <c:if test="${isEdit}">
          <input type="hidden" name="id" value="${subject.subjectId}" />
        </c:if>

        <div class="c-form-group">
          <label for="name" class="c-form-label">Subject Name <span class="required">*</span></label>
          <input type="text" id="name" name="name" class="c-input" required 
                 value="${isEdit ? subject.name : ''}" 
                 placeholder="e.g., Data Structures" />
        </div>

        <div class="c-form-group">
          <label for="code" class="c-form-label">Subject Code</label>
          <input type="text" id="code" name="code" class="c-input" 
                 value="${isEdit ? subject.code : ''}" 
                 placeholder="e.g., CS204" />
        </div>

        <div class="c-form-group"> <!--credits -->
          <label for="code" class="c-form-label">Credits</label>
          <input type="text" id="credits" name="credits" class="c-input"
                 value="${isEdit ? subject.credits : ''}"
                 placeholder="e.g., 3" />
        </div>

        <div class="c-form-group">
          <label for="description" class="c-form-label">Description</label>
          <textarea id="description" name="description" class="c-input" 
                    placeholder="Brief description of the subject">${isEdit ? subject.description : ''}</textarea>
        </div>

        <div class="c-form-row">
          <div class="c-form-group">
            <label for="academicYear" class="c-form-label">Academic Year <span class="required">*</span></label>
            <select id="academicYear" name="academicYear" class="c-input" required>
              <option value="">Select year</option>
              <option value="1" ${isEdit && subject.academicYear == 1 ? 'selected' : ''}>Year 1</option>
              <option value="2" ${isEdit && subject.academicYear == 2 ? 'selected' : ''}>Year 2</option>
              <option value="3" ${isEdit && subject.academicYear == 3 ? 'selected' : ''}>Year 3</option>
              <option value="4" ${isEdit && subject.academicYear == 4 ? 'selected' : ''}>Year 4</option>
            </select>
          </div>

          <div class="c-form-group">
            <label for="semester" class="c-form-label">Semester <span class="required">*</span></label>
            <select id="semester" name="semester" class="c-input" required>
              <option value="">Select semester</option>
              <option value="1" ${isEdit && subject.semester == 1 ? 'selected' : ''}>Semester 1</option>
              <option value="2" ${isEdit && subject.semester == 2 ? 'selected' : ''}>Semester 2</option>
            </select>
          </div>
        </div>

        <div class="c-form-group">
          <label for="status" class="c-form-label">Status <span class="required">*</span></label>
          <select id="status" name="status" class="c-input" required>
            <option value="upcoming" ${isEdit && subject.status == 'upcoming' ? 'selected' : ''}>Upcoming</option>
            <option value="ongoing" ${isEdit && subject.status == 'ongoing' ? 'selected' : ''}>Ongoing</option>
            <option value="completed" ${isEdit && subject.status == 'completed' ? 'selected' : ''}>Completed</option>
          </select>
        </div>

        <div class="c-form-actions">
          <a href="${pageContext.request.contextPath}/moderator/subjects" class="c-btn c-btn--ghost">Cancel</a>
          <button type="submit" class="c-btn c-btn--primary">
            <i data-lucide="${isEdit ? 'save' : 'plus'}"></i>
            ${isEdit ? 'Update Subject' : 'Create Subject'}
          </button>
        </div>
      </form>
    </div>
  </section>
</layout:moderator-dashboard>
