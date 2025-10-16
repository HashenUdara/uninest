<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Create Organization">
  <jsp:body>
    <h1 class="c-auth__title" id="auth-title">Create Your Organization</h1>
    <p class="c-auth__subtitle" style="text-align: center; margin-bottom: var(--space-6); color: var(--color-muted);">
      Set up your organization to manage students and content
    </p>
    <c:if test="${not empty error}">
      <div class="c-field__error" style="text-align: center; font-size: var(--fs-sm); margin-bottom: var(--space-4);">${error}</div>
    </c:if>
    <form class="c-auth__form" method="post" action="${pageContext.request.contextPath}/moderator/create-organization" novalidate>
      <div class="c-field">
        <label for="title" class="c-field__label">Organization Title</label>
        <input
          type="text"
          id="title"
          name="title"
          class="c-field__input"
          placeholder="Enter organization name"
          required
          autofocus
          value="${param.title}"
        />
        <p class="c-field__error" data-error-for="title" aria-live="polite"></p>
      </div>
      
      <div class="c-field">
        <label for="description" class="c-field__label">Description</label>
        <textarea
          id="description"
          name="description"
          class="c-field__input"
          placeholder="Briefly describe your organization"
          required
          rows="4"
          style="resize: vertical; min-height: 100px;"
        >${param.description}</textarea>
        <p class="c-field__error" data-error-for="description" aria-live="polite"></p>
      </div>
      
      <button type="submit" class="c-btn c-btn--primary c-auth__submit">Create Organization</button>
    </form>
    
    <div class="c-auth__switch" style="margin-top: var(--space-6);">
      <a href="${pageContext.request.contextPath}/logout" class="c-link">Logout</a>
    </div>
  </jsp:body>
</layout:auth>
