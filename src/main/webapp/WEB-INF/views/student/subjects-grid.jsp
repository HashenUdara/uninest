<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
      <%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

        <layout:student-dashboard pageTitle="My Subjects" activePage="subjects">

          <script>
            /* ================= Subjects: grid thumbnails with code ================= */
            function initSubjectThumbnails() {
              const thumbs = document.querySelectorAll(".c-card .c-subj-thumb");
              if (!thumbs.length) return;
              const hueFromCode = (code) => {
                // Create a deterministic hue from the subject code string
                let h = 0;
                for (let i = 0; i < code.length; i++) {
                  h = (h * 31 + code.charCodeAt(i)) % 360;
                }
                return h;
              };
              thumbs.forEach((el) => {
                const card = el.closest(".c-card");
                const code = (card?.getAttribute("data-code") || "").trim() || "SUBJ";
                const hue = hueFromCode(code);
                const bg = "hsl(" + hue + " 85% 95%)";
                const fg = "hsl(" + hue + " 50% 28%)";
                el.style.background = bg;
                el.style.color = fg;
                el.innerHTML = '<span class="c-subj-thumb__code">' + code + '</span>';
              });
            }
            document.addEventListener("DOMContentLoaded", initSubjectThumbnails);

            /* ================= Tab filtering by status ================= */
            let currentStatusFilter = 'all';
            let currentSearchTerm = '';

            function filterByStatus(status) {
              currentStatusFilter = status;
              // Update active tab
              document.querySelectorAll('.c-tabs__link').forEach(tab => {
                tab.classList.remove('is-active');
                if (tab.getAttribute('data-status') === status) {
                  tab.classList.add('is-active');
                }
              });
              applyFilters();
            }

            /* ================= Search functionality ================= */
            function performSearch() {
              const searchInput = document.getElementById('searchInput');
              currentSearchTerm = searchInput.value.toLowerCase().trim();
              applyFilters();
            }

            function applyFilters() {
              const cards = document.querySelectorAll('.c-card');
              const sections = document.querySelectorAll('.c-section-title');
              const grids = document.querySelectorAll('.o-grid--cards');

              // Hide all sections and grids first
              sections.forEach(section => section.style.display = 'none');
              grids.forEach(grid => grid.style.display = 'none');

              let hasVisibleCards = false;

              cards.forEach(card => {
                const status = card.getAttribute('data-status') || '';
                const name = (card.getAttribute('data-name') || '').toLowerCase();
                const code = (card.getAttribute('data-code') || '').toLowerCase();
                const description = (card.getAttribute('data-description') || '').toLowerCase();

                // Check status filter
                const statusMatch = currentStatusFilter === 'all' || status === currentStatusFilter;

                // Check search filter
                const searchMatch = currentSearchTerm === '' ||
                  name.includes(currentSearchTerm) ||
                  code.includes(currentSearchTerm) ||
                  description.includes(currentSearchTerm);

                if (statusMatch && searchMatch) {
                  card.style.display = '';
                  hasVisibleCards = true;
                  // Show the parent grid
                  const parentGrid = card.closest('.o-grid--cards');
                  if (parentGrid) {
                    parentGrid.style.display = '';
                    // Show the section title before this grid
                    let prevElement = parentGrid.previousElementSibling;
                    while (prevElement && !prevElement.classList.contains('c-section-title')) {
                      prevElement = prevElement.previousElementSibling;
                    }
                    if (prevElement && prevElement.classList.contains('c-section-title')) {
                      prevElement.style.display = '';
                    }
                  }
                } else {
                  card.style.display = 'none';
                }
              });

              // Show "no results" message if needed
              showNoResultsMessage(!hasVisibleCards);
            }

            function showNoResultsMessage(show) {
              let noResultsDiv = document.getElementById('no-results-message');
              if (show) {
                if (!noResultsDiv) {
                  noResultsDiv = document.createElement('div');
                  noResultsDiv.id = 'no-results-message';
                  noResultsDiv.style.textAlign = 'center';
                  noResultsDiv.style.padding = 'var(--space-10)';
                  noResultsDiv.style.color = 'var(--text-muted)';
                  noResultsDiv.innerHTML = '<p>No subjects found matching your criteria.</p>';
                  document.querySelector('section').appendChild(noResultsDiv);
                }
                noResultsDiv.style.display = 'block';
              } else {
                if (noResultsDiv) {
                  noResultsDiv.style.display = 'none';
                }
              }
            }

            // Allow search on Enter key
            document.addEventListener("DOMContentLoaded", function () {
              const searchInput = document.getElementById('searchInput');
              if (searchInput) {
                searchInput.addEventListener('keypress', function (e) {
                  if (e.key === 'Enter') {
                    performSearch();
                  }
                });
                // Real-time search as user types
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
                <input id="searchInput" class="c-input" type="search" placeholder="Search subjects by name or code"
                  aria-label="Search subjects" />
                <button class="c-btn" onclick="performSearch()">Search</button>
              </div>
              <div class="c-view-switch" role="group" aria-label="View switch">
                <a class="c-view-switch__btn is-active" href="${pageContext.request.contextPath}/student/subjects"
                  aria-current="page">
                  <i data-lucide="grid"></i>
                  <span>Grid</span>
                </a>
                <a class="c-view-switch__btn" href="${pageContext.request.contextPath}/student/subjects?view=list">
                  <i data-lucide="list"></i>
                  <span>List</span>
                </a>
              </div>
            </div>
            <div class="c-tabs" role="tablist" style="margin-top: var(--space-4);">
              <button class="c-tabs__link is-active" role="tab" data-status="all"
                onclick="filterByStatus('all')">All</button>
              <button class="c-tabs__link" role="tab" data-status="ongoing"
                onclick="filterByStatus('ongoing')">Ongoing</button>
              <button class="c-tabs__link" role="tab" data-status="upcoming"
                onclick="filterByStatus('upcoming')">Upcoming</button>
              <button class="c-tabs__link" role="tab" data-status="completed"
                onclick="filterByStatus('completed')">Completed</button>
            </div>
          </header>

          <section>
            <c:if test="${empty subjects}">
              <div style="text-align: center; padding: var(--space-10); color: var(--text-muted);">
                <p>No subjects found in your community.</p>
              </div>
            </c:if>

            <c:set var="currentGroup" value="" />
            <c:forEach items="${subjects}" var="subject">
              <c:set var="groupKey" value="Year ${subject.academicYear}, Semester ${subject.semester}" />
              <c:if test="${groupKey != currentGroup}">
                <c:if test="${not empty currentGroup}">
                  </div>
                </c:if>
                <h2 class="c-section-title">${groupKey}</h2>
                <div class="o-grid o-grid--cards" data-group="${groupKey}">
                  <c:set var="currentGroup" value="${groupKey}" />
              </c:if>

              <article class="c-card" data-code="${subject.code}" data-status="${subject.status}"
                data-name="${subject.name}" data-description="${subject.description}" style="cursor: pointer;"
                onclick="window.location.href='${pageContext.request.contextPath}/student/topics?subjectId=${subject.subjectId}'">
                <div class="c-card__media c-subj-thumb"></div>
                <div class="c-card__body">
                  <span class="c-status is-${subject.status}">${subject.status}</span>
                  <h3 class="c-card__title">${subject.code} - ${subject.name} - ${subject.credits} Credits</h3>
                  <p class="c-card__meta">Academic year ${subject.academicYear} • Semester ${subject.semester}</p>
                </div>
              </article>
            </c:forEach>
            <c:if test="${not empty currentGroup}">
              </div>
            </c:if>
          </section>
        </layout:student-dashboard>