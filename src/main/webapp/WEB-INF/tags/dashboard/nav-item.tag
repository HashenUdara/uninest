<%@ tag description="Navigation link for dashboard sidebar" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="href" required="true" %>
<%@ attribute name="icon" required="true" %>
<%@ attribute name="label" required="true" %>
<%@ attribute name="active" required="false" type="java.lang.Boolean" %>
<a href="${href}" class="c-nav__item ${active ? 'is-active' : ''}">
  <span class="c-nav__icon"><i data-lucide="${icon}"></i></span>${label}
</a>
