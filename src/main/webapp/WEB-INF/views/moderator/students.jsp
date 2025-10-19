<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:moderator-dashboard pageTitle="Students" activePage="students">
    <header class="c-page__header">
      <nav class="c-breadcrumbs" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/moderator/dashboard">Moderator</a>
        <span class="c-breadcrumbs__sep">/</span>
        <span aria-current="page">Students</span>
      </nav>
      <div class="c-page__titlebar">
        <div>
          <h1 class="c-page__title">Students</h1>
          <p class="c-page__subtitle u-text-muted">Manage students in your community.</p>
        </div>
      </div>
    </header>

    <section>
      <c:if test="${param.success == 'removed'}">
        <div class="c-alert c-alert--success" role="alert">
          <i data-lucide="check-circle"></i>
          <span>Student removed from community successfully!</span>
        </div>
      </c:if>

      <div class="c-table-toolbar">
        <div class="c-table-toolbar__left">
          <span class="u-text-muted">
            <span class="js-student-count">${students.size()}</span> students
          </span>
        </div>
      </div>
      <div class="c-table-wrap">
        <table class="c-table c-table--sticky" aria-label="Students" data-student-table>
          <thead>
            <tr>
              <th>Student</th>
              <th>Email</th>
              <th>Academic Year</th>
              <th>University</th>
              <th class="u-text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${students}" var="student">
              <tr>
                <td>
                  <div class="c-user-cell">
                    <span class="c-user-cell__avatar" aria-hidden="true"></span>
                    <div class="c-user-cell__meta">
                      <span class="c-user-cell__name">${student.name != null ? student.name : student.email}</span>
                      <span class="c-user-cell__sub u-text-muted">ID: ${student.id}</span>
                    </div>
                  </div>
                </td>
                <td>${student.email}</td>
                <td>
                  <c:choose>
                    <c:when test="${not empty student.academicYear}">Year ${student.academicYear}</c:when>
                    <c:otherwise>-</c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${not empty student.universityName}">${student.universityName}</c:when>
                    <c:otherwise>-</c:otherwise>
                  </c:choose>
                </td>
                <td class="u-text-right">
                  <div class="c-table-actions">
                    <form method="post" action="${pageContext.request.contextPath}/moderator/students/remove" style="display:inline" class="js-student-remove">
                      <input type="hidden" name="id" value="${student.id}" />
                      <button class="c-btn c-btn--sm c-btn--danger" type="submit" aria-label="Remove from community">
                        <i data-lucide="user-minus"></i> Remove
                      </button>
                    </form>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </section>

    <!-- Confirm Modal -->
    <div class="c-modal" id="confirm-modal" role="dialog" aria-modal="true" aria-labelledby="confirm-title" hidden>
      <div class="c-modal__backdrop" data-close></div>
      <div class="c-modal__dialog">
        <div class="c-modal__header">
          <h3 id="confirm-title">Confirm</h3>
        </div>
        <div class="c-modal__body">
          <p>Are you sure?</p>
        </div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--ghost" data-close>Cancel</button>
          <button class="c-btn c-btn--danger js-confirm-action">Confirm</button>
        </div>
      </div>
    </div>

    <div class="c-toasts" aria-live="polite" aria-atomic="true"></div>
</layout:moderator-dashboard>
