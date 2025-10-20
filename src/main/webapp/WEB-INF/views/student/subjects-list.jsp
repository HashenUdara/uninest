<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="My Subjects" activePage="subjects">
    <script>
      /* ================= Subjects: list avatars with code ================= */
      function initSubjectAvatars() {
        const avatars = document.querySelectorAll(".c-table .c-subj-avatar");
        if (!avatars.length) return;
        const hueFromCode = (code) => {
          let h = 0;
          for (let i = 0; i < code.length; i++) {
            h = (h * 31 + code.charCodeAt(i)) % 360;
          }
          return h;
        };
        avatars.forEach((el) => {
          const row = el.closest("tr");
          const code = (row?.getAttribute("data-code") || "").trim() || "SUBJ";
          const hue = hueFromCode(code);
          const bg = "hsl(" + hue + " 85% 95%)";
          const fg = "hsl(" + hue + " 50% 28%)";
          el.style.background = bg;
          el.style.color = fg;
          el.textContent = code;
        });
      }
      
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
              if (key === "title") return row.children[1].textContent.trim();
              if (key === "code") return row.children[0].textContent.trim();
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
      
      document.addEventListener("DOMContentLoaded", initSubjectAvatars);
      
      /* ================= Search functionality ================= */
      function performSearch() {
        const searchInput = document.getElementById('searchInput');
        const searchTerm = searchInput.value.toLowerCase().trim();
        const rows = document.querySelectorAll('#subjects-table tbody tr');
        let visibleCount = 0;
        
        rows.forEach(row => {
          const code = (row.getAttribute('data-code') || '').toLowerCase();
          const name = (row.getAttribute('data-name') || '').toLowerCase();
          const description = (row.getAttribute('data-description') || '').toLowerCase();
          
          if (searchTerm === '' || 
              code.includes(searchTerm) || 
              name.includes(searchTerm) || 
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
      <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
      <span class="c-breadcrumbs__sep">/</span>
      <span aria-current="page">My Subjects</span>
    </nav>
    <div class="c-page__titlebar">
      <div>
        <h1 class="c-page__title">My Subjects</h1>
        <p class="c-page__subtitle u-text-muted">Explore subjects and their topics in your community.</p>
      </div>
    </div>
    <div class="c-toolbar">
      <div class="c-input-group">
        <input id="searchInput" class="c-input" type="search" placeholder="Search subjects by name or code" aria-label="Search subjects" />
        <button class="c-btn" onclick="performSearch()">Search</button>
      </div>
      <div class="c-view-switch" role="group" aria-label="View switch">
        <a class="c-view-switch__btn" href="${pageContext.request.contextPath}/student/subjects">
          <i data-lucide="grid"></i>
          <span>Grid</span>
        </a>
        <a class="c-view-switch__btn is-active" href="${pageContext.request.contextPath}/student/subjects?view=list" aria-current="page">
          <i data-lucide="list"></i>
          <span>List</span>
        </a>
      </div>
    </div>
  </header>

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
                <button type="button" class="c-table-sort js-sort" data-key="code">
                  <span>Code</span>
                </button>
              </th>
              <th aria-sort="none">
                <button type="button" class="c-table-sort js-sort" data-key="title">
                  <span>Name</span>
                </button>
              </th>
              <th>Description</th>
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
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${subjects}" var="subject">
              <tr data-code="${subject.code}" data-name="${subject.name}" data-description="${subject.description}" data-year="${subject.academicYear}" data-semester="${subject.semester}" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/student/topics?subjectId=${subject.subjectId}'">
                <td>
                  <div style="display: flex; align-items: center; gap: var(--space-3);">
                    <div class="c-subj-avatar"></div>
                    <span>${subject.code}</span>
                  </div>
                </td>
                <td>${subject.name}</td>
                <td>${subject.description != null ? subject.description : '-'}</td>
                <td>Year ${subject.academicYear}</td>
                <td>Semester ${subject.semester}</td>
                <td><span class="c-status is-${subject.status}">${subject.status}</span></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </section>
</layout:student-dashboard>
