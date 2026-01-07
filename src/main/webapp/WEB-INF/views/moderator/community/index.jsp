<%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="layout"
tagdir="/WEB-INF/tags/layouts" %> <%@ taglib prefix="dash"
tagdir="/WEB-INF/tags/dashboard" %>

<layout:moderator-dashboard pageTitle="Community Management" activePage="community">
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
      <a href="${pageContext.request.contextPath}/moderator/dashboard">Home</a>
      <span class="c-breadcrumbs__sep">/</span>
      <a href="${pageContext.request.contextPath}/moderator/community"
        >Community Management</a
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
            <h1 class="c-page__title">Community Feed</h1>
            <p class="c-page__subtitle u-text-muted">
              Overview of all student discussions.
            </p>
          </div>
          <!-- New Post button hidden for moderator view -->
        </div>
        <nav class="c-tabs-line" aria-label="Filter">
          <a href="#" class="is-active">Most Upvoted</a>
          <a href="#">Most Recent</a>
          <a href="#">Unanswered</a>
          <!-- My Posts hidden for moderator -->
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
                No posts found.
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

                  <div class="c-post__body">
                    <h4 class="c-post__title">
                        <a href="${pageContext.request.contextPath}/moderator/community/post?id=${post.id}" style="color: inherit; text-decoration: none;">
                          ${post.title}
                        </a>
                    </h4>
                    <p class="u-text-muted">${post.content}</p>
                    <c:if test="${not empty post.imageUrl}">
                        <div class="c-post__image">
                        <img
                            src="${pageContext.request.contextPath}/uploads/${post.imageUrl}"
                            alt="Post image"
                        />
                        </div>
                    </c:if>
                  </div>
                  
                  <div class="c-post__actions">
                    <div class="c-btn c-btn--ghost c-btn--sm" style="cursor: default;">
                      <i data-lucide="thumbs-up"></i>
                      <span>${post.likeCount}</span>
                    </div>
                    <a
                      href="${pageContext.request.contextPath}/moderator/community/post?id=${post.id}"
                      class="c-btn c-btn--ghost c-btn--sm"
                      aria-label="Comments"
                    >
                      <i data-lucide="message-square"></i>${post.commentCount}
                    </a>
                    <!-- Delete button for moderator could be added here in future -->
                  </div>
                </article>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </div>
      </section>
    </div>

    <aside class="c-right-panel">
      <!-- Right panel content -->
    </aside>
  </div>
</layout:moderator-dashboard>
