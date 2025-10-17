<%@ tag description="Authentication page layout with header" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<%@ attribute name="styles" fragment="true" required="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>${title} – ResQnet</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/core.css" />
  <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/assets/img/logo.svg" />
  <script src="https://unpkg.com/lucide@latest" defer></script>
  <c:if test="${not empty styles}">
    <jsp:invoke fragment="styles" />
  </c:if>
</head>
<body>
  <header class="site-header">
    <div class="site-header__inner">
      <a href="${pageContext.request.contextPath}/" class="brand-inline">
        <img src="${pageContext.request.contextPath}/static/assets/img/logo.svg" alt="ResQnet Logo" />
        
      </a>
      <nav class="primary-nav" aria-label="Main"></nav>
      <div class="auth-actions">
        <a href="${pageContext.request.contextPath}/login" class="btn">Login</a>
        <a href="${pageContext.request.contextPath}/signup" class="btn btn-primary">Sign Up</a>
      </div>
    </div>
  </header>

  <main id="mainContent" tabindex="-1">
    <jsp:doBody />
  </main>

  <c:if test="${not empty scripts}">
    <jsp:invoke fragment="scripts" />
  </c:if>
</body>
</html>
