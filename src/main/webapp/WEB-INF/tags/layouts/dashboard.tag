<%@ tag description="Dashboard layout with sidebar and top bar" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="active" required="false" %>
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
<body class="dash-body">
<aside class="dash-sidebar">
  <div class="dash-brand">Uninest</div>
  <nav class="dash-nav">
    <a class="dash-item ${active == 'overview' ? 'active' : ''}" href="${pageContext.request.contextPath}/students">Overview</a>
    <c:if test="${sessionScope.authUser.role == 'ADMIN'}">
      <a class="dash-item ${active == 'admin' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
    </c:if>
    <c:if test="${sessionScope.authUser.role == 'MANAGER'}">
      <a class="dash-item ${active == 'manager' ? 'active' : ''}" href="${pageContext.request.contextPath}/manager/dashboard">Manager</a>
    </c:if>
    <c:if test="${sessionScope.authUser.role == 'STAFF'}">
      <a class="dash-item ${active == 'staff' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/dashboard">Staff</a>
    </c:if>
    <a class="dash-item" href="${pageContext.request.contextPath}/students">Students</a>
  </nav>
  <form class="dash-logout" method="post" action="${pageContext.request.contextPath}/logout">
    <button type="submit">Logout</button>
  </form>
</aside>
<div class="dash-main">
  <header class="dash-topbar">
    <div class="dash-breadcrumb">${title}</div>
    <div class="dash-user">${sessionScope.authUser.email}</div>
  </header>
  <div class="dash-content">
    <c:if test="${not empty alerts}">
      <div class="dash-alerts"><jsp:invoke fragment="alerts" /></div>
    </c:if>
    <jsp:doBody />
  </div>
  <footer class="dash-footer">&copy; 2025 Uninest</footer>
</div>
<c:if test="${not empty scripts}"><jsp:invoke fragment="scripts" /></c:if>
</body>
</html><%@ tag description="Dashboard layout with sidebar and top bar" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="active" required="false" %>
<%@ attribute name="breadcrumb" required="false" %>
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
<body class="dash-body">
  <aside class="dash-sidebar">
    <div class="logo">Uninest</div>
    <nav class="dash-nav">
      <a class="nav-item ${active=='overview' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/dashboard">Overview</a>
      <a class="nav-item ${active=='forecast' ? 'active' : ''}" href="#">Forecast Dashboard</a>
      <a class="nav-item ${active=='donate' ? 'active' : ''}" href="#">Make a Donation</a>
      <a class="nav-item ${active=='request' ? 'active' : ''}" href="#">Request a Donation</a>
      <a class="nav-item ${active=='report' ? 'active' : ''}" href="#">Report a Disaster</a>
      <a class="nav-item ${active=='volunteer' ? 'active' : ''}" href="#">Be a Volunteer</a>
      <a class="nav-item ${active=='forum' ? 'active' : ''}" href="#">Forum</a>
      <a class="nav-item ${active=='profile' ? 'active' : ''}" href="#">Profile Settings</a>
    </nav>
    <form class="logout-form" method="post" action="${pageContext.request.contextPath}/logout">
      <button type="submit">⟵ Logout</button>
    </form>
  </aside>
  <div class="dash-main-wrapper">
    <header class="dash-topbar">
      <div class="crumb">${breadcrumb}</div>
      <div class="top-right">
        <div class="hotline">Hotline: <strong>117</strong></div>
        <div class="avatar" title="${sessionScope.authUser.email}">${sessionScope.authUser.email.substring(0,1).toUpperCase()}</div>
      </div>
    </header>
    <main class="dash-content">
      <c:if test="${not empty alerts}">
        <div class="dash-alerts">
          <jsp:invoke fragment="alerts" />
        </div>
      </c:if>
      <jsp:doBody />
    </main>
  </div>
  <c:if test="${not empty scripts}"><jsp:invoke fragment="scripts" /></c:if>
</body>
</html>
