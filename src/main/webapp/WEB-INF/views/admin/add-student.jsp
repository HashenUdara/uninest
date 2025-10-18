<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:admin-dashboard pageTitle="Add Student" activePage="students">
  <header class="c-page__header">
    <nav class="c-breadcrumbs" aria-label="Breadcrumb">
      <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
      <span class="c-breadcrumbs__sep">/</span>
      <a href="${pageContext.request.contextPath}/admin/students">Students</a>
      <span class="c-breadcrumbs__sep">/</span>
      <span aria-current="page">Add</span>
    </nav>
    <div class="c-page__titlebar">
      <div>
        <h1 class="c-page__title">Add Student</h1>
        <p class="c-page__subtitle u-text-muted">Create a new student account.</p>
      </div>
      <a class="c-btn c-btn--ghost" href="${pageContext.request.contextPath}/admin/students">
        <i data-lucide="arrow-left"></i> Back to Students
      </a>
    </div>
  </header>

  <section>
    <form class="c-form" action="${pageContext.request.contextPath}/admin/students/add" method="post">
      <div class="c-form-card">
        <div class="c-field">
          <label class="c-field__label" for="email">Email Address</label>
          <input class="c-field__input" id="email" name="email" type="email" 
                 placeholder="student@university.edu" required />
          <div class="c-field__error"></div>
        </div>

        <div class="c-field">
          <label class="c-field__label" for="password">Password</label>
          <input class="c-field__input" id="password" name="password" type="password" 
                 placeholder="Enter password" required />
          <div class="c-field__error"></div>
        </div>

        <div class="c-field">
          <label class="c-field__label" for="academicYear">Academic Year</label>
          <select class="c-field__input" id="academicYear" name="academicYear">
            <option value="">Select year (optional)</option>
            <option value="1">Year 1</option>
            <option value="2">Year 2</option>
            <option value="3">Year 3</option>
            <option value="4">Year 4</option>
          </select>
          <div class="c-field__error"></div>
        </div>

        <div class="c-field">
          <label class="c-field__label" for="university">University</label>
          <input class="c-field__input" id="university" name="university" type="text" 
                 placeholder="e.g., University of Colombo" />
          <div class="c-field__error"></div>
        </div>

        <div class="c-field">
          <label class="c-field__label" for="communityId">Community (Optional)</label>
          <select class="c-field__input" id="communityId" name="communityId">
            <option value="">Select community (optional)</option>
            <c:forEach items="${communities}" var="comm">
              <option value="${comm.id}">${comm.title}</option>
            </c:forEach>
          </select>
          <div class="c-field__error"></div>
        </div>

        <div class="c-form-actions">
          <a class="c-btn c-btn--ghost" href="${pageContext.request.contextPath}/admin/students">Cancel</a>
          <button type="submit" class="c-btn">Add Student</button>
        </div>
      </div>
    </form>
  </section>
</layout:admin-dashboard>
