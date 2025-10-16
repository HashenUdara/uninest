<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Create Organization">
  <h1 class="c-auth__title">Create your organization</h1>
  <c:if test="${not empty error}">
    <div class="c-field__error" style="text-align: center; font-size: var(--fs-sm); margin-bottom: var(--space-4);">${error}</div>
  </c:if>
  <form class="c-auth__form js-auth-form" method="post" action="${pageContext.request.contextPath}/moderator/organization/create" novalidate>
    <div class="c-field" style="grid-column: 1 / -1;">
      <label for="title" class="c-field__label">Organization title</label>
      <input type="text" id="title" name="title" class="c-field__input" placeholder="Ex: Computer Science Society" required />
      <p class="c-field__error" data-error-for="title" aria-live="polite"></p>
    </div>

    <div class="c-field" style="grid-column: 1 / -1;">
      <label for="description" class="c-field__label">Short description</label>
      <textarea id="description" name="description" class="c-field__input" rows="4" placeholder="Tell members what this organization is about"></textarea>
      <p class="c-field__error" data-error-for="description" aria-live="polite"></p>
    </div>

    <button type="submit" class="c-btn c-btn--primary c-auth__submit" style="grid-column: 1 / -1;">Submit for approval</button>
  </form>
</layout:auth>
