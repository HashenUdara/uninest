<%@ tag description="Collapsible navigation group for dashboard sidebar" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="icon" required="true" %>
<%@ attribute name="label" required="true" %>
<%@ attribute name="active" required="false" type="java.lang.Boolean" %>
<%@ attribute name="groupId" required="true" %>
<div class="c-nav-group ${active ? 'is-active' : ''}">
  <button type="button" class="c-nav__item c-nav-group__trigger" data-nav-group="${groupId}" aria-expanded="${active ? 'true' : 'false'}">
    <span class="c-nav__icon"><i data-lucide="${icon}"></i></span>${label}
    <span class="c-nav-group__icon"><i data-lucide="chevron-down"></i></span>
  </button>
  <div class="c-nav-group__content" id="nav-group-${groupId}" ${!active ? 'style="display:none"' : ''}>
    <jsp:doBody />
  </div>
</div>
