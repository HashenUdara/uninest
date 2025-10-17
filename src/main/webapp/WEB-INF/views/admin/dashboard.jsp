<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<layout:admin-dashboard activePage="dashboard">
  <dash:section title="Welcome, ${sessionScope.authUser.email}">
    <p>As an admin, you have full system privileges including user and content management.</p>
  </dash:section>

  <dash:section title="Quick Actions">
    <dash:grid>
      <dash:card title="Total Students" meta="Manage all students in the system" />
      <dash:card title="Communities" meta="View and manage communities" />
      <dash:card title="System Settings" meta="Configure system parameters" />
      <dash:card title="Reports" meta="View system reports and analytics" />
    </dash:grid>
  </dash:section>
</layout:admin-dashboard>
