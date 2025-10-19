<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:moderator-dashboard pageTitle="Manage Topics" activePage="subjects">
  <jsp:attribute name="scripts">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/subjects.css" />
    <script>
      // Minimal client-side count and sort for this table
      (function () {
        const table = document.getElementById("topics-table");
        const tbody = table?.querySelector("tbody");
        const countEl = document.querySelector(".js-topic-count");
        if (!table || !tbody || !countEl) return;
        function updateCount() {
          countEl.textContent = String(tbody.querySelectorAll("tr").length);
        }
        updateCount();
        table.querySelectorAll(".js-sort").forEach((btn) => {
          btn.addEventListener("click", () => {
            const th = btn.closest("th");
            const key = btn.getAttribute("data-key");
            const current = th.getAttribute("aria-sort") || "none";
            const next = current === "ascending" ? "descending" : "ascending";
            table.querySelectorAll("thead th").forEach((oth) => {
              if (oth !== th) oth.setAttribute("aria-sort", "none");
            });
            th.setAttribute("aria-sort", next);
            const rows = Array.from(tbody.querySelectorAll("tr"));
            const getter = (row) => {
              if (key === "title") return row.children[0].textContent.trim();
              return "";
            };
            rows.sort((a, b) => {
              const va = getter(a).toLowerCase();
              const vb = getter(b).toLowerCase();
              return next === "ascending"
                ? va.localeCompare(vb)
                : vb.localeCompare(va);
            });
            rows.forEach((r) => tbody.appendChild(r));
          });
        });
      })();
    </script>
  </jsp:attribute>

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
        <a class="c-view-switch__btn" href="${pageContext.request.contextPath}/moderator/topics?subjectId=${subject.subjectId}">
          <i data-lucide="grid"></i>
          <span>Grid</span>
        </a>
        <a class="c-view-switch__btn is-active" href="${pageContext.request.contextPath}/moderator/topics?subjectId=${subject.subjectId}&view=list" aria-current="page">
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
    <div class="o-panel">
      <div class="c-table-toolbar">
        <div class="c-table-toolbar__left">
          <strong>Topics</strong>
          <span class="u-text-muted">Total: <span class="js-topic-count">${topics.size()}</span></span>
        </div>
      </div>
      <div class="o-table-wrap">
        <table class="c-table" id="topics-table" aria-label="Topics">
          <thead>
            <tr>
              <th aria-sort="none">
                <button type="button" class="c-table-sort js-sort" data-key="title">
                  <span>Title</span>
                </button>
              </th>
              <th>Description</th>
              <th class="u-text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${topics}" var="topic">
              <tr>
                <td>${topic.title}</td>
                <td>${topic.description != null ? topic.description : '-'}</td>
                <td class="u-text-right">
                  <div class="c-table-actions">
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
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </section>
</layout:moderator-dashboard>
