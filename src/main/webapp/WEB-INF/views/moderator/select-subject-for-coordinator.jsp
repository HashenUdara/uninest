<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:moderator-dashboard pageTitle="Select Subject" activePage="coordinators">
    <header class="c-page__header">
      <nav class="c-breadcrumbs" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/moderator/dashboard">Moderator</a>
        <span class="c-breadcrumbs__sep">/</span>
        <a href="${pageContext.request.contextPath}/moderator/coordinators">Subject Coordinators</a>
        <span class="c-breadcrumbs__sep">/</span>
        <span aria-current="page">Select Subject</span>
      </nav>
      <div class="c-page__titlebar">
        <div>
          <h1 class="c-page__title">Select Subject</h1>
          <p class="c-page__subtitle u-text-muted">Choose a subject to assign a coordinator to.</p>
        </div>
      </div>
    </header>

    <section>
      <c:choose>
        <c:when test="${empty subjects}">
          <div class="o-panel" style="text-align: center; padding: var(--space-10);">
            <i data-lucide="book-open" style="width: 64px; height: 64px; color: var(--text-muted); margin-bottom: var(--space-4);"></i>
            <p class="u-text-muted" style="margin-bottom: var(--space-4);">No subjects available. Please create a subject first.</p>
            <a href="${pageContext.request.contextPath}/moderator/subjects/create" class="c-btn c-btn--primary">
              <i data-lucide="plus"></i> Create Subject
            </a>
          </div>
        </c:when>
        <c:otherwise>
          <div class="c-table-toolbar">
            <div class="c-table-toolbar__left">
              <span class="u-text-muted">
                Select a subject from the list below
              </span>
            </div>
            <div class="c-table-toolbar__right">
              <a href="${pageContext.request.contextPath}/moderator/coordinators" class="c-btn c-btn--ghost">
                Cancel
              </a>
            </div>
          </div>
          <div class="c-table-wrap">
            <table class="c-table c-table--sticky" aria-label="Select Subject">
              <thead>
                <tr>
                  <th>Subject</th>
                  <th>Code</th>
                  <th>Academic Year</th>
                  <th>Semester</th>
                  <th class="u-text-right">Action</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach items="${subjects}" var="subject">
                  <tr>
                    <td>${subject.name}</td>
                    <td>${subject.code}</td>
                    <td>${subject.academicYear}</td>
                    <td>${subject.semester}</td>
                    <td class="u-text-right">
                      <a href="${pageContext.request.contextPath}/moderator/subject-coordinators/assign?subjectId=${subject.subjectId}&returnTo=${returnTo}" class="c-btn c-btn--sm c-btn--primary">
                        <i data-lucide="arrow-right"></i> Select
                      </a>
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
