<%@ tag description="Authentication page layout" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="true" %>
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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/auth.css" />
  <script src="${pageContext.request.contextPath}/static/vendor/lucide.js"></script>
</head>
<body class="u-bg-surface">
  <button
    type="button"
    class="c-theme-toggle js-theme-toggle"
    aria-pressed="false"
    aria-label="Toggle dark mode"
  >
    <span class="c-theme-toggle__icon" aria-hidden="true"><i data-lucide="moon"></i></span>
    <span class="c-theme-toggle__label">Dark</span>
  </button>
  <main class="o-center">
    <section class="c-auth" aria-labelledby="auth-title">
      <jsp:doBody />
    </section>
  </main>
  <script src="${pageContext.request.contextPath}/static/auth.js"></script>
  <c:if test="${not empty scripts}">
    <jsp:invoke fragment="scripts" />
  </c:if>
</body>
</html>
