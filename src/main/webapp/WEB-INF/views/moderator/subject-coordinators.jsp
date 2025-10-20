<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:moderator-dashboard pageTitle="Subject Coordinators" activePage="subjects">
    <header class="c-page__header">
      <nav class="c-breadcrumbs" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/moderator/dashboard">Moderator</a>
        <span class="c-breadcrumbs__sep">/</span>
        <a href="${pageContext.request.contextPath}/moderator/subjects">Subjects</a>
        <span class="c-breadcrumbs__sep">/</span>
        <span aria-current="page">Coordinators</span>
      </nav>
      <div class="c-page__titlebar">
        <div>
          <h1 class="c-page__title">Subject Coordinators</h1>
          <p class="c-page__subtitle u-text-muted">${subject.code} - ${subject.name}</p>
        </div>
        <a href="${pageContext.request.contextPath}/moderator/subject-coordinators/assign?subjectId=${subject.subjectId}" class="c-btn c-btn--primary">
          <i data-lucide="user-plus"></i> Assign New Coordinator
        </a>
      </div>
    </header>

    <section>
      <c:if test="${param.success == 'assigned'}">
        <div class="c-alert c-alert--success" role="alert">
          <i data-lucide="check-circle"></i>
          <span>Coordinator(s) assigned successfully!</span>
        </div>
      </c:if>
      <c:if test="${param.success == 'unassigned'}">
        <div class="c-alert c-alert--success" role="alert">
          <i data-lucide="check-circle"></i>
          <span>Coordinator removed successfully!</span>
        </div>
      </c:if>
      <c:if test="${param.success == 'updated'}">
        <div class="c-alert c-alert--success" role="alert">
          <i data-lucide="check-circle"></i>
          <span>Coordinator subject updated successfully!</span>
        </div>
      </c:if>

      <c:choose>
        <c:when test="${empty coordinators}">
          <div class="o-panel" style="text-align: center; padding: var(--space-10);">
            <i data-lucide="users" style="width: 64px; height: 64px; color: var(--text-muted); margin-bottom: var(--space-4);"></i>
            <p class="u-text-muted" style="margin-bottom: var(--space-4);">No coordinators assigned to this subject yet.</p>
            <a href="${pageContext.request.contextPath}/moderator/subject-coordinators/assign?subjectId=${subject.subjectId}" class="c-btn c-btn--primary">
              <i data-lucide="user-plus"></i> Assign First Coordinator
            </a>
          </div>
        </c:when>
        <c:otherwise>
          <div class="c-table-toolbar">
            <div class="c-table-toolbar__left">
              <span class="u-text-muted">
                <span class="js-coordinator-count">${coordinators.size()}</span> coordinator(s)
              </span>
            </div>
          </div>
          <div class="c-table-wrap">
            <table class="c-table c-table--sticky" aria-label="Subject Coordinators">
              <thead>
                <tr>
                  <th>Student</th>
                  <th>Email</th>
                  <th>Academic Year</th>
                  <th>University</th>
                  <th>Assigned At</th>
                  <th class="u-text-right">Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach items="${coordinators}" var="coordinator">
                  <tr>
                    <td>
                      <div class="c-user-cell">
                        <span class="c-user-cell__avatar" aria-hidden="true"></span>
                        <div class="c-user-cell__meta">
                          <span class="c-user-cell__name">${coordinator.userName != null ? coordinator.userName : coordinator.userEmail}</span>
                          <span class="c-user-cell__sub u-text-muted">ID: ${coordinator.userId}</span>
                        </div>
                      </div>
                    </td>
                    <td>${coordinator.userEmail}</td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty coordinator.academicYear}">Year ${coordinator.academicYear}</c:when>
                        <c:otherwise>-</c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty coordinator.universityName}">${coordinator.universityName}</c:when>
                        <c:otherwise>-</c:otherwise>
                      </c:choose>
                    </td>
                    <td>${coordinator.assignedAt}</td>
                    <td class="u-text-right">
                      <div class="c-table-actions">
                        <a href="${pageContext.request.contextPath}/moderator/subject-coordinators/edit?coordinatorId=${coordinator.coordinatorId}&returnTo=subject" class="c-btn c-btn--sm c-btn--ghost" aria-label="Edit coordinator">
                          <i data-lucide="edit"></i> Edit
                        </a>
                        <form method="post" action="${pageContext.request.contextPath}/moderator/subject-coordinators/unassign" style="display:inline" onsubmit="return confirm('Are you sure you want to remove this coordinator?');">
                          <input type="hidden" name="coordinatorId" value="${coordinator.coordinatorId}" />
                          <input type="hidden" name="subjectId" value="${subject.subjectId}" />
                          <button class="c-btn c-btn--sm c-btn--danger" type="submit" aria-label="Remove coordinator">
                            <i data-lucide="user-minus"></i> Remove
                          </button>
                        </form>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:otherwise>
      </c:choose>
    </section>
</layout:moderator-dashboard>
