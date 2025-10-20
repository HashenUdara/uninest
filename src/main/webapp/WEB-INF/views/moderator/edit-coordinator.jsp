<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:moderator-dashboard pageTitle="Edit Coordinator" activePage="coordinators">
    <header class="c-page__header">
      <nav class="c-breadcrumbs" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/moderator/dashboard">Moderator</a>
        <span class="c-breadcrumbs__sep">/</span>
        <c:choose>
          <c:when test="${returnTo == 'all'}">
            <a href="${pageContext.request.contextPath}/moderator/coordinators">Subject Coordinators</a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/moderator/subjects">Subjects</a>
            <span class="c-breadcrumbs__sep">/</span>
            <a href="${pageContext.request.contextPath}/moderator/subject-coordinators?subjectId=${coordinator.subjectId}">Coordinators</a>
          </c:otherwise>
        </c:choose>
        <span class="c-breadcrumbs__sep">/</span>
        <span aria-current="page">Edit</span>
      </nav>
      <div class="c-page__titlebar">
        <div>
          <h1 class="c-page__title">Edit Coordinator</h1>
          <p class="c-page__subtitle u-text-muted">Change the subject assigned to ${coordinator.userName != null ? coordinator.userName : coordinator.userEmail}</p>
        </div>
      </div>
    </header>

    <section>
      <div class="o-panel" style="max-width: 800px; margin: 0 auto;">
        <form method="post" action="${pageContext.request.contextPath}/moderator/subject-coordinators/edit">
          <input type="hidden" name="coordinatorId" value="${coordinator.coordinatorId}" />
          <input type="hidden" name="returnTo" value="${returnTo}" />
          
          <div style="margin-bottom: var(--space-6);">
            <h3 style="margin-bottom: var(--space-4);">Coordinator Details</h3>
            <div style="display: grid; gap: var(--space-4);">
              <div>
                <label class="u-text-muted" style="display: block; font-size: 0.875rem; margin-bottom: var(--space-2);">Student</label>
                <div class="c-user-cell">
                  <span class="c-user-cell__avatar" aria-hidden="true"></span>
                  <div class="c-user-cell__meta">
                    <span class="c-user-cell__name">${coordinator.userName != null ? coordinator.userName : coordinator.userEmail}</span>
                    <span class="c-user-cell__sub u-text-muted">${coordinator.userEmail}</span>
                  </div>
                </div>
              </div>
              
              <div>
                <label class="u-text-muted" style="display: block; font-size: 0.875rem; margin-bottom: var(--space-2);">Current Subject</label>
                <p style="margin: 0;">${coordinator.subjectCode} - ${coordinator.subjectName}</p>
              </div>
            </div>
          </div>
          
          <div style="margin-bottom: var(--space-6);">
            <label for="subjectId" style="display: block; font-weight: 500; margin-bottom: var(--space-2);">New Subject</label>
            <select name="subjectId" id="subjectId" required style="width: 100%; padding: var(--space-3); border: 1px solid var(--border-color); border-radius: 6px; font-size: 1rem;">
              <option value="">Select a subject...</option>
              <c:forEach items="${subjects}" var="subject">
                <option value="${subject.subjectId}" ${subject.subjectId == coordinator.subjectId ? 'selected' : ''}>
                  ${subject.code} - ${subject.name}
                </option>
              </c:forEach>
            </select>
          </div>
          
          <div style="display: flex; gap: var(--space-3); justify-content: flex-end;">
            <a href="<c:choose><c:when test="${returnTo == 'all'}">${pageContext.request.contextPath}/moderator/coordinators</c:when><c:otherwise>${pageContext.request.contextPath}/moderator/subject-coordinators?subjectId=${coordinator.subjectId}</c:otherwise></c:choose>" class="c-btn c-btn--ghost">
              Cancel
            </a>
            <button type="submit" class="c-btn c-btn--primary">
              <i data-lucide="save"></i> Update Subject
            </button>
          </div>
        </form>
      </div>
    </section>
</layout:moderator-dashboard>
