<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<layout:modern-dashboard title="Admin Dashboard" pageTitle="Admin Dashboard">
  <jsp:attribute name="name">
    <dash:nav-item href="${pageContext.request.contextPath}/admin/dashboard" icon="home" label="Dashboard" active="${true}" />
    <dash:nav-item href="${pageContext.request.contextPath}/students" icon="users" label="Manage Students" active="${false}" />
    <dash:nav-item href="${pageContext.request.contextPath}/admin/organizations" icon="building" label="Organizations" active="${false}" />
    <dash:nav-item href="#" icon="settings" label="Settings" active="${false}" />
  </jsp:attribute>
  <jsp:attribute name="content">
    <dash:section title="Welcome, ${sessionScope.authUser.email}">
      <p>As an admin, you have full system privileges including user and content management.</p>
    </dash:section>
    
    <dash:section title="Quick Actions">
      <dash:grid>
        <dash:card title="Total Students" meta="Manage all students in the system" />
        <dash:card title="Organizations" meta="View and manage organizations" />
        <dash:card title="System Settings" meta="Configure system parameters" />
        <dash:card title="Reports" meta="View system reports and analytics" />
      </dash:grid>
    </dash:section>
  </jsp:attribute>
</layout:modern-dashboard>
