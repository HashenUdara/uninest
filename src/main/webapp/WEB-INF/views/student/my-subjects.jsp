<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:student-dashboard title="My Subjects" active="subjects">
  <nav class="c-breadcrumb" aria-label="Breadcrumb">
    <a href="#">Home</a>
    <span aria-hidden="true">/</span>
    <a href="#">CS204</a>
    <span aria-hidden="true">/</span>
    <span class="u-text-muted">Trees &amp; Graphs</span>
  </nav>

  <h1 class="c-page-title" id="page-title">My Subjects</h1>

  <div class="c-search-row">
    <div class="c-input" role="search">
      <i data-lucide="search" aria-hidden="true"></i>
      <input type="search" placeholder="Search subjects by name or code" aria-label="Search subjects" />
    </div>
    <button class="c-btn">Search</button>
  </div>

  <div class="c-tabs" role="tablist">
    <button class="c-tabs__item is-active" role="tab" aria-selected="true">All</button>
    <button class="c-tabs__item" role="tab">In Progress</button>
    <button class="c-tabs__item" role="tab">Completed</button>
  </div>

  <section class="c-section" aria-labelledby="sem3">
    <h2 class="c-section__title" id="sem3">Semester 3</h2>
    <div class="c-card-grid">
      <article class="c-card">
        <div class="c-card__media"><img src="${pageContext.request.contextPath}/static/placeholder/subject-1.png" alt="" /></div>
        <div class="c-card__body">
          <h3 class="c-card__title">CS204 - Data Structures</h3>
          <p class="c-card__meta">Instructor: Dr. Evelyn Reed</p>
        </div>
      </article>
      <article class="c-card">
        <div class="c-card__media"><img src="${pageContext.request.contextPath}/static/placeholder/subject-2.png" alt="" /></div>
        <div class="c-card__body">
          <h3 class="c-card__title">MA201 - Calculus II</h3>
          <p class="c-card__meta">Instructor: Prof. Samuel Harper</p>
        </div>
      </article>
      <article class="c-card">
        <div class="c-card__media"><img src="${pageContext.request.contextPath}/static/placeholder/subject-3.png" alt="" /></div>
        <div class="c-card__body">
          <h3 class="c-card__title">PH102 - Physics for Engineers</h3>
          <p class="c-card__meta">Instructor: Dr. Olivia Bennett</p>
        </div>
      </article>
    </div>
  </section>

  <section class="c-section" aria-labelledby="sem4">
    <h2 class="c-section__title" id="sem4">Semester 4</h2>
    <div class="c-card-grid">
      <article class="c-card">
        <div class="c-card__media"><img src="${pageContext.request.contextPath}/static/placeholder/subject-4.png" alt="" /></div>
        <div class="c-card__body">
          <h3 class="c-card__title">CS205 - Algorithms</h3>
          <p class="c-card__meta">Instructor: Dr. Evelyn Reed</p>
        </div>
      </article>
      <article class="c-card">
        <div class="c-card__media"><img src="${pageContext.request.contextPath}/static/placeholder/subject-5.png" alt="" /></div>
        <div class="c-card__body">
          <h3 class="c-card__title">EE201 - Circuit Analysis</h3>
          <p class="c-card__meta">Instructor: Prof. Ethan Carter</p>
        </div>
      </article>
      <article class="c-card">
        <div class="c-card__media"><img src="${pageContext.request.contextPath}/static/placeholder/subject-6.png" alt="" /></div>
        <div class="c-card__body">
          <h3 class="c-card__title">LA101 - Technical Writing</h3>
          <p class="c-card__meta">Instructor: Dr. Sophia Turner</p>
        </div>
      </article>
    </div>
  </section>
</layout:student-dashboard>
