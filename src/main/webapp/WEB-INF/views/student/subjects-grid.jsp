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
        <input class="c-input" type="search" placeholder="Search subjects by name or code" aria-label="Search subjects" />
        <button class="c-btn">Search</button>
      </div>
      <div class="c-view-switch" role="group" aria-label="View switch">
        <a class="c-view-switch__btn is-active" href="${pageContext.request.contextPath}/student/subjects" aria-current="page">
          <i data-lucide="grid"></i>
          <span>Grid</span>
        </a>
        <a class="c-view-switch__btn" href="${pageContext.request.contextPath}/student/subjects?view=list">
          <i data-lucide="list"></i>
          <span>List</span>
        </a>
      </div>
    </div>
  </header>

  <section>
    <c:if test="${empty subjects}">
      <div style="text-align: center; padding: var(--space-10); color: var(--text-muted);">
        <p>No subjects found in your community.</p>
      </div>
    </c:if>

    <c:set var="currentSemester" value="-1" />
    <c:forEach items="${subjects}" var="subject">
      <c:if test="${subject.semester != currentSemester}">
        <c:if test="${currentSemester != -1}">
          </div>
        </c:if>
        <h2 class="c-section-title">Semester ${subject.semester}</h2>
        <div class="o-grid o-grid--cards">
        <c:set var="currentSemester" value="${subject.semester}" />
      </c:if>
      
      <article class="c-card" data-code="${subject.code}" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/student/topics?subjectId=${subject.subjectId}'">
        <div class="c-card__media c-subj-thumb"></div>
        <div class="c-card__body">
          <span class="c-status is-${subject.status}">${subject.status}</span>
          <h3 class="c-card__title">${subject.code} - ${subject.name}</h3>
          <p class="c-card__meta">Academic year ${subject.academicYear} • Semester ${subject.semester}</p>
        </div>
      </article>
    </c:forEach>
    <c:if test="${currentSemester != -1}">
      </div>
    </c:if>
  </section>
</layout:student-dashboard>
