<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<layout:modern-dashboard title="Student Dashboard" pageTitle="My Dashboard">
  <jsp:attribute name="name">
    <dash:nav-item href="${pageContext.request.contextPath}/student/dashboard" icon="home" label="Dashboard" active="${true}" />
    <dash:nav-item href="#" icon="book" label="My Subjects" active="${false}" />
    <dash:nav-item href="#" icon="graduation-cap" label="Kuppi Sessions" active="${false}" />
    <dash:nav-item href="#" icon="file-text" label="My Resources" active="${false}" />
    <dash:nav-item href="#" icon="bar-chart-3" label="Progress Analysis" active="${false}" />
    <dash:nav-item href="#" icon="message-square" label="Community" active="${false}" />
    <dash:nav-item href="#" icon="user" label="Profile Settings" active="${false}" />
  </jsp:attribute>
  <jsp:attribute name="content">
    <h2 class="c-section-title">Welcome, ${sessionScope.authUser.email}</h2>
    <p>Access your subjects, resources, and track your learning progress.</p>
    
    <h2 class="c-section-title">My Subjects</h2>
    <div class="o-grid o-grid--cards">
      <dash:card title="Data Structures" meta="CS204 - Dr. Evelyn Reed" />
      <dash:card title="Algorithms" meta="CS205 - Prof. Michael Chen" />
      <dash:card title="Database Systems" meta="CS301 - Dr. Sarah Wilson" />
      <dash:card title="Web Development" meta="CS320 - Prof. James Anderson" />
    </div>
  </jsp:attribute>
</layout:modern-dashboard>
