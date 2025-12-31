<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:admin-dashboard pageTitle="Edit Student" activePage="students">
  <header class="c-page__header">
    <nav class="c-breadcrumbs" aria-label="Breadcrumb">
      <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
      <span class="c-breadcrumbs__sep">/</span>
      <a href="${pageContext.request.contextPath}/admin/students">Students</a>
      <span class="c-breadcrumbs__sep">/</span>
      <span aria-current="page">Edit</span>
    </nav>
    <div class="c-page__titlebar">
      <div>
        <h1 class="c-page__title">Edit Student</h1>
        <p class="c-page__subtitle u-text-muted">Update student account information.</p>
      </div>
      <a class="c-btn c-btn--ghost" href="${pageContext.request.contextPath}/admin/students">
        <i data-lucide="arrow-left"></i> Back to Students
      </a>
    </div>
  </header>

  <section>
    <form class="c-form" action="${pageContext.request.contextPath}/admin/students/edit" method="post">
      <input type="hidden" name="id" value="${student.id}" />
      <div class="c-form-card">
        <div class="c-field">
          <label class="c-field__label" for="name">Full Name</label>
          <input class="c-field__input" id="name" name="name" type="text" 
                 value="${student.name}" placeholder="Enter student name" />
          <div class="c-field__error"></div>
        </div>

        <div class="c-field">
          <label class="c-field__label" for="email">Email Address</label>
          <input class="c-field__input" id="email" name="email" type="email" 
                 value="${student.email}" required />
          <div class="c-field__error"></div>
        </div>

        <div class="c-field">
          <label class="c-field__label" for="academicYear">Academic Year</label>
          <select class="c-field__input" id="academicYear" name="academicYear">
            <option value="">Select year (optional)</option>
            <option value="1" ${student.academicYear == 1 ? 'selected' : ''}>Year 1</option>
            <option value="2" ${student.academicYear == 2 ? 'selected' : ''}>Year 2</option>
            <option value="3" ${student.academicYear == 3 ? 'selected' : ''}>Year 3</option>
            <option value="4" ${student.academicYear == 4 ? 'selected' : ''}>Year 4</option>
          </select>
          <div class="c-field__error"></div>
        </div>

        <div class="c-field">
          <label class="c-field__label" for="university">University</label>
          <select class="c-field__input" id="university" name="universityId">
            <option value="">Select university (optional)</option>
            <c:forEach items="${universities}" var="uni">
              <option value="${uni.id}" ${student.universityId == uni.id ? 'selected' : ''}>
                ${uni.name}
              </option>
            </c:forEach>
          </select>
          <div class="c-field__error"></div>
        </div>

        <div class="c-field">
          <label class="c-field__label" for="newPassword">New Password (Optional)</label>
          <input class="c-field__input" id="newPassword" name="newPassword" type="password" 
                 placeholder="Leave blank to keep current password" />
          <div class="c-field__error"></div>
          <small class="c-field__hint">Enter a new password only if you want to reset it.</small>
        </div>

        <div class="c-field">
          <label class="c-field__label" for="communityId">Community (Optional)</label>
          <select class="c-field__input" id="communityId" name="communityId">
            <option value="">Select community (optional)</option>
            <c:forEach items="${communities}" var="comm">
              <option value="${comm.id}" ${student.communityId == comm.id ? 'selected' : ''}>
                ${comm.title}
              </option>
            </c:forEach>
          </select>
          <div class="c-field__error"></div>
        </div>

        <div class="c-form-actions">
          <a class="c-btn c-btn--ghost" href="${pageContext.request.contextPath}/admin/students">Cancel</a>
          <button type="submit" class="c-btn">Update Student</button>
        </div>
      </div>
    </form>
  </section>
</layout:admin-dashboard>
