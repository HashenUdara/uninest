<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:moderator-dashboard pageTitle="Manage Subjects" activePage="subjects">
    <script>
      // Minimal client-side count and sort for this table
      (function () {
        const table = document.getElementById("subjects-table");
        const tbody = table?.querySelector("tbody");
        const countEl = document.querySelector(".js-subject-count");
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
              if (key === "code") return row.children[2].textContent.trim();
              if (key === "year") return row.children[3].textContent.trim();
              if (key === "semester") return row.children[4].textContent.trim();
              if (key === "status") return row.children[5].textContent.trim();
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
      
      /* ================= Search functionality ================= */
      function performSearch() {
        const searchInput = document.getElementById('searchInput');
        const searchTerm = searchInput.value.toLowerCase().trim();
        const rows = document.querySelectorAll('#subjects-table tbody tr');
        let visibleCount = 0;
        
        rows.forEach(row => {
          const name = (row.getAttribute('data-name') || '').toLowerCase();
          const code = (row.getAttribute('data-code') || '').toLowerCase();
          const description = (row.getAttribute('data-description') || '').toLowerCase();
          
          if (searchTerm === '' || 
              name.includes(searchTerm) || 
              code.includes(searchTerm) || 
              description.includes(searchTerm)) {
            row.style.display = '';
            visibleCount++;
          } else {
            row.style.display = 'none';
          }
        });
        
        // Update count
        const countEl = document.querySelector('.js-subject-count');
        if (countEl) {
          countEl.textContent = String(visibleCount);
        }
      }
      
      // Allow search on Enter key and real-time search
      document.addEventListener("DOMContentLoaded", function() {
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
          searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
              performSearch();
            }
          });
          searchInput.addEventListener('input', performSearch);
        }
      });
    </script>

  <header class="c-page__header">
    <nav class="c-breadcrumbs" aria-label="Breadcrumb">
      <a href="${pageContext.request.contextPath}/moderator/dashboard">Moderator</a>
      <span class="c-breadcrumbs__sep">/</span>
      <span aria-current="page">Subjects</span>
    </nav>
    <div class="c-page__titlebar">
      <div>
        <h1 class="c-page__title">Manage Subjects</h1>
        <p class="c-page__subtitle u-text-muted">Create and manage subjects for your community.</p>
      </div>
      <a href="${pageContext.request.contextPath}/moderator/subjects/create" class="c-btn c-btn--primary">
        <i data-lucide="plus"></i> Create Subject
      </a>
    </div>
    <div class="c-toolbar">
      <div class="c-input-group">
        <input id="searchInput" class="c-input" type="search" placeholder="Search subjects by name or code" aria-label="Search subjects" />
        <button class="c-btn" onclick="performSearch()">Search</button>
      </div>
      <div class="c-view-switch" role="group" aria-label="View switch">
        <a class="c-view-switch__btn" href="${pageContext.request.contextPath}/moderator/subjects">
          <i data-lucide="grid"></i>
          <span>Grid</span>
        </a>
        <a class="c-view-switch__btn is-active" href="${pageContext.request.contextPath}/moderator/subjects?view=list" aria-current="page">
          <i data-lucide="list"></i>
          <span>List</span>
        </a>
      </div>
    </div>
  </header>

  <c:if test="${param.success == 'created'}">
    <div class="c-alert c-alert--success" role="alert">
      <i data-lucide="check-circle"></i>
      <span>Subject created successfully!</span>
    </div>
  </c:if>
  <c:if test="${param.success == 'updated'}">
    <div class="c-alert c-alert--success" role="alert">
      <i data-lucide="check-circle"></i>
      <span>Subject updated successfully!</span>
    </div>
  </c:if>
  <c:if test="${param.success == 'deleted'}">
    <div class="c-alert c-alert--success" role="alert">
      <i data-lucide="check-circle"></i>
      <span>Subject deleted successfully!</span>
    </div>
  </c:if>

  <section>
    <div class="o-panel">
      <div class="c-table-toolbar">
        <div class="c-table-toolbar__left">
          <strong>Subjects</strong>
          <span class="u-text-muted">Total: <span class="js-subject-count">${subjects.size()}</span></span>
        </div>
      </div>
      <div class="o-table-wrap">
        <table class="c-table" id="subjects-table" aria-label="Subjects">
          <thead>
            <tr>
              <th aria-sort="none">
                <button type="button" class="c-table-sort js-sort" data-key="title">
                  <span>Name</span>
                </button>
              </th>
              <th>Description</th>
              <th aria-sort="none">
                <button type="button" class="c-table-sort js-sort" data-key="code">
                  <span>Code</span>
                </button>
              </th>
              <th aria-sort="none">
                <button type="button" class="c-table-sort js-sort" data-key="year">
                  <span>Academic year</span>
                </button>
              </th>
              <th aria-sort="none">
                <button type="button" class="c-table-sort js-sort" data-key="semester">
                  <span>Semester</span>
                </button>
              </th>
              <th aria-sort="none">
                <button type="button" class="c-table-sort js-sort" data-key="status">
                  <span>Status</span>
                </button>
              </th>
              <th class="u-text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${subjects}" var="subject">
              <tr data-name="${subject.name}" data-code="${subject.code}" data-description="${subject.description}" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/moderator/topics?subjectId=${subject.subjectId}'">
                <td>${subject.name}</td>
                <td>${subject.description != null ? subject.description : '-'}</td>
                <td>${subject.code}</td>
                <td>Year ${subject.academicYear}</td>
                <td>Semester ${subject.semester}</td>
                <td><span class="c-status is-${subject.status}">${subject.status}</span></td>
                <td class="u-text-right" onclick="event.stopPropagation();">
                  <div class="c-table-actions">
                    <a href="${pageContext.request.contextPath}/moderator/topics?subjectId=${subject.subjectId}" class="c-icon-btn" aria-label="View topics">
                      <i data-lucide="folder"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/moderator/subject-coordinators?subjectId=${subject.subjectId}" class="c-icon-btn" aria-label="Assign coordinators">
                      <i data-lucide="user-plus"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/moderator/subjects/edit?id=${subject.subjectId}" class="c-icon-btn" aria-label="Edit subject">
                      <i data-lucide="pencil"></i>
                    </a>
                    <form method="post" action="${pageContext.request.contextPath}/moderator/subjects/delete" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this subject? All topics under it will also be deleted.');">
                      <input type="hidden" name="id" value="${subject.subjectId}" />
                      <button type="submit" class="c-icon-btn" aria-label="Delete subject">
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
