<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<c:set var="isEdit" value="${not empty subject}" />
<c:set var="formTitle" value="${isEdit ? 'Edit Subject' : 'Create Subject'}" />

<layout:moderator-dashboard pageTitle="${formTitle}" activePage="subjects">
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

  <section>
    <div class="o-panel" style="max-width: 600px;">
      <form method="post" action="${pageContext.request.contextPath}/moderator/subjects/${isEdit ? 'edit' : 'create'}">
        <c:if test="${isEdit}">
          <input type="hidden" name="id" value="${subject.subjectId}" />
        </c:if>

        <div class="c-form-group">
          <label for="name" class="c-form-label">Subject Name <span style="color: var(--color-danger);">*</span></label>
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

        <div class="c-form-group">
          <label for="description" class="c-form-label">Description</label>
          <textarea id="description" name="description" class="c-input" rows="4" 
                    placeholder="Brief description of the subject">${isEdit ? subject.description : ''}</textarea>
        </div>

        <div class="c-form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-4);">
          <div class="c-form-group">
            <label for="academicYear" class="c-form-label">Academic Year <span style="color: var(--color-danger);">*</span></label>
            <select id="academicYear" name="academicYear" class="c-input" required>
              <option value="">Select year</option>
              <option value="1" ${isEdit && subject.academicYear == 1 ? 'selected' : ''}>Year 1</option>
              <option value="2" ${isEdit && subject.academicYear == 2 ? 'selected' : ''}>Year 2</option>
              <option value="3" ${isEdit && subject.academicYear == 3 ? 'selected' : ''}>Year 3</option>
              <option value="4" ${isEdit && subject.academicYear == 4 ? 'selected' : ''}>Year 4</option>
            </select>
          </div>

          <div class="c-form-group">
            <label for="semester" class="c-form-label">Semester <span style="color: var(--color-danger);">*</span></label>
            <select id="semester" name="semester" class="c-input" required>
              <option value="">Select semester</option>
              <option value="1" ${isEdit && subject.semester == 1 ? 'selected' : ''}>Semester 1</option>
              <option value="2" ${isEdit && subject.semester == 2 ? 'selected' : ''}>Semester 2</option>
            </select>
          </div>
        </div>

        <div class="c-form-group">
          <label for="status" class="c-form-label">Status <span style="color: var(--color-danger);">*</span></label>
          <select id="status" name="status" class="c-input" required>
            <option value="upcoming" ${isEdit && subject.status == 'upcoming' ? 'selected' : ''}>Upcoming</option>
            <option value="ongoing" ${isEdit && subject.status == 'ongoing' ? 'selected' : ''}>Ongoing</option>
            <option value="completed" ${isEdit && subject.status == 'completed' ? 'selected' : ''}>Completed</option>
          </select>
        </div>

        <div class="c-form-actions" style="display: flex; gap: var(--space-3); justify-content: flex-end; margin-top: var(--space-6);">
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
