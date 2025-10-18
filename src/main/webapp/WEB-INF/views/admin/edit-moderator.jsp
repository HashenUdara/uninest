<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:admin-dashboard pageTitle="Edit Moderator" activePage="moderators">
  <header class="c-page__header">
    <nav class="c-breadcrumbs" aria-label="Breadcrumb">
      <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
      <span class="c-breadcrumbs__sep">/</span>
      <a href="${pageContext.request.contextPath}/admin/moderators">Moderators</a>
      <span class="c-breadcrumbs__sep">/</span>
      <span aria-current="page">Edit</span>
    </nav>
    <div class="c-page__titlebar">
      <div>
        <h1 class="c-page__title">Edit Moderator</h1>
        <p class="c-page__subtitle u-text-muted">Update moderator account information.</p>
      </div>
      <a class="c-btn c-btn--ghost" href="${pageContext.request.contextPath}/admin/moderators">
        <i data-lucide="arrow-left"></i> Back to Moderators
      </a>
    </div>
  </header>

  <section>
    <form class="c-form" action="${pageContext.request.contextPath}/admin/moderators/edit" method="post">
      <input type="hidden" name="id" value="${moderator.id}" />
      <div class="c-form-card">
        <div class="c-field">
          <label class="c-field__label" for="email">Email Address</label>
          <input class="c-field__input" id="email" name="email" type="email" 
                 value="${moderator.email}" required />
          <div class="c-field__error"></div>
        </div>

        <div class="c-field">
          <label class="c-field__label" for="university">University</label>
          <input class="c-field__input" id="university" name="university" type="text" 
                 value="${moderator.university}" placeholder="e.g., University of Colombo" />
          <div class="c-field__error"></div>
        </div>

        <div class="c-field">
          <label class="c-field__label" for="communityId">Community (Optional)</label>
          <select class="c-field__input" id="communityId" name="communityId">
            <option value="">Select community (optional)</option>
            <c:forEach items="${communities}" var="comm">
              <option value="${comm.id}" ${moderator.communityId == comm.id ? 'selected' : ''}>
                ${comm.title}
              </option>
            </c:forEach>
          </select>
          <div class="c-field__error"></div>
        </div>

        <div class="c-form-actions">
          <a class="c-btn c-btn--ghost" href="${pageContext.request.contextPath}/admin/moderators">Cancel</a>
          <button type="submit" class="c-btn">Update Moderator</button>
        </div>
      </div>
    </form>
  </section>
</layout:admin-dashboard>
