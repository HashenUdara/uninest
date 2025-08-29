<%@ tag description="Unified page layout (header/footer + optional sidebar)" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="active" required="false" %>
<%@ attribute name="sidebar" fragment="true" required="false" %>
<%@ attribute name="bodyClass" required="false" %>
<%@ attribute name="headExtra" fragment="true" required="false" %>
<%@ attribute name="alerts" fragment="true" required="false" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>${title}</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/style.css" />
  <c:if test="${not empty headExtra}"><jsp:invoke fragment="headExtra" /></c:if>
</head>
<body class="${bodyClass}">
<header class="topbar">
  <div class="brand"><a href="${pageContext.request.contextPath}/students">Uninest</a></div>
  <nav class="topnav">
    <a class="${active == 'students' ? 'active' : ''}" href="${pageContext.request.contextPath}/students">Students</a>
  <c:if test="${sessionScope.isAdmin}">
      <a class="${active == 'add' ? 'active' : ''}" href="${pageContext.request.contextPath}/students/add">Add</a>
    </c:if>
    <c:choose>
      <c:when test="${empty sessionScope.authUser}">
        <a href="${pageContext.request.contextPath}/login">Login</a>
      </c:when>
      <c:otherwise>
        <form style="display:inline;" method="post" action="${pageContext.request.contextPath}/logout">
          <button class="btn" type="submit" style="background:#334155;">Logout</button>
        </form>
      </c:otherwise>
    </c:choose>
  </nav>
</header>
<div class="layout-shell">
  <c:choose>
    <c:when test="${not empty sidebar}">
      <aside class="sidebar">
        <jsp:invoke fragment="sidebar" />
      </aside>
      <main class="content with-sidebar">
        <jsp:doBody />
      </main>
    </c:when>
    <c:otherwise>
      <main class="content">
        <jsp:doBody />
      </main>
    </c:otherwise>
  </c:choose>
</div>
<c:if test="${not empty alerts}">
  <section class="alerts">
    <jsp:invoke fragment="alerts" />
  </section>
</c:if>
<footer class="site-footer">&copy; 2025 Uninest</footer>
<c:if test="${not empty scripts}"><jsp:invoke fragment="scripts" /></c:if>
</body>
</html>