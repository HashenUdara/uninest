<%@ tag description="Student dashboard layout" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="active" required="false" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${title} • UniNest</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link
    href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
    rel="stylesheet"
  />
  <!-- Reuse tokens/utilities from auth.css -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/auth.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/dashboard.css" />
  <script src="${pageContext.request.contextPath}/static/vendor/lucide.js"></script>
</head>
<body class="u-bg-surface">
  <div class="l-dashboard">
    <aside class="c-sidebar" aria-label="Primary">
      <div class="c-sidebar__brand">
        <span class="c-brand__logo" aria-hidden="true">
          <i data-lucide="layers"></i>
        </span>
        <span class="c-brand__name">Uninest</span>
      </div>
      <nav class="c-sidenav" aria-label="Main navigation">
        <a class="c-sidenav__item ${active == 'dashboard' ? 'is-active' : ''}" href="#">
          <i data-lucide="home" aria-hidden="true"></i>
          <span>Dashboard</span>
        </a>
        <a class="c-sidenav__item ${active == 'subjects' ? 'is-active' : ''}" href="#">
          <i data-lucide="book-open" aria-hidden="true"></i>
          <span>My Subjects</span>
        </a>
        <a class="c-sidenav__item" href="#">
          <i data-lucide="graduation-cap" aria-hidden="true"></i>
          <span>Kuppi Sessions</span>
        </a>
        <a class="c-sidenav__item" href="#">
          <i data-lucide="notebook-text" aria-hidden="true"></i>
          <span>My Resources</span>
        </a>
        <a class="c-sidenav__item" href="#">
          <i data-lucide="chart-bar" aria-hidden="true"></i>
          <span>Progress Analysis</span>
        </a>
        <a class="c-sidenav__item" href="#">
          <i data-lucide="messages-square" aria-hidden="true"></i>
          <span>Community</span>
        </a>
        <a class="c-sidenav__item" href="#">
          <i data-lucide="user-round-cog" aria-hidden="true"></i>
          <span>Profile Settings</span>
        </a>
      </nav>

      <div class="c-sidebar__spacer"></div>

      <section class="c-user-card" aria-label="Account">
        <div class="c-user-card__avatar" aria-hidden="true">S</div>
        <div class="c-user-card__body">
          <div class="c-user-card__name">Sophia</div>
          <div class="c-user-card__meta">Student</div>
        </div>
      </section>
      <a class="c-sidenav__logout" href="#">
        <i data-lucide="arrow-left" aria-hidden="true"></i>
        <span>Logout</span>
      </a>
    </aside>

    <main class="c-shell" aria-labelledby="page-title">
      <div class="c-shell__inner">
        <jsp:doBody />
      </div>
    </main>
  </div>

  <script>
    // Initialize icons
    if (window.lucide) { window.lucide.createIcons(); }
  </script>
  <c:if test="${not empty scripts}">
    <jsp:invoke fragment="scripts" />
  </c:if>
</body>
</html>
