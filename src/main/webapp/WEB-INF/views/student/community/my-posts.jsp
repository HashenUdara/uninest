<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Edit Resource" activePage="resources">
         <link rel="stylesheet" href="${pageContext.request.contextPath}/static/community.css" />
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
                  <a href="${pageContext.request.contextPath}/student/community/new-post" class="c-btn c-btn--secondary"
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
                  My Posts (<span class="js-post-count">3</span>)
                </h3>
              </div>
              <div class="c-posts">
                <!-- My Post 1: text -->
                <article
                  class="c-post c-post--text c-post--mine"
                  data-type="text"
                  data-subject="CS204"
                  data-post-id="1"
                >
                  <div class="c-post__head">
                    <div class="c-avatar-sm">
                      <img
                        alt="Sophia Clark"
                        src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3ESC%3C/text%3E%3C/svg%3E"
                      />
                    </div>
                    <div style="flex: 1">
                      <strong>Sophia Clark (You)</strong>
                      <div class="c-post__meta">2d ago • CS204</div>
                    </div>
                    <div class="c-post__manage">
                      <a
                        href="${pageContext.request.contextPath}/student/community/edit-post?id=1"
                        class="c-btn c-btn--ghost c-btn--sm"
                        aria-label="Edit post"
                        ><i data-lucide="edit-2"></i
                      ></a>
                      <button
                        class="c-btn c-btn--ghost c-btn--sm js-delete-post"
                        aria-label="Delete post"
                        data-post-id="1"
                      >
                        <i data-lucide="trash-2"></i>
                      </button>
                    </div>
                  </div>
                  <p class="u-text-muted">
                    Anyone has tips for CS204 lab 3? I'm stuck on the stack
                    implementation edge cases. Would really appreciate some
                    guidance on handling null pointers!
                  </p>
                  <div class="c-post__actions">
                    <button
                      class="c-btn c-btn--ghost c-btn--sm js-upvote"
                      aria-label="Upvote"
                    >
                      <i data-lucide="thumbs-up"></i
                      ><span class="js-score">5</span>
                    </button>
                    <button
                      class="c-btn c-btn--ghost c-btn--sm"
                      aria-label="Comments"
                    >
                      <i data-lucide="message-square"></i>4
                    </button>
                    <button
                      class="c-btn c-btn--ghost c-btn--sm js-downvote"
                      aria-label="Downvote"
                    >
                      <i data-lucide="thumbs-down"></i>
                    </button>
                  </div>
                </article>

                <!-- My Post 2: image -->
                <article
                  class="c-post c-post--image c-post--mine"
                  data-type="image"
                  data-subject="CS301"
                  data-post-id="2"
                >
                  <div class="c-post__head">
                    <div class="c-avatar-sm">
                      <img
                        alt="Sophia Clark"
                        src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3ESC%3C/text%3E%3C/svg%3E"
                      />
                    </div>
                    <div style="flex: 1">
                      <strong>Sophia Clark (You)</strong>
                      <div class="c-post__meta">1w ago • CS301</div>
                    </div>
                    <div class="c-post__manage">
                      <a
                        href="${pageContext.request.contextPath}/student/community/edit-post?id=2"
                        class="c-btn c-btn--ghost c-btn--sm"
                        aria-label="Edit post"
                        ><i data-lucide="edit-2"></i
                      ></a>
                      <button
                        class="c-btn c-btn--ghost c-btn--sm js-delete-post"
                        aria-label="Delete post"
                        data-post-id="2"
                      >
                        <i data-lucide="trash-2"></i>
                      </button>
                    </div>
                  </div>
                  <p class="u-text-muted">
                    My notes on dynamic programming patterns - hope this helps
                    someone preparing for the exam!
                  </p>
                  <div class="c-post__image">
                    <img
                      src="${pageContext.request.contextPath}/static/img/1.avif"
                      alt="DP patterns notes"
                    />
                  </div>
                  <div class="c-post__actions">
                    <button
                      class="c-btn c-btn--ghost c-btn--sm js-upvote"
                      aria-label="Upvote"
                    >
                      <i data-lucide="thumbs-up"></i
                      ><span class="js-score">18</span>
                    </button>
                    <button
                      class="c-btn c-btn--ghost c-btn--sm"
                      aria-label="Comments"
                    >
                      <i data-lucide="message-square"></i>7
                    </button>
                    <button
                      class="c-btn c-btn--ghost c-btn--sm js-downvote"
                      aria-label="Downvote"
                    >
                      <i data-lucide="thumbs-down"></i>
                    </button>
                  </div>
                </article>

                <!-- My Post 3: text -->
                <article
                  class="c-post c-post--text c-post--mine"
                  data-type="text"
                  data-subject="CS123"
                  data-post-id="3"
                >
                  <div class="c-post__head">
                    <div class="c-avatar-sm">
                      <img
                        alt="Sophia Clark"
                        src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3ESC%3C/text%3E%3C/svg%3E"
                      />
                    </div>
                    <div style="flex: 1">
                      <strong>Sophia Clark (You)</strong>
                      <div class="c-post__meta">2w ago • CS123</div>
                    </div>
                    <div class="c-post__manage">
                      <a
                        href="${pageContext.request.contextPath}/student/community/edit-post?id=3"
                        class="c-btn c-btn--ghost c-btn--sm"
                        aria-label="Edit post"
                        ><i data-lucide="edit-2"></i
                      ></a>
                      <button
                        class="c-btn c-btn--ghost c-btn--sm js-delete-post"
                        aria-label="Delete post"
                        data-post-id="3"
                      >
                        <i data-lucide="trash-2"></i>
                      </button>
                    </div>
                  </div>
                  <p class="u-text-muted">
                    Looking for study partners for the final project. Anyone
                    interested in forming a team?
                  </p>
                  <div class="c-post__actions">
                    <button
                      class="c-btn c-btn--ghost c-btn--sm js-upvote"
                      aria-label="Upvote"
                    >
                      <i data-lucide="thumbs-up"></i
                      ><span class="js-score">9</span>
                    </button>
                    <button
                      class="c-btn c-btn--ghost c-btn--sm"
                      aria-label="Comments"
                    >
                      <i data-lucide="message-square"></i>12
                    </button>
                    <button
                      class="c-btn c-btn--ghost c-btn--sm js-downvote"
                      aria-label="Downvote"
                    >
                      <i data-lucide="thumbs-down"></i>
                    </button>
                  </div>
                </article>
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
            if (e.target.matches("[data-close]")) {
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
          confirmBtn?.addEventListener("click", () => {
            if (pendingDeleteId) {
              const post = document.querySelector(
                `.c-post[data-post-id="${pendingDeleteId}"]`
              );
              if (post) {
                post.remove();
                updatePostCount();
                showToast("Post deleted successfully");
              }
              pendingDeleteId = null;
            }
            modal.hidden = true;
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
