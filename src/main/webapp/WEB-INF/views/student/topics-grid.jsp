<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Topics - ${subject.name}" activePage="subjects">

    <script>
      /* ================= Topics: grid avatars with title initials ================= */
      function initTopicAvatars() {
        const avatars = document.querySelectorAll(".c-card .c-topic-avatar");
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
          const card = el.closest(".c-card");
          const title = (card?.getAttribute("data-title") || "").trim() || "Topic";
          const hue = hueFromTitle(title);
          const bg = "hsl(" + hue + " 85% 95%)";
          const fg = "hsl(" + hue + " 50% 28%)";
          el.style.background = bg;
          el.style.color = fg;
          el.textContent = getInitials(title);
        });
      }
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
        <a class="c-view-switch__btn is-active" href="${pageContext.request.contextPath}/student/topics?subjectId=${subject.subjectId}" aria-current="page">
          <i data-lucide="grid"></i>
          <span>Grid</span>
        </a>
        <a class="c-view-switch__btn" href="${pageContext.request.contextPath}/student/topics?subjectId=${subject.subjectId}&view=list">
          <i data-lucide="list"></i>
          <span>List</span>
        </a>
      </div>
    </div>
  </header>

  <section>
    <c:if test="${empty topics}">
      <div style="text-align: center; padding: var(--space-10); color: var(--text-muted);">
        <p>No topics found in this subject.</p>
      </div>
    </c:if>

    <div class="o-grid o-grid--cards">
      <c:forEach items="${topics}" var="topic">
        <article class="c-card" data-title="${topic.title}">
          <div class="c-card__media c-topic-avatar"></div>
          <div class="c-card__body">
            <h3 class="c-card__title">${topic.title}</h3>
            <p class="c-card__meta">${topic.description != null ? topic.description : 'No description'}</p>
          </div>
        </article>
      </c:forEach>
    </div>
  </section>
</layout:student-dashboard>
