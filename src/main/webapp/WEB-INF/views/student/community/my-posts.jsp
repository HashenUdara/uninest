<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Community" activePage="community">
         <link rel="stylesheet" href="${pageContext.request.contextPath}/static/community.css" />
        <style>
            .c-form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: var(--space-4);
            }
            
            /* Modal overlay and content styling for better visibility */
            #delete-modal .c-modal__overlay {
                position: fixed !important;
                inset: 0 !important;
                background: rgba(0, 0, 0, 0.85) !important; /* Very dark overlay */
                backdrop-filter: blur(4px);
                z-index: 9998 !important;
            }
            
            #delete-modal .c-modal__content {
                position: relative !important;
                width: min(520px, 92vw) !important;
                background: #ffffff !important; /* Force solid white background */
                border: 1px solid #e2e8f0 !important;
                border-radius: 12px !important;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25) !important;
                z-index: 9999 !important;
                color: #000000 !important; /* Force black text */
            }
            
            #delete-modal .c-modal__header {
                padding: 1.25rem;
                border-bottom: 1px solid #e2e8f0;
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: #fff !important;
                border-radius: 12px 12px 0 0;
            }
            
            #delete-modal .c-modal__header h2 {
                margin: 0;
                font-size: 1.25rem;
                font-weight: 600;
                color: #1a202c !important;
            }
            
            #delete-modal .c-modal__body {
                padding: 1.5rem;
                color: #4a5568 !important;
                line-height: 1.6;
                background: #fff !important;
                font-size: 1rem;
            }
            
            #delete-modal .c-modal__footer {
                padding: 1.25rem;
                display: flex;
                justify-content: flex-end;
                gap: 0.75rem;
                border-top: 1px solid #e2e8f0;
                background: #f7fafc !important;
                border-radius: 0 0 12px 12px;
            }


            /* Ensure modal container sits on top - BUT ONLY WHEN NOT HIDDEN */
            #delete-modal:not([hidden]) {
                z-index: 9999 !important;
                position: fixed !important;
                inset: 0 !important;
                display: grid !important;
                place-items: center !important;
            }
            
            /* Ensure it stays hidden when it has the hidden attribute */
            #delete-modal[hidden] {
                display: none !important;
            }
        </style>
    <header class="c-page__header">
        <nav class="c-breadcrumbs" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
            <span class="c-breadcrumbs__sep">/</span>
            <a href="${pageContext.request.contextPath}/student/community">Community</a>
            
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
                 <h1 class="c-page__title">My Posts</h1>
                  <p class="c-page__subtitle u-text-muted">
                    View, edit, and manage all your community posts.
                  </p>
                </div>
                <div style="display: flex; gap: var(--space-2)">
                  <a href="${pageContext.request.contextPath}/student/community" class="c-btn c-btn--ghost"
                    ><i data-lucide="arrow-left"></i> All Posts</a
                  >
                  <a href="${pageContext.request.contextPath}/student/community/posts/create" class="c-btn c-btn--secondary"
                  ><i data-lucide="plus"></i> New Post</a
                >
                </div>
              </div>

              <nav class="c-tabs-line" aria-label="Filter">
                <a href="${pageContext.request.contextPath}/student/community"  >Most Upvoted</a>
                <a href="${pageContext.request.contextPath}/student/community" >Most Recent</a>
                <a href="${pageContext.request.contextPath}/student/community" >Unanswered</a>
                <a href="${pageContext.request.contextPath}/student/community/my-posts" class="is-active">My Posts</a>
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
                    placeholder="Search my posts"
                    aria-label="Search posts"
                    style="min-width: 220px"
                  />
                  <select
                    class="c-input c-input--soft js-post-subject"
                    aria-label="Filter by subject"
                  >
                    <option value="">All subjects</option>
                  </select>
                  <select
                    class="c-input c-input--soft js-post-type"
                    aria-label="Filter by type"
                  >
                    <option value="">All types</option>
                    <option value="text">Text</option>
                    <option value="image">Image</option>
                  </select>
                </div>
              </div>
            </header>

          <section class="u-stack-4">
              <div
                class="o-inline"
                style="
                  display: flex;
                  justify-content: space-between;
                  align-items: center;
                "
              >
                <h3 class="c-section-title" style="margin-top: 0">
                  My Posts (<span class="js-post-count">${posts.size()}</span>)
                </h3>
              </div>
              <div class="c-posts">
                <c:choose>
                  <c:when test="${empty posts}">
                    <div class="c-empty-state" style="text-align: center; padding: var(--space-8);">
                      <i data-lucide="file-text" style="width: 48px; height: 48px; color: var(--c-text-muted);"></i>
                      <p class="u-text-muted" style="margin-top: var(--space-4);">You haven't created any posts yet.</p>
                      <a href="${pageContext.request.contextPath}/student/community/posts/create" class="c-btn c-btn--secondary" style="margin-top: var(--space-4);">
                        <i data-lucide="plus"></i> Create Your First Post
                      </a>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <c:forEach var="post" items="${posts}">
                      <article
                        class="c-post c-post--${not empty post.imageUrl ? 'image' : 'text'} c-post--mine ${post.deleted ? 'c-post--deleted' : ''}"
                        data-type="${not empty post.imageUrl ? 'image' : 'text'}"
                        data-post-id="${post.id}"
                        style="${post.deleted ? 'opacity: 0.6; filter: grayscale(0.5);' : ''}"
                      >
                        <div class="c-post__head">
                          <div class="c-avatar-sm">
                            <img
                              alt="${authUser.name}"
                              src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3E${authUser.name.substring(0,1)}${authUser.name.contains(' ') ? authUser.name.substring(authUser.name.indexOf(' ')+1, authUser.name.indexOf(' ')+2) : ''}%3C/text%3E%3C/svg%3E"
                            />
                          </div>
                          <div style="flex: 1">
                            <strong>${authUser.name} (You)</strong>
                             <c:if test="${post.deleted}">
                                <span class="c-badge c-badge--danger" style="margin-left: var(--space-2); font-size: 0.7rem; vertical-align: middle;">Deleted</span>
                            </c:if>
                            <div class="c-post__meta">
                              <fmt:formatDate value="${post.createdAt}" pattern="MMM d, yyyy"/>
                            </div>
                            <c:if test="${not empty post.topic}">
                              <span class="c-topic-badge">${post.topic}</span>
                            </c:if>
                          </div>
                          <c:if test="${!post.deleted}">
                              <div class="c-post__manage">
                                <a
                                  href="${pageContext.request.contextPath}/student/community/edit-post?id=${post.id}"
                                  class="c-btn c-btn--ghost c-btn--sm"
                                  aria-label="Edit post"
                                  ><i data-lucide="edit-2"></i
                                ></a>
                                <button
                                  class="c-btn c-btn--ghost c-btn--sm js-delete-post"
                                  aria-label="Delete post"
                                  data-post-id="${post.id}"
                                >
                                  <i data-lucide="trash-2"></i>
                                </button>
                              </div>
                          </c:if>
                        </div>
                        <h4 class="c-post__title">
                            <a href="${pageContext.request.contextPath}/student/community/post?id=${post.id}" style="color: inherit; text-decoration: none;">
                                ${post.title}
                            </a>
                        </h4>
                        <p class="u-text-muted" style="${post.deleted ? 'text-decoration: line-through; opacity: 0.5;' : ''}">
                          <c:out value="${post.content}"/>
                        </p>
                        <c:if test="${post.deleted}">
                            <div style="display: flex; align-items: center; gap: var(--space-2); color: #ef4444; font-size: 0.85rem; font-weight: 500; padding: var(--space-2); background: rgba(239, 68, 68, 0.05); border-radius: 6px; margin-top: 1rem;">
                                <i data-lucide="info" style="width: 14px; height: 14px;"></i>
                                Deletion Reason: <c:out value="${post.deletionReason != null ? post.deletionReason : 'No reason provided'}"/>
                            </div>
                        </c:if>
                        <c:if test="${not empty post.imageUrl}">
                          <div class="c-post__image">
                            <img
                              src="${pageContext.request.contextPath}/uploads/${post.imageUrl}"
                              alt="${post.title}"
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
                            href="${pageContext.request.contextPath}/student/community/post?id=${post.id}"
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
                      <span class="c-subject__label"
                        >Programming Fundamentals</span
                      >
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

          <!-- Delete Confirmation Modal -->
    <div id="delete-modal" class="c-modal" hidden>
      <div class="c-modal__overlay" data-close></div>
      <div
        class="c-modal__content"
        role="dialog"
        aria-labelledby="delete-title"
      >
        <header class="c-modal__header">
          <h2 id="delete-title">Delete Post</h2>
          <button class="c-modal__close" data-close aria-label="Close">
            <i data-lucide="x"></i>
          </button>
        </header>
        <div class="c-modal__body">
          <p>
            Are you sure you want to delete this post? This action cannot be
            undone.
          </p>
        </div>
        <footer class="c-modal__footer">
          <button class="c-btn c-btn--ghost" data-close>Cancel</button>
          <button class="c-btn c-btn--danger js-confirm-delete">Delete</button>
        </footer>
      </div>
    </div>

    <!-- Toast Container -->
    <div class="c-toasts" aria-live="polite"></div>

