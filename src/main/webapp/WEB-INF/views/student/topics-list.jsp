<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Topics - ${subject.name}" activePage="subjects">

    <script>
      /* ================= Topics: list avatars with title initials ================= */
      function initTopicAvatars() {
        const avatars = document.querySelectorAll(".c-table .c-topic-avatar");
        if (!avatars.length) return;
        const hueFromTitle = (title) => {
          let h = 0;
          for (let i = 0; i < title.length; i++) {
            h = (h * 31 + title.charCodeAt(i)) % 360;
          }
          return h;
        };
        const getInitials = (title) => {
          const words = title.trim().split(/\s+/);
          if (words.length === 1) return words[0].substring(0, 2).toUpperCase();
          return (words[0].charAt(0) + words[1].charAt(0)).toUpperCase();
        };
        avatars.forEach((el) => {
          const row = el.closest("tr");
          const title = (row?.getAttribute("data-title") || "").trim() || "Topic";
          const hue = hueFromTitle(title);
          const bg = "hsl(" + hue + " 85% 95%)";
          const fg = "hsl(" + hue + " 50% 28%)";
          el.style.background = bg;
          el.style.color = fg;
          el.textContent = getInitials(title);
        });
      }
      
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
      
      document.addEventListener("DOMContentLoaded", initTopicAvatars);
    </script>


  <header class="c-page__header">
    <nav class="c-breadcrumbs" aria-label="Breadcrumb">
      <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
      <span class="c-breadcrumbs__sep">/</span>
      <a href="${pageContext.request.contextPath}/student/subjects">My Subjects</a>
      <span class="c-breadcrumbs__sep">/</span>
      <span aria-current="page">${subject.name}</span>
    </nav>
    <div class="c-page__titlebar">
      <div>
        <h1 class="c-page__title">${subject.code} - ${subject.name}</h1>
        <p class="c-page__subtitle u-text-muted">Explore topics in this subject.</p>
      </div>
    </div>
    <div class="c-toolbar">
      <div class="c-input-group">
        <input class="c-input" type="search" placeholder="Search topics" aria-label="Search topics" />
        <button class="c-btn">Search</button>
      </div>
      <div class="c-view-switch" role="group" aria-label="View switch">
        <a class="c-view-switch__btn" href="${pageContext.request.contextPath}/student/topics?subjectId=${subject.subjectId}">
          <i data-lucide="grid"></i>
          <span>Grid</span>
        </a>
        <a class="c-view-switch__btn is-active" href="${pageContext.request.contextPath}/student/topics?subjectId=${subject.subjectId}&view=list" aria-current="page">
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
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${topics}" var="topic">
              <tr data-title="${topic.title}">
                <td>
                  <div style="display: flex; align-items: center; gap: var(--space-3);">
                    <div class="c-topic-avatar"></div>
                    <span>${topic.title}</span>
                  </div>
                </td>
                <td>${topic.description != null ? topic.description : '-'}</td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </section>
</layout:student-dashboard>
