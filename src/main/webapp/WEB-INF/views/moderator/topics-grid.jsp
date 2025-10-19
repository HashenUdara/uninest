<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:moderator-dashboard pageTitle="Manage Topics" activePage="subjects">


  <header class="c-page__header">
    <nav class="c-breadcrumbs" aria-label="Breadcrumb">
      <a href="${pageContext.request.contextPath}/moderator/dashboard">Moderator</a>
      <span class="c-breadcrumbs__sep">/</span>
      <a href="${pageContext.request.contextPath}/moderator/subjects">Subjects</a>
      <span class="c-breadcrumbs__sep">/</span>
      <span aria-current="page">${subject.name}</span>
    </nav>
    <div class="c-page__titlebar">
      <div>
        <h1 class="c-page__title">${subject.code} - ${subject.name}</h1>
        <p class="c-page__subtitle u-text-muted">Manage topics for this subject.</p>
      </div>
      <a href="${pageContext.request.contextPath}/moderator/topics/create?subjectId=${subject.subjectId}" class="c-btn c-btn--primary">
        <i data-lucide="plus"></i> Create Topic
      </a>
    </div>
    <div class="c-toolbar">
      <div class="c-input-group">
        <input class="c-input" type="search" placeholder="Search topics" aria-label="Search topics" />
        <button class="c-btn">Search</button>
      </div>
      <div class="c-view-switch" role="group" aria-label="View switch">
        <a class="c-view-switch__btn is-active" href="${pageContext.request.contextPath}/moderator/topics?subjectId=${subject.subjectId}" aria-current="page">
          <i data-lucide="grid"></i>
          <span>Grid</span>
        </a>
        <a class="c-view-switch__btn" href="${pageContext.request.contextPath}/moderator/topics?subjectId=${subject.subjectId}&view=list">
          <i data-lucide="list"></i>
          <span>List</span>
        </a>
      </div>
    </div>
  </header>

  <c:if test="${param.success == 'created'}">
    <div class="c-alert c-alert--success" role="alert">
      <i data-lucide="check-circle"></i>
      <span>Topic created successfully!</span>
    </div>
  </c:if>
  <c:if test="${param.success == 'updated'}">
    <div class="c-alert c-alert--success" role="alert">
      <i data-lucide="check-circle"></i>
      <span>Topic updated successfully!</span>
    </div>
  </c:if>
  <c:if test="${param.success == 'deleted'}">
    <div class="c-alert c-alert--success" role="alert">
      <i data-lucide="check-circle"></i>
      <span>Topic deleted successfully!</span>
    </div>
  </c:if>

  <section>
    <c:if test="${empty topics}">
      <div style="text-align: center; padding: var(--space-10); color: var(--text-muted);">
        <p>No topics found. Create your first topic to get started.</p>
      </div>
    </c:if>

    <div class="o-grid o-grid--cards">
      <c:forEach items="${topics}" var="topic">
        <article class="c-card">
          <div class="c-card__body">
            <h3 class="c-card__title">${topic.title}</h3>
            <p class="c-card__meta">${topic.description != null ? topic.description : 'No description'}</p>
            <div class="c-card__actions">
              <a href="${pageContext.request.contextPath}/moderator/topics/edit?id=${topic.topicId}&subjectId=${subject.subjectId}" class="c-icon-btn" aria-label="Edit topic">
                <i data-lucide="pencil"></i>
              </a>
              <form method="post" action="${pageContext.request.contextPath}/moderator/topics/delete" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this topic?');">
                <input type="hidden" name="id" value="${topic.topicId}" />
                <input type="hidden" name="subjectId" value="${subject.subjectId}" />
                <button type="submit" class="c-icon-btn" aria-label="Delete topic">
                  <i data-lucide="trash"></i>
                </button>
              </form>
            </div>
          </div>
        </article>
      </c:forEach>
    </div>
  </section>
</layout:moderator-dashboard>