<script>
      document.addEventListener("DOMContentLoaded", function () {
        if (window.lucide) window.lucide.createIcons();

        const modal = document.getElementById("delete-modal");
        const toasts = document.querySelector(".c-toasts");
        let pendingDeleteId = null;

        // Delete button click
        document.addEventListener("click", (e) => {
          const delBtn = e.target.closest(".js-delete-post");
          if (!delBtn) return;
          pendingDeleteId = delBtn.getAttribute("data-post-id");
          if (modal) {
            modal.hidden = false;
            modal.querySelector(".js-confirm-delete")?.focus();
          }
        });

        // Close modal
        if (modal) {
          modal.addEventListener("click", (e) => {
            if (e.target.closest("[data-close]")) {
              modal.hidden = true;
              pendingDeleteId = null;
            }
          });
          document.addEventListener("keydown", (e) => {
            if (!modal.hidden && e.key === "Escape") {
              modal.hidden = true;
              pendingDeleteId = null;
            }
          });


          // Confirm delete
          const confirmBtn = modal.querySelector(".js-confirm-delete");
          confirmBtn?.addEventListener("click", async () => {
            if (pendingDeleteId) {
              try {
                // Disable button during request
                confirmBtn.disabled = true;
                confirmBtn.textContent = "Deleting...";

                // Make AJAX request to backend
                const response = await fetch(
                  "${pageContext.request.contextPath}/student/community/posts/delete",
                  {
                    method: "POST",
                    headers: {
                      "Content-Type": "application/x-www-form-urlencoded",
                    },
                    body: "postId=" + pendingDeleteId,
                  }
                );

                const data = await response.json();

                if (response.ok && data.success) {
                  showToast("Post deleted successfully");
                  modal.hidden = true;
                  
                  // Automatically reload the page after a short delay
                  setTimeout(() => {
                    window.location.reload();
                  }, 800);
                } else {
                  // Show error message from server
                  showToast(data.message || "Failed to delete post");
                  confirmBtn.disabled = false;
                  confirmBtn.textContent = "Delete";
                }
              } catch (error) {
                console.error("Error deleting post:", error);
                showToast("An error occurred while deleting the post");
                confirmBtn.disabled = false;
                confirmBtn.textContent = "Delete";
              } finally {
                pendingDeleteId = null;
              }
            }
          });
        }

        function updatePostCount() {
          const count = document.querySelectorAll(".c-post").length;
          const countEl = document.querySelector(".js-post-count");
          if (countEl) countEl.textContent = String(count);
        }

        function showToast(msg) {
          if (!toasts) return;
          const item = document.createElement("div");
          item.className = "c-toast";
          item.textContent = msg;
          toasts.appendChild(item);
          setTimeout(() => {
            item.remove();
          }, 2500);
        }
      });
    </script>
       
</layout:student-dashboard>
