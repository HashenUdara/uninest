<%@ tag description="Volunteer dashboard layout" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ attribute name="pageTitle" required="false" %>
<%@ attribute name="activePage" required="false" %>
<%@ attribute name="styles" fragment="true" required="false" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<%
  // Make active page effectively final
  final String activePageRaw = (String) jspContext.getAttribute("activePage");
  final String activePageVal = (activePageRaw != null) ? activePageRaw : "overview";

  // Build nav items without double-brace initialization
  java.util.List<java.util.Map<String, Object>> navItems = new java.util.ArrayList<>();
  java.util.Map<String, Object> item;

  item = new java.util.HashMap<>();
  item.put("section", "overview");
  item.put("icon", "home");
  item.put("label", "Overview");
  item.put("active", "overview".equals(activePageVal));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "forecast");
  item.put("icon", "line-chart");
  item.put("label", "Forecast Dashboard");
  item.put("active", "forecast".equals(activePageVal));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "safe-locations");
  item.put("icon", "map-pin");
  item.put("label", "Safe Locations");
  item.put("active", "safe-locations".equals(activePageVal));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "make-donation");
  item.put("icon", "hand-coins");
  item.put("label", "Make a Donation");
  item.put("active", "make-donation".equals(activePageVal));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "request-donation");
  item.put("icon", "package-plus");
  item.put("label", "Request a Donation");
  item.put("active", "request-donation".equals(activePageVal));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "report-disaster");
  item.put("icon", "alert-octagon");
  item.put("label", "Report a Disaster");
  item.put("active", "report-disaster".equals(activePageVal));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "forum");
  item.put("icon", "message-circle");
  item.put("label", "Forum");
  item.put("active", "forum".equals(activePageVal));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "profile-settings");
  item.put("icon", "user");
  item.put("label", "Profile Settings");
  item.put("active", "profile-settings".equals(activePageVal));
  navItems.add(item);

  jspContext.setAttribute("navItems", navItems);

  String titleVal = (String) jspContext.getAttribute("pageTitle");
  if (titleVal == null) titleVal = "ResQnet - Volunteer Overview";
  jspContext.setAttribute("finalTitle", titleVal);

  String breadcrumbVal = "Volunteer Dashboard / <span>" +
    (activePageVal.substring(0, 1).toUpperCase() + activePageVal.substring(1).replace("-", " ")) +
    "</span>";
  jspContext.setAttribute("finalBreadcrumb", breadcrumbVal);
%>
<layout:dashboard title="${finalTitle}" role="volunteer" breadcrumb="${finalBreadcrumb}" navItems="${navItems}">
  <jsp:attribute name="styles">
    <c:if test="${not empty styles}">
      <jsp:invoke fragment="styles" />
    </c:if>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <c:if test="${not empty scripts}">
      <jsp:invoke fragment="scripts" />
    </c:if>
  </jsp:attribute>
  <jsp:body>
    <jsp:doBody />
  </jsp:body>
</layout:dashboard>
