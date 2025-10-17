<%@ tag description="General User dashboard layout" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ attribute name="pageTitle" required="false" %>
<%@ attribute name="activePage" required="false" %>
<%@ attribute name="styles" fragment="true" required="false" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<%
  // Build navigation items without capturing non-final locals in anonymous inner classes
  java.util.List<java.util.Map<String, Object>> navItems = new java.util.ArrayList<>();

  String apAttr = (String) jspContext.getAttribute("activePage");
  final String ap = (apAttr == null || apAttr.isEmpty()) ? "overview" : apAttr; // effectively final

  java.util.Map<String, Object> item;

  item = new java.util.HashMap<>();
  item.put("section", "overview");
  item.put("icon", "home");
  item.put("label", "Overview");
  item.put("active", Boolean.valueOf("overview".equals(ap)));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "forecast");
  item.put("icon", "line-chart");
  item.put("label", "Forecast Dashboard");
  item.put("active", Boolean.valueOf("forecast".equals(ap)));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "make-donation");
  item.put("icon", "hand-coins");
  item.put("label", "Make a Donation");
  item.put("active", Boolean.valueOf("make-donation".equals(ap)));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "request-donation");
  item.put("icon", "package-plus");
  item.put("label", "Request a Donation");
  item.put("active", Boolean.valueOf("request-donation".equals(ap)));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "report-disaster");
  item.put("icon", "alert-octagon");
  item.put("label", "Report a Disaster");
  item.put("active", Boolean.valueOf("report-disaster".equals(ap)));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "be-volunteer");
  item.put("icon", "user-plus");
  item.put("label", "Be a Volunteer");
  item.put("active", Boolean.valueOf("be-volunteer".equals(ap)));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "forum");
  item.put("icon", "message-circle");
  item.put("label", "Forum");
  item.put("active", Boolean.valueOf("forum".equals(ap)));
  navItems.add(item);

  item = new java.util.HashMap<>();
  item.put("section", "profile-settings");
  item.put("icon", "user");
  item.put("label", "Profile Settings");
  item.put("active", Boolean.valueOf("profile-settings".equals(ap)));
  navItems.add(item);

  jspContext.setAttribute("navItems", navItems);

  String titleVal = (String) jspContext.getAttribute("pageTitle");
  if (titleVal == null) titleVal = "ResQnet - General Public Overview";
  jspContext.setAttribute("finalTitle", titleVal);

  String apForBc = (ap == null || ap.isEmpty()) ? "overview" : ap;
  String breadcrumbVal = "General Public Dashboard / <span>" +
    (apForBc.substring(0, 1).toUpperCase() + apForBc.substring(1).replace("-", " ")) +
    "</span>";
  jspContext.setAttribute("finalBreadcrumb", breadcrumbVal);
%>
<layout:dashboard title="${finalTitle}" role="general-user" breadcrumb="${finalBreadcrumb}" navItems="${navItems}">
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
