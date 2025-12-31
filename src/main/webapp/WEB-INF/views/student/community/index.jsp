<%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="layout"
tagdir="/WEB-INF/tags/layouts" %> <%@ taglib prefix="dash"
tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Community" activePage="community">
  <link
    rel="stylesheet"
    href="${pageContext.request.contextPath}/static/community.css"
  />
  <style>
    .c-form-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: var(--space-4);
    }
  </style>
  <header class="c-page__header">
    <nav class="c-breadcrumbs" aria-label="Breadcrumb">
      <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
      <span class="c-breadcrumbs__sep">/</span>
      <a href="${pageContext.request.contextPath}/student/community"
        >Community</a
      >
    </nav>
  </header>

  <c:if test="${not empty error}">
    <div class="c-alert c-alert--danger" role="alert">
      <p>${error}</p>
    </div>
  </c:if>

  <div class="comm-layout">
    <div class="o-feed">
      <header class="c-page__header">
        <div
          class="o-inline"
          style="
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: var(--space-4);
          "
        >
          <div>
            <h1 class="c-page__title">Community</h1>
            <p class="c-page__subtitle u-text-muted">
              Stay updated with the latest discussions and resources from your
              peers.
            </p>
          </div>
          <a
            href="${pageContext.request.contextPath}/student/community/posts/create"
            class="c-btn c-btn--secondary"
            ><i data-lucide="plus"></i> New Post</a
          >
        </div>
        <nav class="c-tabs-line" aria-label="Filter">
          <a href="#" class="is-active">Most Upvoted</a>
          <a href="#">Most Recent</a>
          <a href="#">Unanswered</a>
          <a
            href="${pageContext.request.contextPath}/student/community/my-posts"
            >My Posts</a
          >
        </nav>
        <!-- Filters -->
        <div
          class="c-filters u-stack-2"
          role="search"
          style="margin-top: var(--space-4)"
        >
          <div
            class="o-inline"
            style="display: flex; gap: var(--space-3); flex-wrap: wrap"
          >
            <input
              type="search"
              class="c-input c-input--soft js-post-search"
              placeholder="Search posts"
              aria-label="Search posts"
              style="min-width: 220px"
            />
          </div>
        </div>
      </header>

      <section class="u-stack-4">
        <h3 class="c-section-title" style="margin-top: 0">Pinned Posts</h3>
      </section>

      <!-- Latest posts -->
      <section class="u-stack-4">
        <h3 class="c-section-title">Latest Posts</h3>
        <div class="c-posts">
          <c:choose>
            <c:when test="${empty posts}">
              <p class="u-text-muted">
                No posts yet. Be the first to share something!
              </p>
            </c:when>
            <c:otherwise>
              <c:forEach var="post" items="${posts}">
                <article
                  class="c-post ${not empty post.imageUrl ? 'c-post--image' : 'c-post--text'}"
                >
                  <div class="c-post__head">
                    <div class="c-avatar-sm">
                      <c:set
                        var="initials"
                        value="${fn:substring(post.authorName, 0, 1)}${fn:substring(fn:substringAfter(post.authorName, ' '), 0, 1)}"
                      />
                      <img
                        alt="${post.authorName}"
                        src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3E${fn:toUpperCase(initials)}%3C/text%3E%3C/svg%3E"
                      />
                    </div>
                    <div>
                      <strong>${post.authorName}</strong>
                      <div class="c-post__meta">
                        <fmt:formatDate
                          value="${post.createdAt}"
                          pattern="MMM d, yyyy"
                        />
                      </div>
                    </div>
                  </div>
                  <h4 class="c-post__title">${post.title}</h4>
                  <p class="u-text-muted">${post.content}</p>
                  <c:if test="${not empty post.imageUrl}">
                    <div class="c-post__image">
                      <img
                        src="${pageContext.request.contextPath}/uploads/${post.imageUrl}"
                        alt="Post image"
                      />
                    </div>
                  </c:if>
                  <div class="c-post__actions">
                    <button
                      class="c-btn c-btn--ghost c-btn--sm js-upvote"
                      aria-label="Upvote"
                    >
                      <i data-lucide="thumbs-up"></i
                      ><span class="js-score">${post.likeCount}</span>
                    </button>
                    <a
                      href="${pageContext.request.contextPath}/student/community/post-details?id=${post.id}"
                      class="c-btn c-btn--ghost c-btn--sm"
                      aria-label="Comments"
                    >
                      <i data-lucide="message-square"></i>${post.commentCount}
                    </a>
                    <button
                      class="c-btn c-btn--ghost c-btn--sm js-downvote"
                      aria-label="Downvote"
                    >
                      <i data-lucide="thumbs-down"></i>
                    </button>
                  </div>
                </article>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </div>
      </section>
    </div>

    <aside class="c-right-panel">
      <section class="c-right-section">
        <h3 class="c-section-title" style="margin-top: 0">Subjects</h3>
        <ul class="c-subjects" role="list">
          <li>
            <a
              href="${pageContext.request.contextPath}/student/community/subject?subject=CS204"
              class="c-subject"
            >
              <span class="c-subject__badge is-lavender">CS204</span>
              <span class="c-subject__text">
                <span class="c-subject__label">Data Structures</span>
                <span class="c-subject__sub">CS204</span>
              </span>
            </a>
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/student/community/subject?subject=CS301"
              class="c-subject"
            >
              <span class="c-subject__badge is-mint">CS301</span>
              <span class="c-subject__text">
                <span class="c-subject__label">Algorithms</span>
                <span class="c-subject__sub">CS301</span>
              </span>
            </a>
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/student/community/subject?subject=CS123"
              class="c-subject"
            >
              <span class="c-subject__badge is-lime">CS123</span>
              <span class="c-subject__text">
                <span class="c-subject__label">Programming Fundamentals</span>
                <span class="c-subject__sub">CS123</span>
              </span>
            </a>
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/student/community/subject?subject=CS205"
              class="c-subject"
            >
              <span class="c-subject__badge is-lavender">CS205</span>
              <span class="c-subject__text">
                <span class="c-subject__label">Operating Systems</span>
                <span class="c-subject__sub">CS205</span>
              </span>
            </a>
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/student/community/subject?subject=MA201"
              class="c-subject"
            >
              <span class="c-subject__badge is-mint">MA201</span>
              <span class="c-subject__text">
                <span class="c-subject__label">Calculus II</span>
                <span class="c-subject__sub">MA201</span>
              </span>
            </a>
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/student/community/subject?subject=ENG101"
              class="c-subject"
            >
              <span class="c-subject__badge is-lime">ENG101</span>
              <span class="c-subject__text">
                <span class="c-subject__label">English Composition</span>
                <span class="c-subject__sub">ENG101</span>
              </span>
            </a>
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/student/community/subject?subject=PHY110"
              class="c-subject"
            >
              <span class="c-subject__badge is-lavender">PHY110</span>
              <span class="c-subject__text">
                <span class="c-subject__label">Physics I</span>
                <span class="c-subject__sub">PHY110</span>
              </span>
            </a>
          </li>
        </ul>
      </section>
      <section class="c-right-section">
        <h3 class="c-section-title">Trending</h3>
        <div class="c-tags">
          <a href="#" class="c-tag">Recursion</a>
          <a href="#" class="c-tag">Linked Lists</a>
          <a href="#" class="c-tag">Derivatives</a>
          <a href="#" class="c-tag">Big-O</a>
        </div>
      </section>
    </aside>
  </div>
</layout:student-dashboard>
