<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<layout:student-dashboard activePage="dashboard">
  <dash:section title="Welcome, ${sessionScope.authUser.email}">
    <p>Access your subjects, resources, and track your learning progress.</p>
  </dash:section>
  
  <dash:section title="My Subjects">
    <dash:grid>
      <dash:card title="Data Structures" meta="CS204 - Dr. Evelyn Reed" />
      <dash:card title="Algorithms" meta="CS205 - Prof. Michael Chen" />
      <dash:card title="Database Systems" meta="CS301 - Dr. Sarah Wilson" />
      <dash:card title="Web Development" meta="CS320 - Prof. James Anderson" />
    </dash:grid>
  </dash:section>
</layout:student-dashboard>
