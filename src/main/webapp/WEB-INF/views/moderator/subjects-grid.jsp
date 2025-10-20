<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:moderator-dashboard pageTitle="Manage Subjects" activePage="subjects">
  
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
        <input class="c-input" type="search" placeholder="Search subjects by name or code" aria-label="Search subjects" />
        <button class="c-btn">Search</button>
      </div>
      <div class="c-view-switch" role="group" aria-label="View switch">
        <a class="c-view-switch__btn is-active" href="${pageContext.request.contextPath}/moderator/subjects" aria-current="page">
          <i data-lucide="grid"></i>
          <span>Grid</span>
        </a>
        <a class="c-view-switch__btn" href="${pageContext.request.contextPath}/moderator/subjects?view=list">
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
    <c:if test="${empty subjects}">
      <div style="text-align: center; padding: var(--space-10); color: var(--text-muted);">
        <p>No subjects found. Create your first subject to get started.</p>
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
      
      <article class="c-card" data-code="${subject.code}">
        <div class="c-card__media c-subj-thumb"></div>
        <div class="c-card__body">
          <span class="c-status is-${subject.status}">${subject.status}</span>
          <h3 class="c-card__title" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/moderator/topics?subjectId=${subject.subjectId}'">${subject.code} - ${subject.name}</h3>
          <p class="c-card__meta">Academic year ${subject.academicYear} • Semester ${subject.semester}</p>
          <div class="c-card__actions">
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
        </div>
      </article>
    </c:forEach>
    <c:if test="${currentSemester != -1}">
      </div>
    </c:if>
  </section>
</layout:moderator-dashboard>
