<%@ tag description="Reusable dashboard layout for all roles" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="role" required="true" %>
<%@ attribute name="breadcrumb" required="true" %>
<%@ attribute name="navItems" required="true" type="java.util.List" %>
<%@ attribute name="styles" fragment="true" required="false" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${title}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/core.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/dashboard.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <script src="https://unpkg.com/lucide@latest" defer></script>
    <c:if test="${not empty styles}">
      <jsp:invoke fragment="styles" />
    </c:if>
  </head>
  <body>
    <div class="layout">
      <aside class="sidebar" aria-label="Primary">
        <div class="brand">
          <img class="logo-img" src="${pageContext.request.contextPath}/static/assets/img/logo.svg" alt="ResQnet Logo" width="120" height="32" />
          <span class="brand-name sr-only">ResQnet</span>
        </div>
        <nav class="nav">
          <c:forEach items="${navItems}" var="item">
            <button class="nav-item ${item.active ? 'active' : ''}" data-section="${item.section}">
              <span class="icon" data-lucide="${item.icon}"></span>
              <span>${item.label}</span>
            </button>
          </c:forEach>
        </nav>
        <div class="sidebar-footer">
          <form method="post" action="${pageContext.request.contextPath}/logout" style="margin:0;">
            <button type="submit" class="logout" aria-label="Logout">↩ Logout</button>
          </form>
        </div>
      </aside>

      <header class="topbar">
        <div class="breadcrumb">${breadcrumb}</div>
        <div class="topbar-right">
          <div class="hotline" role="button" tabindex="0" aria-label="Hotline 117">
            <span class="hotline-icon" data-lucide="phone"></span>
            Hotline: <strong>117</strong>
          </div>
          <div class="user-avatar" aria-label="User Menu" role="button">
            <img src="https://via.placeholder.com/40x40.png?text=U" alt="User Avatar" />
          </div>
          <button class="menu-toggle" aria-label="Open Menu">
            <span data-lucide="menu"></span>
          </button>
        </div>
      </header>

      <main class="content" id="mainContent" tabindex="-1">
        <jsp:doBody />
      </main>
    </div>

    <script>
      if (window.lucide) lucide.createIcons();

      document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', function() {
          document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
          this.classList.add('active');
        });
      });
    </script>

    <c:if test="${not empty scripts}">
      <jsp:invoke fragment="scripts" />
    </c:if>
  </body>
</html>
