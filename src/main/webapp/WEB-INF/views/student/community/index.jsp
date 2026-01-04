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
    
    /* Vote Pill Styles */
    .c-vote-pill {
      display: inline-flex;
      align-items: center;
      background-color: #27272a; /* Zinc-800 */
      border-radius: 9999px;
      padding: 0;
      border: 1px solid rgba(255,255,255,0.05);
    }

    .c-vote-pill .c-btn {
      background: transparent !important; /* Override default ghost btn bg */
      border: none !important;
      color: #a1a1aa; /* Zinc-400 */
      padding: 6px 12px;
      border-radius: 9999px;
      display: flex;
      align-items: center;
      gap: 6px;
      height: 36px;
      transition: all 0.2s ease;
    }

    .c-vote-pill .c-btn:hover {
      background-color: rgba(255, 255, 255, 0.1) !important;
      color: #fff;
    }

    .c-vote-pill .c-btn.is-active {
      color: #fff;
      font-weight: 500;
    }

    /* Fill the icon when active */
    .c-vote-pill .c-btn.is-active svg {
      fill: currentColor;
      stroke: currentColor;
    }

    .c-vote-divider {
      width: 1px;
      height: 20px;
      background-color: #3f3f46; /* Zinc-700 */
    }
    
    /* Adjust actions container to align items */
    .c-post__actions {
        display: flex;
        align-items: center;
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
          <a href="${pageContext.request.contextPath}/student/community?sort=upvoted" 
             class="${currentSort == 'upvoted' ? 'is-active' : ''}">Most Upvoted</a>
          <a href="${pageContext.request.contextPath}/student/community?sort=recent" 
             class="${currentSort == 'recent' ? 'is-active' : ''}">Most Recent</a>
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
                    <!-- Vote Pill -->
                    <div class="c-vote-pill">
                        <button
                          class="c-btn js-vote-btn ${post.userVote == 1 ? 'is-active' : ''}"
                          data-id="${post.id}"
                          data-type="1"
                          aria-label="Upvote"
                        >
                          <i data-lucide="thumbs-up"></i>
                          <span class="js-count-up">${post.upvoteCount}</span>
                        </button>
                        
                        <div class="c-vote-divider"></div>
                        
                        <button
                          class="c-btn js-vote-btn ${post.userVote == -1 ? 'is-active' : ''}"
                          data-id="${post.id}"
                          data-type="-1"
                          aria-label="Downvote"
                        >
                          <i data-lucide="thumbs-down"></i>
                          <span class="js-count-down">${post.downvoteCount}</span>
                        </button>
                    </div>

                    <a
                      href="${pageContext.request.contextPath}/student/community/post-details?id=${post.id}"
                      class="c-btn c-btn--ghost c-btn--sm"
                      aria-label="Comments"
                    >
                      <i data-lucide="message-square"></i>${post.commentCount}
                    </a>
                  </div>
                </article>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </div>
      </section>
    </div>

    <aside class="c-right-panel">
      <!-- ... (existing sidebar content) ... -->
      <section class="c-right-section">
        <h3 class="c-section-title" style="margin-top: 0">Subjects</h3>
        <!-- ... -->
      </section>
    </aside>
  </div>
</layout:student-dashboard>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const voteBtns = document.querySelectorAll('.js-vote-btn');
  
  voteBtns.forEach(btn => {
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      const postId = this.dataset.id;
      const type = parseInt(this.dataset.type);
      
      const container = this.closest('.c-post__actions');
      const upSpan = container.querySelector('.js-count-up');
      const downSpan = container.querySelector('.js-count-down');

      if (!upSpan || !downSpan) return;

      // Prevent multiple clicks
      const allBtns = container.querySelectorAll('.js-vote-btn');
      allBtns.forEach(b => b.disabled = true);

      // Send AJAX request
      fetch('${pageContext.request.contextPath}/student/community/vote', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'postId=' + postId + '&type=' + type
      })
      .then(response => response.json())
      .then(data => {
        if (!data.success) {
           alert('Vote failed: ' + (data.error || 'Unknown error'));
        } else {
            // Update counts from server source of truth
            upSpan.innerText = data.newUpvoteCount;
            downSpan.innerText = data.newDownvoteCount;

            // Update Active State
            const upBtn = container.querySelector('[data-type="1"]');
            const downBtn = container.querySelector('[data-type="-1"]');
            
            upBtn.classList.remove('is-active');
            downBtn.classList.remove('is-active');

            if (data.userVote === 1) {
                upBtn.classList.add('is-active');
            } else if (data.userVote === -1) {
                downBtn.classList.add('is-active');
            }
        }
      })
      .catch(err => {
        console.error('Fetch error:', err);
        alert('Network error. Check console.');
      })
      .finally(() => {
          // Re-enable buttons
          allBtns.forEach(b => b.disabled = false);
      });
    });
  });
});
</script>
