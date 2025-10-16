<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<layout:dashboard title="Subject Coordinator Dashboard" pageTitle="Coordinator Dashboard">
  
  <jsp:attribute name="content">
    <dash:section title="Welcome, ${sessionScope.authUser.email}">
      <p>As a subject coordinator, you can manage subjects, topics, and upload resources.</p>
    </dash:section>
    
    <dash:section title="My Subjects">
      <dash:grid>
        <dash:card title="Data Structures" meta="CS204 - 45 students enrolled" />
        <dash:card title="Algorithms" meta="CS205 - 38 students enrolled" />
        <dash:card title="Database Systems" meta="CS301 - 52 students enrolled" />
        <dash:card title="Software Engineering" meta="CS401 - 41 students enrolled" />
      </dash:grid>
    </dash:section>
  </jsp:attribute>
  <jsp:body>
    <dash:nav-item href="${pageContext.request.contextPath}/coordinator/dashboard" icon="home" label="Dashboard" active="${true}" />
    <dash:nav-item href="#" icon="book-open" label="My Subjects" active="${false}" />
    <dash:nav-item href="#" icon="folder" label="Topics" active="${false}" />
    <dash:nav-item href="#" icon="upload" label="Upload Resources" active="${false}" />
    <dash:nav-item href="#" icon="bar-chart" label="Analytics" active="${false}" />
    <dash:nav-item href="#" icon="settings" label="Settings" active="${false}" />
  </jsp:body>
</layout:dashboard>
