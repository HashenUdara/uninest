<%@ tag description="Unified page layout (header/footer + optional sidebar)" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="active" required="false" %>
<%-- Removed unused attributes: sidebar, bodyClass, headExtra --%>
<%@ attribute name="alerts" fragment="true" required="false" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>${title}</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/style.css" />
</head>
<body>
<header class="topbar">
  <div class="brand"><a href="${pageContext.request.contextPath}/students">resqnet</a></div>
  <nav class="topnav">
    <c:choose>
      <c:when test="${not empty sessionScope.authUser}">
        <a class="${active == 'students' ? 'active' : ''}" href="${pageContext.request.contextPath}/students">Students</a>
        <c:if test="${sessionScope.authUser.role == 'ADMIN'}">
          <a class="${active == 'add' ? 'active' : ''}" href="${pageContext.request.contextPath}/students/add">Add</a>
          <a class="${active == 'admin' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
          <a class="${active == 'manager' ? 'active' : ''}" href="${pageContext.request.contextPath}/manager/dashboard">Manager</a>
        </c:if>
        <c:if test="${sessionScope.authUser.role == 'MANAGER'}">
          <a class="${active == 'manager' ? 'active' : ''}" href="${pageContext.request.contextPath}/manager/dashboard">Manager</a>
        </c:if>
        <c:if test="${sessionScope.authUser.role == 'STAFF'}">
          <a class="${active == 'staff' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/dashboard">Staff</a>
        </c:if>
        <form style="display:inline;" method="post" action="${pageContext.request.contextPath}/logout">
          <button class="btn danger" type="submit" style="margin-left:0.5rem;">Logout</button>
        </form>
      </c:when>
      <c:otherwise>
        <a class="${active == 'login' ? 'active' : ''}" href="${pageContext.request.contextPath}/login">Login</a>
      </c:otherwise>
    </c:choose>
  </nav>
</header>
<main class="content">
  <jsp:doBody />
</main>
<c:if test="${not empty alerts}">
  <section class="alerts">
    <jsp:invoke fragment="alerts" />
  </section>
</c:if>
<footer class="site-footer">&copy; 2025 resqnet</footer>
<c:if test="${not empty scripts}"><jsp:invoke fragment="scripts" /></c:if>
</body>
</html>