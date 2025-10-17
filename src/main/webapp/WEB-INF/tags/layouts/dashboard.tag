<%@ tag description="Modern dashboard layout with sidebar and navigation" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="pageTitle" required="false" %>
<%@ attribute name="breadcrumb" required="false" %>
<%@ attribute name="active" required="false" %>
<%@ attribute name="alerts" fragment="true" required="false" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<%@ attribute name="navigation" fragment="true" required="false" %>
<%@ attribute name="searchPlaceholder" required="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${not empty title ? title : 'Dashboard'} • Uninest</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link
    href="https://fonts.googleapis.com/css2?family=Figtree:wght@400;500;600;700&display=swap"
    rel="stylesheet"
  />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/dashboard.css" />
  <script src="${pageContext.request.contextPath}/static/vendor/lucide.js"></script>
</head>
<body>
  <button
    type="button"
    class="c-theme-toggle js-theme-toggle"
    aria-pressed="false"
    aria-label="Toggle dark mode"
  >
    <span class="c-theme-toggle__icon" aria-hidden="true"
      ><i data-lucide="moon"></i
    ></span>
    <span class="c-theme-toggle__label">Dark</span>
  </button>
  <div class="l-app">
    <!-- Sidebar -->
    <aside class="c-sidebar">
      <div class="c-logo">
        <img src="${pageContext.request.contextPath}/static/img/logo.png" alt="Uninest" class="c-logo__mark" />
      </div>
      <div class="c-user-mini">
        <div class="c-user-mini__avatar" aria-hidden="true"></div>
        <div class="c-user-mini__meta">
          <span class="c-user-mini__name">${sessionScope.authUser.email}</span>
          <span class="c-user-mini__role">${sessionScope.authUser.role}</span>
        </div>
      </div>
      <nav class="c-nav" aria-label="Main">
        <jsp:invoke fragment="navigation" />
      </nav>

      <form method="post" action="${pageContext.request.contextPath}/logout" style="margin-top: auto;">
        <button type="submit" class="c-nav__item c-logout-button" style="width: 100%; border: none; background: none; cursor: pointer; text-align: left;">
          <span class="c-nav__icon"><i data-lucide="log-out"></i></span>Logout
        </button>
      </form>
    </aside>

    <!-- Content -->
    <main class="c-page">
      <c:if test="${not empty alerts}">
        <div class="dash-alerts" style="margin-bottom: var(--space-6);">
          <jsp:invoke fragment="alerts" />
        </div>
      </c:if>
      

      <!-- Page content injected here -->
      <jsp:doBody />
    </main>
  </div>
  <script src="${pageContext.request.contextPath}/static/dashboard.js"></script>
  <c:if test="${not empty scripts}"><jsp:invoke fragment="scripts" /></c:if>
</body>
</html>
